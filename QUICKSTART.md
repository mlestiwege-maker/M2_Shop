# 🚀 M2 Shop - Quick Start (60 Seconds)

## Terminal 1: Start Backend

```bash
cd /home/mufutumari/Desktop/projects/m2/backend
npm install
npm run dev
```

Wait for: `✅ MongoDB connected` and `🚀 Server running`

## Terminal 2: Start Frontend

```bash
cd /home/mufutumari/Desktop/projects/m2
flutter pub get
flutter run
```

## 🌐 Test Connection

Visit: `http://localhost:5000/health`

Should see: `{"status": "Server is running"}`

## ✅ First Time User

1. **Register**: Sign up with email/password
2. **Browse**: View products from home screen
3. **Shop**: Add products to cart
4. **Checkout**: Complete purchase flow

## 📱 Expected Features

- ✅ User authentication (register/login)
- ✅ Product catalog with search
- ✅ Shopping cart management
- ✅ Checkout system
- ✅ User profiles
- ✅ Comments & reviews
- ✅ Complaint reporting
- ✅ Image uploads

## 🔧 Environment Setup

- Backend URL: http://localhost:5000/api
- MongoDB: mongodb://127.0.0.1:27017/m2_shop
- JWT Secret: Configured in backend/.env
- CORS: Enabled for local development

## 📖 Full Documentation

- **README.md** - Project overview
- **SETUP.md** - Detailed setup guide
- **backend/README.md** - API documentation
- **PROFESSIONALIZATION_REPORT.md** - All improvements
- **GITHUB_PUSH_GUIDE.md** - GitHub deployment

## 🆘 Quick Troubleshooting

**Backend won't start?**
```bash
lsof -ti:5000 | xargs kill -9  # Free port 5000
npm run dev                     # Try again
```

**Flutter can't connect?**
- Update baseUrl in `lib/config/api_config.dart`
- Use `http://127.0.0.1:5000/api` for localhost

**MongoDB not found?**
```bash
# macOS
brew services start mongodb-community

# Linux
sudo systemctl start mongod
```

## 📊 Status

- ✅ All issues fixed
- ✅ Security hardened
- ✅ Production ready
- ✅ Fully documented
- ✅ Git initialized
- ⏳ Ready for GitHub push (see GITHUB_PUSH_GUIDE.md)

---

**Happy coding! 🎉**
