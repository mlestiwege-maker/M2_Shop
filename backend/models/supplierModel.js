import mongoose from 'mongoose';

const supplierSchema = new mongoose.Schema(
  {
    name: { type: String, required: true, trim: true },
    country: { type: String, trim: true },
    category: { type: String, trim: true },
    rating: { type: Number, min: 0, max: 5, default: 4.5 },
    verified: { type: Boolean, default: false },
    minOrderQty: { type: Number, min: 1, default: 100 },
    yearsInBusiness: { type: Number, min: 0, default: 1 },
  },
  { timestamps: true }
);

export default mongoose.model('Supplier', supplierSchema);
