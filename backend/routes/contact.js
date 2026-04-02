import { Router } from 'express';
import { createContact, listContacts } from '../controllers/contactController.js';

const router = Router();

router.get('/', listContacts);
router.post('/', createContact);

export default router;
