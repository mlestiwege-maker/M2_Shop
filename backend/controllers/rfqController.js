import RFQ from '../models/rfqModel.js';

export const createRfq = async (req, res) => {
  try {
    const { buyerName, email, productName, quantity, targetPrice, destinationCountry, notes } = req.body;

    if (!buyerName || !email || !productName || !quantity) {
      return res.status(400).json({ error: 'buyerName, email, productName and quantity are required' });
    }

    const rfq = await RFQ.create({
      buyerName,
      email,
      productName,
      quantity,
      targetPrice,
      destinationCountry,
      notes,
    });

    res.status(201).json({ message: 'RFQ created successfully', data: rfq });
  } catch (err) {
    console.error('createRfq error:', err);
    res.status(500).json({ error: 'Server error while creating RFQ' });
  }
};

export const listRfqs = async (_req, res) => {
  try {
    const rfqs = await RFQ.find().sort({ createdAt: -1 }).limit(100);
    res.json(rfqs);
  } catch (err) {
    console.error('listRfqs error:', err);
    res.status(500).json({ error: 'Server error while listing RFQs' });
  }
};
