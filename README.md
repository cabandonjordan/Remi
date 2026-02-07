# 🩺 Remi: The Empathic Health Companion

> *Your AI-powered health friend that remembers, sees, and cares.*

[![Track](https://img.shields.io/badge/UN_SDG-3_Good_Health_and_Well--Being-4C9F38?style=flat-square)](https://sdgs.un.org/goals/goal3)
[![Status](https://img.shields.io/badge/status-MVP-blue?style=flat-square)]()
[![License](https://img.shields.io/badge/license-MIT-green?style=flat-square)]()

---

## 📖 Overview

**Remi** is an AI-powered health companion that bridges the gap between daily emotional well-being and physical medical triage. Unlike cold, transactional healthcare apps, Remi uses **long-term memory** and **computer vision** to track your recovery progress while providing emotionally intelligent conversation to reduce medical anxiety.

Think of Remi as your personal **Baymax**—a caring friend who checks in on you, remembers your history, and helps you understand your health without the panic.

---

## 🚨 The Problem

Healthcare today is **reactive, not proactive**:

- **Panic-Inducing Searches**: WebMD and Google list worst-case scenarios (e.g., "cancer") for minor symptoms, causing unnecessary anxiety.
- **No Context**: Health apps treat every login as a new event—they don't remember that your leg hurt yesterday too.
- **Cold User Experience**: Medical tools feel sterile and clinical, discouraging frequent use for mental health or minor check-ins.
- **Delayed Care**: People avoid seeking help due to anxiety, cost, or fear of judgment—often waiting until conditions worsen.

---

## 👥 Who Is This For?

### Target Users

1. **The "WebMD Anxious" (Cyberchondriacs)**: People who spiral into panic when searching symptoms online.
2. **Independent Elderly**: Seniors who need a companion to gently remind them of medication and check on their mobility.
3. **Young Parents**: First-time parents who need immediate, calming reassurance for their child's minor injuries.
4. **Chronic Care Patients**: Individuals managing long-term recovery who need consistent emotional and physical check-ins.

---

## ✨ The Solution

**One Sentence**: Remi is an AI-powered "health companion" that uses long-term memory and computer vision to track recovery progress while using emotionally intelligent conversation to reduce medical anxiety.

### How Remi Works

#### 1. **Proactive Check-Ins**
Remi sends gentle notifications:
> *"Hi! I noticed you were up late last night. How is your energy level today?"*

#### 2. **Visual Healing Tracker**
You say: *"My cut looks weird."*
- Remi opens the camera and scans the wound
- Compares it to yesterday's photo
- Detects increased redness or healing progress
- Responds: *"It looks 10% better than yesterday. Keep it covered, and I'll remind you to change the bandage in 4 hours."*

#### 3. **Contextual Care**
Instead of generic advice, Remi remembers your history and provides personalized guidance based on **your** baseline health.

#### 4. **Emotional Support**
If you sound stressed, Remi shifts to a softer tone and guides you through a 30-second breathing exercise before discussing medical next steps.

---

## 🎯 What Makes Remi Different

| Feature | Remi | WebMD/Google | Ada Health | Therapy Bots |
|---------|------|--------------|------------|--------------|
| **Emotional First Aid** | ✅ Calming, supportive tone | ❌ Clinical/panic-inducing | ⚠️ Diagnostic-focused | ✅ Mental health only |
| **Visual Long-Term Memory** | ✅ Tracks healing over time | ❌ No image analysis | �� No image analysis | ❌ No physical health |
| **Relationship-Based Care** | ✅ Learns your baseline | ❌ No memory | ⚠️ Limited context | ⚠️ Mental health only |
| **Proactive Check-Ins** | ✅ Reaches out first | ❌ Passive search | ❌ Reactive | ✅ Scheduled check-ins |

### The "Baymax Effect"
Remi treats your **feelings first**. By using calming, supportive phrasing, it de-escalates panic so you can think clearly about your health.

---

## 🛠️ Technologies Used

### Frontend
- **Flutter**: High-performance mobile UI for iOS and Android

### AI Core
- **Google Gemini 1.5 Pro**: Large context window for remembering patient history
- **Gemini Pro Vision**: Analyzing injury photos and tracking visual changes

### Backend
- **Node.js** with **Express**: RESTful API and server logic

### Database
- **Pinecone**: Vector database for storing long-term conversation memory and health logs

### Security
- **End-to-End Encryption**: HIPAA-compliant data handling
- **Privacy-First Design**: User data never shared with third parties

---

## 🚀 Getting Started

### Prerequisites
- **Flutter SDK** (3.0+)
- **Node.js** (18+)
- **Google Cloud Account** (for Gemini API access)
- **Pinecone Account** (for vector database)

### Installation

```bash
# Clone the repository
git clone https://github.com/cabandonjordan/Remi.git
cd Remi

# Install frontend dependencies
cd frontend
flutter pub get

# Install backend dependencies
cd ../backend
npm install

# Set up environment variables
cp .env.example .env
# Add your API keys for Gemini and Pinecone

# Run the backend
npm run dev

# Run the frontend (in a separate terminal)
cd ../frontend
flutter run
```

### Configuration

Create a `.env` file in the `backend/` directory:

```env
GEMINI_API_KEY=your_gemini_api_key
PINECONE_API_KEY=your_pinecone_api_key
PINECONE_ENVIRONMENT=your_pinecone_environment
PORT=3000
```

---

## 💰 Revenue Model

### Freemium Tier (Free)
- ✅ Basic triage and symptom logging
- ✅ Chat companionship
- ✅ Daily emotional check-ins

### Remi+ (Subscription - $9.99/month)
- ✨ **Unlimited Visual Healing Tracking** (compare photos over time)
- 📊 **Printable Doctor Reports** (export your health timeline)
- 👨‍👩‍👧‍👦 **Family Profile Management** (up to 5 users)
- 🔔 **Advanced Medication Reminders**

### Enterprise API
Licensing Remi's **Triage Engine** to telehealth companies to automate patient intake before they speak to a human doctor.

---

## 🗺️ Roadmap

- [ ] **Phase 1 (MVP)**: Core chat interface + basic symptom logging
- [ ] **Phase 2**: Visual healing tracker with photo comparison
- [ ] **Phase 3**: Voice-based interaction and emotional tone detection
- [ ] **Phase 4**: Family profile management
- [ ] **Phase 5**: Integration with wearables (Apple Health, Google Fit)
- [ ] **Phase 6**: Doctor report export and telehealth integration

---

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guidelines](CONTRIBUTING.md) for details.

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🌟 Acknowledgments

- Built for **UN SDG Goal 3: Good Health and Well-Being**
- Inspired by the compassionate care of Baymax from *Big Hero 6*
- Powered by Google's Gemini AI

---

## 📧 Contact

**Jordan Cabandon** - [@cabandonjordan](https://github.com/cabandonjordan)

Project Link: [https://github.com/cabandonjordan/Remi](https://github.com/cabandonjordan/Remi)

---

<div align="center">
  <p><em>Healthcare shouldn't make you anxious. Let Remi be your calm, caring companion.</em></p>
  <p>⭐ Star this repo if you believe in empathic AI for health!</p>
</div>
