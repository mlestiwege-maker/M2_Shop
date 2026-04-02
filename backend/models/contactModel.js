import mongoose from 'mongoose';

const contactSchema = new mongoose.Schema(
  {
    companyName: { type: String, trim: true },
    contactPerson: { type: String, required: true, trim: true },
    email: { type: String, required: true, trim: true, lowercase: true },
    phone: { type: String, trim: true },
    country: { type: String, trim: true },
    inquiryType: {
      type: String,
      enum: ['general', 'bulk-order', 'partnership', 'support'],
      default: 'general',
    },
    message: { type: String, required: true, trim: true },
  },
  { timestamps: true }
);

export default mongoose.model('Contact', contactSchema);
