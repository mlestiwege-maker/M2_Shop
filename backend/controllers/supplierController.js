import Supplier from '../models/supplierModel.js';

const defaults = [
  {
    name: 'Shenzhen Smart Devices Co.',
    country: 'China',
    category: 'Electronics',
    rating: 4.8,
    verified: true,
    minOrderQty: 200,
    yearsInBusiness: 9,
  },
  {
    name: 'Istanbul Textile Hub',
    country: 'Turkey',
    category: 'Clothing',
    rating: 4.6,
    verified: true,
    minOrderQty: 500,
    yearsInBusiness: 12,
  },
];

export const listSuppliers = async (_req, res) => {
  try {
    let suppliers = await Supplier.find().sort({ rating: -1, createdAt: -1 }).limit(100);

    if (!suppliers.length) {
      suppliers = await Supplier.insertMany(defaults);
    }

    res.json(suppliers);
  } catch (err) {
    console.error('listSuppliers error:', err);
    res.status(500).json({ error: 'Server error while listing suppliers' });
  }
};
