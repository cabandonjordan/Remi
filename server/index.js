require('dotenv').config();

const crypto = require('crypto');
const express = require('express');

const app = express();
const PORT = process.env.PORT || 3000;
const ENVELOPE_ALGORITHM = 'aes-256-gcm';
const MASTER_KEY = process.env.REMI_E2EE_KEY || process.env.APP_MASTER_KEY || '';

app.disable('x-powered-by');
app.use(express.json({ limit: '10mb' }));

app.use((req, res, next) => {
  res.setHeader('Cache-Control', 'no-store');
  res.setHeader('Pragma', 'no-cache');
  res.setHeader('X-Content-Type-Options', 'nosniff');
  res.setHeader('Referrer-Policy', 'no-referrer');
  next();
});

function safeHash(input) {
  return crypto.createHash('sha256').update(String(input)).digest('hex');
}

function fingerprintEnvelope(envelope) {
  return safeHash(JSON.stringify({
    iv: envelope.iv,
    ciphertext: envelope.ciphertext,
    tag: envelope.tag,
    keyId: envelope.keyId || 'default',
  }));
}

function isEncryptedEnvelope(value) {
  return Boolean(
    value
    && typeof value === 'object'
    && typeof value.iv === 'string'
    && typeof value.ciphertext === 'string'
    && typeof value.tag === 'string'
  );
}

function requireE2EE(req, res, next) {
  const envelope = req.body?.envelope;

  if (!isEncryptedEnvelope(envelope)) {
    return res.status(400).json({
      error: 'Encrypted envelope required',
      detail: 'Send only ciphertext, iv, and tag. Do not submit plaintext PHI to the server.',
    });
  }

  req.envelope = envelope;
  req.envelopeFingerprint = fingerprintEnvelope(envelope);
  next();
}

function redactSensitiveFields(payload) {
  if (!payload || typeof payload !== 'object') {
    return payload;
  }

  const redacted = Array.isArray(payload) ? [] : {};
  const sensitiveKeys = new Set([
    'name',
    'email',
    'phone',
    'address',
    'photo',
    'image',
    'imageData',
    'notes',
    'symptoms',
    'pain',
    'temperature',
    'swelling',
    'healthToken',
    'token',
  ]);

  for (const [key, value] of Object.entries(payload)) {
    if (sensitiveKeys.has(key)) {
      redacted[key] = '[REDACTED]';
    } else if (value && typeof value === 'object') {
      redacted[key] = redactSensitiveFields(value);
    } else {
      redacted[key] = value;
    }
  }

  return redacted;
}

function secureTokenHash(token) {
  if (!token) {
    return null;
  }

  return crypto
    .createHmac('sha256', MASTER_KEY || 'remi-anon-key')
    .update(String(token))
    .digest('hex');
}

function buildSafeAcknowledgement(envelope, payloadMeta = {}) {
  return {
    ok: true,
    e2ee: true,
    receivedAt: new Date().toISOString(),
    envelopeFingerprint: fingerprintEnvelope(envelope),
    storedPlaintext: false,
    routing: 'opaque-envelope-only',
    payloadMeta,
  };
}

app.get('/', (req, res) => {
  res.json({
    ok: true,
    service: 'Remi API',
    privacy: 'PHI-safe envelope mode enabled',
    e2eeConfigured: Boolean(MASTER_KEY),
  });
});

app.get('/health', (req, res) => {
  res.json({ ok: true, status: 'healthy' });
});

app.post('/v1/secure/ingest', requireE2EE, (req, res) => {
  const payload = req.body?.meta || {};
  const safeMeta = redactSensitiveFields(payload);

  if (payload.healthToken) {
    safeMeta.healthTokenHash = secureTokenHash(payload.healthToken);
    delete safeMeta.healthToken;
  }

  res.json(buildSafeAcknowledgement(req.envelope, safeMeta));
});

app.post('/v1/secure/log', requireE2EE, (req, res) => {
  const payload = req.body?.meta || {};
  const safeMeta = {
    eventType: payload.eventType || 'unknown',
    source: payload.source || 'client',
    healthTokenHash: secureTokenHash(payload.healthToken),
  };

  res.json(buildSafeAcknowledgement(req.envelope, safeMeta));
});

app.use((err, req, res, next) => {
  if (!err) {
    return next();
  }

  res.status(500).json({
    error: 'Server error',
    detail: 'An unexpected error occurred without exposing request data.',
  });
});

app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
