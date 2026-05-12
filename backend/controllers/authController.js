// controllers/authController.js

const User = require("../models/userModel");

exports.login = (req, res) => {
    const { email, password } = req.body;
    User.findByEmail(email, (err, result) => {
        if (err) return res.status(500).json({ success: false, message: "Database error" });
        if (!result || result.length === 0) return res.status(404).json({ success: false, message: "User not found" });

        const user = result[0];
        if (user.password !== password) return res.status(401).json({ success: false, message: "Wrong password" });

        res.json({
            success: true,
            user: { id: user.id, username: user.username, email: user.email, role: user.role }
        });
    });
};

exports.signup = (req, res) => {
    const { username, email, password } = req.body;
    const newUser = { username, email, password, role: "user" };
    User.create(newUser, (err, result) => {
        if (err) return res.status(500).json({ success: false, message: "Database error" });
        res.json({ success: true, message: "User created", userId: result.insertId });
    });
};