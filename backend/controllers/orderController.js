import Order from '../models/orderModel.js';

export const createOrder = async (req, res) => {
  try {
    const { buyerName, productName, quantity, totalAmount, trackingNumber } = req.body;

    if (!buyerName || !productName || !quantity || totalAmount == null) {
      return res.status(400).json({ error: 'buyerName, productName, quantity and totalAmount are required' });
    }

    const order = await Order.create({
      buyerName,
      productName,
      quantity,
      totalAmount,
      trackingNumber,
    });

    res.status(201).json({ message: 'Order created', data: order });
  } catch (err) {
    console.error('createOrder error:', err);
    res.status(500).json({ error: 'Server error while creating order' });
  }
};

export const listOrders = async (_req, res) => {
  try {
    const orders = await Order.find().sort({ createdAt: -1 }).limit(200);
    res.json(orders);
  } catch (err) {
    console.error('listOrders error:', err);
    res.status(500).json({ error: 'Server error while listing orders' });
  }
};
