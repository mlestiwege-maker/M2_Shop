# M2 Shop - Professional E-Commerce Application

A full-stack e-commerce application built with Flutter (frontend) and Node.js/Express (backend), designed to provide a seamless shopping experience.

## 📱 Features

- **User Authentication**: Secure registration and login with JWT tokens
- **Product Catalog**: Browse products by category with search functionality
- **Shopping Cart**: Add/remove items with persistent storage
- **User Profiles**: Manage user information and preferences
- **Comments & Reviews**: Leave feedback on products
- **Complaint System**: Report issues and concerns
- **Image Upload**: Support for product images and user profiles

## 🛠️ Tech Stack

### Frontend (Flutter)
- **Framework**: Flutter 3.9.2+
- **State Management**: Provider
- **HTTP Client**: http package
- **Local Storage**: shared_preferences
- **Architecture**: Clean code with separation of concerns

### Backend (Node.js)
- **Runtime**: Node.js with ES6 modules
- **Framework**: Express.js
- **Database**: MongoDB
- **Security**: Helmet, cors, bcryptjs, JWT
- **Rate Limiting**: express-rate-limit
- **File Uploads**: Multer

## 📦 Prerequisites

- Flutter SDK 3.9.2 or higher
- Node.js 16.0 or higher
- MongoDB 5.0 or higher
- npm or yarn

## 🚀 Getting Started

### Backend Setup

1. **Navigate to backend directory**:
   ```bash
   cd backend
   ```

2. **Install dependencies**:
   ```bash
   npm install
   ```

3. **Configure environment variables** in `backend/.env`:
   ```env
   HOST=localhost
   PORT=5000
   NODE_ENV=development
   MONGO_URI=mongodb://127.0.0.1:27017/m2_shop
   JWT_SECRET=your_very_secure_jwt_secret_key_change_this_in_production_12345
   JWT_EXPIRES_IN=7d
   CORS_ORIGIN=http://localhost:3000,http://localhost:8080
   ```

4. **Start MongoDB** (if running locally):
   ```bash
   # macOS with Homebrew
   brew services start mongodb-community
   
   # Linux
   sudo systemctl start mongod
   ```

5. **Start the backend server**:
   ```bash
   # Development mode with auto-reload
   npm run dev
   
   # Production mode
   npm start
   ```

   The API will be available at: `http://localhost:5000`

### Frontend Setup

1. **Navigate to project root**:
   ```bash
   cd ..
   ```

2. **Update API Configuration** in `lib/config/api_config.dart`:
   - Change `baseUrl` to match your backend URL
   - For local testing: `http://localhost:5000/api`
   - For LAN testing: Update with your machine's IP address

3. **Get Flutter dependencies**:
   ```bash
   flutter pub get
   ```

4. **Run the application**:
   ```bash
   # Development
   flutter run
   
   # Web
   flutter run -d web
   ```

## 📁 Project Structure

```
m2/
├── backend/
│   ├── controllers/        # API endpoint handlers
│   ├── middleware/         # Authentication & validation
│   ├── models/            # MongoDB schemas
│   ├── routes/            # API route definitions
│   ├── utils/             # Utility functions
│   ├── server.js          # Express app entry point
│   ├── package.json       # Node dependencies
│   └── .env               # Environment variables
├── lib/
│   ├── config/            # Configuration & constants
│   ├── models/            # Data models
│   ├── providers/         # State management (Provider)
│   ├── screens/           # UI pages
│   ├── services/          # API communication
│   ├── widgets/           # Reusable UI components
│   └── main.dart          # App entry point
├── test/                  # Unit and widget tests
└── pubspec.yaml          # Flutter dependencies
```

## 🔐 Security Features

- **JWT Authentication**: Secure token-based authentication
- **Password Hashing**: bcryptjs with salt rounds
- **CORS Protection**: Configurable cross-origin requests
- **Rate Limiting**: Prevent brute force and DDoS attacks
- **Security Headers**: Helmet.js for HTTP header security
- **Environment Isolation**: Sensitive data in .env files
- **Input Validation**: Server-side validation on all endpoints

## 📡 API Endpoints

### Authentication
- `POST /api/auth/register` - User registration
- `POST /api/auth/login` - User login

### Products
- `GET /api/products` - Get all products
- `GET /api/products/:id` - Get product details
- `POST /api/products` - Create product (authenticated)
- `PUT /api/products/:id` - Update product (authenticated)
- `DELETE /api/products/:id` - Delete product (authenticated)

### Comments
- `GET /api/comments` - Get all comments
- `POST /api/comments` - Create comment (authenticated)

### Complaints
- `GET /api/complaints` - Get all complaints
- `POST /api/complaints` - File a complaint (authenticated)

### User
- `GET /api/user/profile` - Get user profile (authenticated)
- `PUT /api/user/profile` - Update profile (authenticated)

### Health
- `GET /health` - Server health check

## 🧪 Testing

### Backend
```bash
cd backend
npm test
```

### Frontend
```bash
flutter test
```

## 📝 Environment Variables

### Backend (.env)
| Variable | Description | Example |
|----------|-------------|---------|
| `HOST` | Server host | `localhost` |
| `PORT` | Server port | `5000` |
| `NODE_ENV` | Environment | `development` or `production` |
| `MONGO_URI` | MongoDB connection string | `mongodb://127.0.0.1:27017/m2_shop` |
| `JWT_SECRET` | Secret key for JWT tokens | `your_secure_key_here` |
| `JWT_EXPIRES_IN` | Token expiration time | `7d` |
| `CORS_ORIGIN` | Allowed origins | `http://localhost:3000` |

### Frontend (lib/config/api_config.dart)
| Variable | Description | Example |
|----------|-------------|---------|
| `baseUrl` | Backend API base URL | `http://localhost:5000/api` |
| `requestTimeoutSeconds` | HTTP request timeout | `30` |
| `imageBaseUrl` | Image serving URL | `http://localhost:5000/uploads` |

## 🐛 Troubleshooting

### MongoDB Connection Issues
- Ensure MongoDB service is running
- Check MONGO_URI in .env file
- Verify network connectivity

### API Connection Issues
- Update API URL in `lib/config/api_config.dart`
- For LAN testing, use your machine's IP (e.g., `192.168.x.x`)
- Check firewall settings

### Flutter Dependency Issues
```bash
flutter clean
flutter pub get
```

### Backend Dependency Issues
```bash
cd backend
rm -rf node_modules package-lock.json
npm install
```

## 📊 Performance Optimization

- Lazy loading of products
- Image caching and optimization
- Efficient database queries with indexes
- Rate limiting for API protection
- Gzip compression for responses

## 🚢 Deployment

### Backend Deployment
1. Set `NODE_ENV=production` in .env
2. Use environment variables from your hosting provider
3. Ensure MongoDB instance is accessible
4. Deploy using PM2 or Docker
5. Configure CORS for production domain

### Frontend Deployment
1. Update `baseUrl` in `lib/config/api_config.dart` to production URL
2. Build release APK: `flutter build apk --release`
3. Build release iOS: `flutter build ios --release`
4. Build web: `flutter build web --release`

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 👥 Contributing

Contributions are welcome! Please follow these steps:
1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📧 Contact & Support

For issues, questions, or contributions, please open an issue on GitHub.

---

**Made with ❤️ by the M2 Shop Team**
