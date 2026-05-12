const Doctor = require("../models/doctorModel");

exports.getDoctors = (req, res) => {
    Doctor.getDoctors((err, result) => {
        if (err) return res.status(500).json({ success: false, data: [] });
        res.json({ success: true, data: result });
    });
};

exports.addDoctor = (req, res) => {
    const { user_id, specialty } = req.body;
    Doctor.addDoctor(user_id, specialty, (err, result) => {
        if (err) return res.status(500).json({ success: false, message: "Error adding doctor" });
        res.json({ success: true, message: "Doctor added successfully" });
    });
};