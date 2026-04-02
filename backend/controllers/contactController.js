import Contact from '../models/contactModel.js';

export const createContact = async (req, res) => {
  try {
    const { companyName, contactPerson, email, phone, country, inquiryType, message } = req.body;

    if (!contactPerson || !email || !message) {
      return res.status(400).json({ error: 'contactPerson, email and message are required' });
    }

    const saved = await Contact.create({
      companyName,
      contactPerson,
      email,
      phone,
      country,
      inquiryType,
      message,
    });

    res.status(201).json({ message: 'Contact inquiry submitted', data: saved });
  } catch (err) {
    console.error('createContact error:', err);
    res.status(500).json({ error: 'Server error while submitting contact inquiry' });
  }
};

export const listContacts = async (_req, res) => {
  try {
    const contacts = await Contact.find().sort({ createdAt: -1 }).limit(100);
    res.json(contacts);
  } catch (err) {
    console.error('listContacts error:', err);
    res.status(500).json({ error: 'Server error while listing contact inquiries' });
  }
};
