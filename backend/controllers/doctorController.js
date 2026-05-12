const Doctor = require("../models/doctorModel");
const User = require("../models/userModel"); // Ensure this points to your user model

exports.getDoctors = (req, res) => {
    Doctor.getDoctors((err, result) => {
        if (err) {
            console.error("Fetch Error:", err);
            return res.status(500).json({ success: false, data: [] });
        }
        res.json({ success: true, data: result });
    });
};

exports.addDoctor = (req, res) => {
    // Extract data sent from Flutter
    const { username, email, password, specialty } = req.body;

    // 1. Create the User account first
    const userData = {
        username: username,
        email: email,
        password: password,
        role: 'doctor' // Hardcoded role for security
    };

    User.create(userData, (err, userResult) => {
        if (err) {
            console.error("User Creation Error:", err);
            return res.status(500).json({
                success: false,
                message: "Failed to create user account (Email might exist)"
            });
        }

        // 2. Get the ID of the user we just created
        const newUserId = userResult.insertId;

        // 3. Create the Doctor specialty profile
        Doctor.addDoctorProfile(newUserId, specialty, (err2, docResult) => {
            if (err2) {
                console.error("Doctor Profile Error:", err2);
                return res.status(500).json({
                    success: false,
                    message: "User created, but failed to create doctor profile"
                });
            }

            res.status(201).json({
                success: true,
                message: "Doctor registered successfully"
            });
        });
    });
};