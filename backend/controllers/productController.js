// backend/controllers/productController.js
import Product from '../models/productModel.js'; // ✅ use correct filename

// -------------------------------
// GET Products
// -------------------------------
export const getProducts = async (req) => {
  try {
    const { category, search } = req.query;
    const filter = {};

    if (category && category !== 'All') filter.category = category;
    if (search) filter.name = { $regex: search, $options: 'i' };

    const products = await Product.find(filter); // fetch from DB
    return products; // return array to the route
  } catch (err) {
    console.error('❌ Error in getProducts:', err);
    throw err; // route will handle sending error response
  }
};

// -------------------------------
// CREATE Product
// -------------------------------
export const createProduct = async (req, res) => {
  try {
    const { name, price, category, description } = req.body;

    const newProduct = new Product({
      name,
      price,
      category: category || 'General',
      description: description || '',
      imageUrl: req.file?.filename || null, // store filename only
    });

    const savedProduct = await newProduct.save();

    // Build full image URL
    const host = req.protocol + '://' + req.get('host');
    const productWithUrl = {
      ...savedProduct._doc,
      imageUrl: savedProduct.imageUrl
        ? `${host}/uploads/${savedProduct.imageUrl}`
        : 'https://via.placeholder.com/150', // fallback image
    };

    res.status(201).json(productWithUrl);
  } catch (err) {
    console.error('❌ Error creating product:', err);
    res.status(500).json({ message: 'Server error' });
  }
};
