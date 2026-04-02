import mongoose from 'mongoose';
import Product from './models/productModel.js';
import 'dotenv/config';

const seedProducts = async () => {
  try {
    await mongoose.connect(process.env.MONGO_URI);

    await Product.deleteMany();

    await Product.insertMany([
      { name: 'Laptop', price: 1200, category: 'Electronics', description: 'A fast laptop', imageUrl: 'laptop.png' },
      { name: 'Phone', price: 800, category: 'Electronics', description: 'A modern smartphone', imageUrl: 'phone.png' }
    ]);

    console.log('✅ Demo products added!');
    process.exit();
  } catch (err) {
    console.error(err);
    process.exit(1);
  }
};

seedProducts();
