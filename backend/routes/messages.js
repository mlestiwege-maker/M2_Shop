import { Router } from 'express';
import { createMessage, listMessages } from '../controllers/messageController.js';

const router = Router();

router.get('/', listMessages);
router.post('/', createMessage);

export default router;
