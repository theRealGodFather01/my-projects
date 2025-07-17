# 🤖 StuBot – AI Chatbot for Campus Information

StuBot is an intelligent chatbot web application built with Django and Python that helps **students** and **non-students** easily access essential information about a school. It serves as a digital guide for academic programs, campus services, admission processes, FAQs, and general information — all through a user-friendly chat interface.

---

## 🚀 Features

- 💬 Real-time chatbot interface
- 🎓 Student-specific features (course details, schedule help, academic support)
- 🌐 General public mode for prospective students or guests
- 🧠 AI-powered responses (optionally connects to NLP services)
- 📚 Dynamic FAQs and document-based search
- 🔐 User authentication for students
- 🛠️ Admin dashboard to manage responses and datasets

---

## 🛠️ Tech Stack

- **Backend:** Django, Python
- **Frontend:** HTML, CSS, JavaScript (Vanilla)
- **Database:** SQLite
- **APIs:** OpenAI / LangChain / Rasa for NLP
- **Deployment:** Railway

---

## 📦 Installation

```bash
git clone https://github.com/your-username/stubot.git
cd stubot
cd chatbot_project
python -m venv venv
source venv/bin/activate  # or venv\Scripts\activate on Windows
pip install -r requirements.txt
python manage.py migrate
python manage.py runserver
