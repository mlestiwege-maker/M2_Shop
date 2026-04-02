import { Router } from 'express';
import { createRfq, listRfqs } from '../controllers/rfqController.js';

const router = Router();

router.get('/', listRfqs);
router.post('/', createRfq);

export default router;
