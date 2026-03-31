# M2 Shop - Complete Setup Guide

This guide provides step-by-step instructions to set up and run the M2 Shop application.

## 📋 Quick Start

### Prerequisites
- Flutter SDK 3.9.2+ ([Install](https://flutter.dev/docs/get-started/install))
- Node.js 16.0+ ([Install](https://nodejs.org))
- MongoDB 5.0+ ([Install](https://docs.mongodb.com/manual/installation))
- Git

### 1. Backend Setup (5 minutes)

```bash
# Navigate to backend
cd backend

# Install dependencies
npm install

# Copy and configure environment file
cp .env.example .env

# Start MongoDB (if not running)
# macOS: brew services start mongodb-community
# Linux: sudo systemctl start mongod
# Windows: net start MongoDB

# Start the backend server
npm run dev
```

**Expected output:**
```
✅ MongoDB connected
🚀 Server running at: http://localhost:5000
📁 Serving images from: /uploads
📊 Health check: http://localhost:5000/health
🔐 Environment: development
```

### 2. Frontend Setup (5 minutes)

```bash
# From project root
cd ..

# Get dependencies
flutter pub get

# Run on desired platform
flutter run              # Choose emulator/device
flutter run -d web      # Run on web
flutter run -d chrome   # Run on Chrome browser
```

## 🔐 First Time Configuration

### Create First User Account
1. Open the Flutter app
2. Tap "Sign Up" / "Don't have an account?"
3. Fill in registration form:
   - Full Name: Your Name
   - Email: test@example.com
   - Password: Test123456
   - Confirm Password: Test123456
4. Tap "Register"
5. You should be logged in automatically

### Test API Connection
1. go to `http://localhost:5000/health`
2. Should see: `{"status": "Server is running"}`

## 🎯 Common Tasks

### Adding Products
1. Log in to the app
2. Navigate to Admin/Products section
3. Click "Add Product"
4. Fill in product details:
   - Name: Product Name
   - Description: Product description
   - Price: 99.99
   - Category: Electronics
   - Stock: 100
   - Image: Upload image
5. Click "Create"

### Browsing Products
1. From home screen, tap "Browse Products"
2. Use category filter dropdown
3. Search by product name
4. Tap product to see details

### Shopping
1. Tap "Browse Products"
2. Find desired product
3. Tap "Add to Cart"
4. Go to Cart (bottom navigation)
5. Review items and prices
6. Tap "Checkout"

## 🐛 Troubleshooting

### Backend won't start
**Error:** `EADDRINUSE: address already in use :::5000`
```bash
# Find process using port 5000
lsof -ti:5000 | xargs kill -9
# Or change port in .env: PORT=5001
```

**Error:** `MongoDB connection failed`
- Ensure MongoDB service is running
- Check MONGO_URI in .env matches your setup
- Try: `mongosh` to verify connection

### Frontend can't connect to API
**Error:** `Error fetching products: Network error`
- Update `baseUrl` in `lib/config/api_config.dart`
- For local testing use: `http://localhost:5000/api`
- For LAN testing use your PC's IP: `http://192.168.x.x:5000/api`
- Find your IP: `ipconfig` (Windows) or `ifconfig` (Mac/Linux)

**Error:** `CORS error in browser`
- Update CORS_ORIGIN in backend/.env
- Include frontend URL with exact protocol and port
- Example: `http://localhost:3000,http://localhost:8080`
- Restart backend after changing

### App crashes on startup
```bash
# Clean Flutter build
flutter clean
flutter pub get
flutter run
```

### Dependencies issues
```bash
# Backend
cd backend
rm -rf node_modules package-lock.json
npm install

# Frontend
flutter pub cache clean
flutter pub get
```

## 📱 Development Workflow

### During Development
1. Backend changes: Restart `npm run dev` (auto-reload with nodemon)
2. Frontend changes: Hit `r` in terminal for hot reload
3. Major changes: Hit `R` for hot restart

### Code Organization
- Backend: Follow MVC pattern
  - Models: MongoDB schemas
  - Controllers: Business logic
  - Routes: API endpoints
  
- Frontend: Follow clean architecture
  - Models: Data classes
  - Providers: State management
  - Services: API calls
  - Screens: UI pages

### Adding New Features
1. Create backend endpoint (route + controller)
2. Create frontend model for data
3. Add service method for API call
4. Create UI screen/widget
5. Update navigation if needed
6. Test end-to-end

## 🚀 Deployment

### Backend Deployment (Heroku/Railway/AWS)
1. Update environment variables for production
2. Use production MongoDB URL
3. Deploy using provider's CLI:
   ```bash
   # Heroku
   heroku login
   heroku create m2-shop-api
   git push heroku main
   ```

### Frontend Deployment
1. Update `baseUrl` in `lib/config/api_config.dart` to production API
2. Build release:
   ```bash
   # Android
   flutter build apk --release
   
   # iOS
   flutter build ios --release
   
   # Web
   flutter build web --release
   ```

## 📚 Useful Resources

- [Flutter Docs](https://flutter.dev/docs)
- [Express.js Guide](https://expressjs.com)
- [MongoDB Manual](https://docs.mongodb.com/manual)
- [JWT Introduction](https://jwt.io/introduction)

## 🆘 Getting Help

If you encounter issues:
1. Check error messages carefully
2. Search GitHub issues
3. Check Stack Overflow for similar problems
4. Create a detailed issue with:
   - Error message
   - Steps to reproduce
   - System info (OS, versions)
   - Code snippet

## ✅ Verification Checklist

- [ ] Backend running on http://localhost:5000
- [ ] MongoDB connected and ready
- [ ] Frontend can reach backend API
- [ ] Can register new user
- [ ] Can login with created account
- [ ] Can view products via API
- [ ] Can add product to cart
- [ ] Can complete checkout flow

---

**Congratulations! M2 Shop is ready for development and deployment! 🎉**
