const Appointment = require("../models/appointmentModel");

exports.getAppointments = (req, res) => {
    Appointment.getAll((err, result) => {
        if (err) return res.status(500).json({ success: false, error: err });
        res.json({ success: true, data: result });
    });
};

exports.create = (req, res) => {
    Appointment.create(req.body, (err, result) => {
        if (err) return res.status(500).json({ success: false, error: err });
        res.json({ success: true, message: "Created", id: result.insertId });
    });
};

// ADD THIS SECTION - This was likely missing!
exports.updateStatus = (req, res) => {
    const { id } = req.params;
    const { status } = req.body;
    Appointment.updateStatus(id, status, (err, result) => {
        if (err) return res.status(500).json({ success: false, error: err });
        res.json({ success: true, message: "Status updated successfully" });
    });
};