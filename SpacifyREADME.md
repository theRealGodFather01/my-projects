# 🌐 Spacify – Social Media for Colleagues and Loved Ones

**Spacify** is a modern social media platform built with Django that aims to **bridge the emotional and professional gap** between colleagues, classmates, and loved ones. It allows users to connect, share updates, post media, and engage in meaningful conversations in a private, community-focused space.

---

## 🎯 Key Features

- 📝 Post updates (text, photos, links)
- 🧑‍🤝‍🧑 Follow/unfollow users
- 💬 Comment and react to posts
- 📨 Direct messaging / inbox
- 🗂️ Profile management with bio, avatar, and timeline
- 🔐 User authentication and role-based access
- 🔍 Explore feed based on interests or networks

---

## 🛠️ Tech Stack

- **Backend:** Python, Django
- **Frontend:** HTML, CSS, JavaScript
- **Database:** SQLite
- **Authentication:** Django AllAuth or Custom Auth
- **Deployment:* DigitalOcean

---

## ⚙️ Setup Instructions

```bash
git clone https://github.com/your-username/spacify.git
cd spacify
python -m venv venv
source venv/bin/activate  # or venv\Scripts\activate
pip install -r requirements.txt
python manage.py migrate
python manage.py runserver
