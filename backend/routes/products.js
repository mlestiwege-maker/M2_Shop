// backend/routes/products.js
import { Router } from 'express';
import auth from '../middleware/authMiddleware.js';
import upload from '../middleware/uploadMiddleware.js';
import { createProduct, getProducts } from '../controllers/productController.js';

const router = Router();

// -------------------------------
// GET /api/products
// Fetch all products with optional category & search filters
// Returns products with full image URLs
// -------------------------------
router.get('/', async (req, res) => {
  try {
    const products = await getProducts(req); // fetch array from controller

    // Build full URL for each image
    const host = req.protocol + '://' + req.get('host');
    const productsWithFullUrl = products.map((p) => ({
      ...p._doc,
      imageUrl: p.imageUrl
        ? `${host}/uploads/${p.imageUrl}` // full URL for frontend
        : 'https://via.placeholder.com/150', // fallback image
    }));

    res.json(productsWithFullUrl);
  } catch (err) {
    console.error('❌ Error fetching products:', err);
    res.status(500).json({ message: 'Server error' });
  }
});

// -------------------------------
// POST /api/products
// Create new product (requires auth + single image upload)
// -------------------------------
router.post('/', auth, upload.single('image'), async (req, res) => {
  try {
    await createProduct(req, res); // controller handles saving and response
  } catch (err) {
    console.error('❌ Error creating product:', err);
    res.status(500).json({ message: 'Server error' });
  }
});

export default router;
