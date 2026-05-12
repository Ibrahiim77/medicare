const express = require("express");
const router = express.Router();
const doctorController = require("../controllers/doctorController");

// GET /api/doctors -> Fetches all doctors with their names and specialties
router.get("/", doctorController.getDoctors);

// POST /api/doctors -> Creates a User account AND a Doctor profile
router.post("/", doctorController.addDoctor);

module.exports = router;