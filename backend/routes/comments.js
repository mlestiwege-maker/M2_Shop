import { Router } from 'express';
import auth from '../middleware/authMiddleware.js';
import { createComplaint, getComplaints } from '../controllers/complaintController.js';

const router = Router();

// Get all complaints
router.get('/', auth, getComplaints);

// Create a new complaint
router.post('/', auth, createComplaint);

export default router;
