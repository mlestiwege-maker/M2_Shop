import Message from '../models/messageModel.js';

export const createMessage = async (req, res) => {
  try {
    const { senderName, receiverName, subject, body } = req.body;

    if (!senderName || !receiverName || !subject || !body) {
      return res.status(400).json({ error: 'senderName, receiverName, subject and body are required' });
    }

    const message = await Message.create({ senderName, receiverName, subject, body });
    res.status(201).json({ message: 'Message sent', data: message });
  } catch (err) {
    console.error('createMessage error:', err);
    res.status(500).json({ error: 'Server error while sending message' });
  }
};

export const listMessages = async (_req, res) => {
  try {
    const messages = await Message.find().sort({ createdAt: -1 }).limit(200);
    res.json(messages);
  } catch (err) {
    console.error('listMessages error:', err);
    res.status(500).json({ error: 'Server error while listing messages' });
  }
};
