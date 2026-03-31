# M2 Shop Backend API

Professional Node.js/Express backend for the M2 Shop e-commerce application.

## 📋 Prerequisites

- Node.js 16.0 or higher
- npm or yarn
- MongoDB 5.0 or higher

## 🚀 Installation

1. **Install dependencies**:
   ```bash
   npm install
   ```

2. **Create `.env` file** in the backend directory:
   ```bash
   cp .env.example .env  # if available, otherwise create manually
   ```

3. **Configure environment variables** in `.env`:
   ```env
   HOST=localhost
   PORT=5000
   NODE_ENV=development
   MONGO_URI=mongodb://127.0.0.1:27017/m2_shop
   JWT_SECRET=your_very_secure_jwt_secret_key_change_this_in_production
   JWT_EXPIRES_IN=7d
   CORS_ORIGIN=http://localhost:3000,http://localhost:8080
   UPLOAD_LIMIT=10mb
   UPLOAD_DIR=./uploads
   ```

## 🏃 Running the Server

### Development Mode (with hot-reload)
```bash
npm run dev
```

### Production Mode
```bash
npm start
```

The server will start at: `http://localhost:5000`

Health check endpoint: `http://localhost:5000/health`

## 📁 Project Structure

```
backend/
├── controllers/          # Request handlers
│   ├── authController.js
│   ├── productController.js
│   ├── commentController.js
│   ├── complaintController.js
│   └── userController.js
├── middleware/          # Express middleware
│   ├── authMiddleware.js    # JWT authentication
│   └── uploadMiddleware.js  # File upload handling
├── models/             # MongoDB schemas
│   ├── userModel.js
│   ├── productModel.js
│   ├── commentModel.js
│   └── complaintModel.js
├── routes/            # API endpoints
│   ├── authRoutes.js
│   ├── products.js
│   ├── comments.js
│   ├── complaints.js
│   └── user.js
├── utils/            # Utilities
│   └── s3.js         # AWS S3 integration (optional)
├── uploads/          # Uploaded files directory
├── server.js         # Express app entry point
├── package.json      # Dependencies
└── .env              # Environment variables
```

## 🔐 API Authentication

All protected endpoints require JWT token in the Authorization header:

```
Authorization: Bearer <token>
```

Tokens are returned from login/register endpoints and expire after 7 days.

## 📡 API Documentation

### Authentication Endpoints

#### Register
```
POST /api/auth/register
Content-Type: application/json

{
  "fullName": "John Doe",
  "email": "john@example.com",
  "password": "securePassword123",
  "confirmPassword": "securePassword123"
}

Response: 201 Created
{
  "message": "User registered successfully",
  "token": "jwt_token_here",
  "user": {
    "id": "user_id",
    "fullName": "John Doe",
    "email": "john@example.com",
    "profilePicUrl": null
  }
}
```

#### Login
```
POST /api/auth/login
Content-Type: application/json

{
  "email": "john@example.com",
  "password": "securePassword123"
}

Response: 200 OK
{
  "message": "Login successful",
  "token": "jwt_token_here",
  "user": { ... }
}
```

### Products Endpoints

#### Get All Products
```
GET /api/products?category=Electronics&search=phone
Response: 200 OK - Array of products
```

#### Create Product (Protected)
```
POST /api/products
Authorization: Bearer <token>
Content-Type: application/json

{
  "name": "Product Name",
  "description": "Product description",
  "price": 99.99,
  "category": "Electronics",
  "imageUrl": "image.jpg",
  "stock": 50
}
```

### Health Check
```
GET /health
Response: 200 OK
{
  "status": "Server is running"
}
```

## 🛡️ Security Features

- **Helmet.js**: HTTP header security
- **CORS**: Configurable cross-origin access
- **Rate Limiting**: 100 requests per 15 minutes per IP
- **Password Hashing**: bcryptjs with salt
- **JWT Tokens**: Secure authentication
- **Input Validation**: Server-side validation
- **Error Handling**: Comprehensive error management

## 📊 Database

MongoDB is used for data persistence. Collection structure:

- **users**: User accounts and authentication
- **products**: Product catalog
- **comments**: Product reviews and comments
- **complaints**: Customer complaints

## 🧪 Testing

Run tests with:
```bash
npm test
```

## 🚀 Deployment

### Environment Variables for Production
```env
NODE_ENV=production
JWT_SECRET=your_very_long_random_secret_key_at_least_32_chars
MONGO_URI=your_production_mongodb_uri
CORS_ORIGIN=https://yourdomain.com
```

### Using PM2
```bash
npm install -g pm2

pm2 start server.js --name "m2-shop-api"
pm2 save
pm2 startup
```

### Using Docker
```bash
docker build -t m2-shop-backend .
docker run -p 5000:5000 --env-file .env m2-shop-backend
```

## 🐛 Troubleshooting

### MongoDB Connection Failed
- Check MongoDB service is running
- Verify MONGO_URI in .env
- Check network connectivity

### Port Already in Use
```bash
# Kill process on port 5000
lsof -ti:5000 | xargs kill -9

# Or use different port in .env
PORT=5001
```

### CORS Errors
- Update CORS_ORIGIN in .env with correct frontend URL
- Ensure URL matches exactly (protocol, domain, port)

## 📝 Logging

All errors and important events are logged to console and can be captured by PM2 logs:

```bash
pm2 logs m2-shop-api
```

## 📄 License

MIT License - See LICENSE file for details

---

**For frontend documentation, see the main README.md**
