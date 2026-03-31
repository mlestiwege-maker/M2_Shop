import mongoose from "mongoose";

const productSchema = new mongoose.Schema({
  name: { type: String, required: true },
  description: { type: String },
  price: { type: Number, required: true },
  category: { type: String },
  imageUrl: { type: String }, // store relative path or full URL
  createdAt: { type: Date, default: Date.now },
});

export default mongoose.model("Product", productSchema);
