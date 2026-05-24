const User = require("../models/userModel");
const bcrypt = require("bcrypt");

const SALT_ROUNDS = 10;

exports.addAdmin = (req, res) => {
    const { username, email, password } = req.body;

    if (!username || !email || !password) {
        return res.status(400).json({ success: false, message: "All fields are required" });
    }

    // 1. Encrypt the admin password
    bcrypt.hash(password, SALT_ROUNDS, (hashErr, hashedPassword) => {
        if (hashErr) {
            console.error("Bcrypt Error:", hashErr);
            return res.status(500).json({ success: false, message: "Error securing password" });
        }

        const adminData = {
            username: username,
            email: email,
            password: hashedPassword, // Using secure hash string
            role: 'admin'
        };

        // 2. Create admin record in database
        User.create(adminData, (err, result) => {
            if (err) {
                console.error("Database Error:", err);
                return res.status(500).json({
                    success: false,
                    message: "Database error or email already exists"
                });
            }
            res.status(201).json({
                success: true,
                message: "Admin created successfully with secure encryption"
            });
        });
    });
};