const express = require('express');
const router = express.Router();
const adminController = require('../controllers/adminController');

// This matches the POST request from Flutter
router.post('/', adminController.addAdmin);

module.exports = router;