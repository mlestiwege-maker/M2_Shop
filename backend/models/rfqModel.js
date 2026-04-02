import mongoose from 'mongoose';

const rfqSchema = new mongoose.Schema(
  {
    buyerName: { type: String, required: true, trim: true },
    email: { type: String, required: true, trim: true, lowercase: true },
    productName: { type: String, required: true, trim: true },
    quantity: { type: Number, required: true, min: 1 },
    targetPrice: { type: Number, min: 0 },
    destinationCountry: { type: String, trim: true },
    notes: { type: String, trim: true },
    status: {
      type: String,
      enum: ['open', 'quoted', 'closed'],
      default: 'open',
    },
  },
  { timestamps: true }
);

export default mongoose.model('RFQ', rfqSchema);
