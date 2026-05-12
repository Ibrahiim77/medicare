const express = require('express');
const router = express.Router();
const appointmentController = require('../controllers/appointmentController');

router.get('/', appointmentController.getAppointments);
router.post('/', appointmentController.create);

// Line 6 (where your error is): Ensure appointmentController.updateStatus exists
router.put('/:id', appointmentController.updateStatus);

module.exports = router;