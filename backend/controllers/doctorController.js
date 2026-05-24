const Doctor = require("../models/doctorModel");
const User = require("../models/userModel");
const bcrypt = require("bcrypt");

const SALT_ROUNDS = 10;

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
    const { username, email, password, specialty } = req.body;

    if (!username || !email || !password || !specialty) {
        return res.status(400).json({ success: false, message: "All fields are required" });
    }

    // 1. Encrypt the password first
    bcrypt.hash(password, SALT_ROUNDS, (hashErr, hashedPassword) => {
        if (hashErr) {
            console.error("Bcrypt Error:", hashErr);
            return res.status(500).json({ success: false, message: "Error securing password" });
        }

        // Use the hashed password for database entry
        const userData = {
            username: username,
            email: email,
            password: hashedPassword,
            role: 'doctor'
        };

        // 2. Create the User account
        User.create(userData, (err, userResult) => {
            if (err) {
                console.error("User Creation Error:", err);
                return res.status(500).json({
                    success: false,
                    message: "Failed to create user account (Email might exist)"
                });
            }

            // 3. Get the ID of the user we just created
            const newUserId = userResult.insertId;

            // 4. Create the Doctor specialty profile linked to that user ID
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
                    message: "Doctor registered successfully with secure encryption"
                });
            });
        });
    });
};