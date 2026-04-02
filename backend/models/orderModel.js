import mongoose from 'mongoose';

const orderSchema = new mongoose.Schema(
  {
    buyerName: { type: String, required: true, trim: true },
    productName: { type: String, required: true, trim: true },
    quantity: { type: Number, required: true, min: 1 },
    totalAmount: { type: Number, required: true, min: 0 },
    status: {
      type: String,
      enum: ['confirmed', 'packed', 'shipped', 'delivered'],
      default: 'confirmed',
    },
    trackingNumber: { type: String, trim: true },
  },
  { timestamps: true }
);

export default mongoose.model('Order', orderSchema);
