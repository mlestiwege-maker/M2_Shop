import mongoose from 'mongoose';

const messageSchema = new mongoose.Schema(
  {
    senderName: { type: String, required: true, trim: true },
    receiverName: { type: String, required: true, trim: true },
    subject: { type: String, required: true, trim: true },
    body: { type: String, required: true, trim: true },
  },
  { timestamps: true }
);

export default mongoose.model('Message', messageSchema);
