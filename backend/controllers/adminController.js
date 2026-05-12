const User = require("../models/userModel");

exports.addAdmin = (req, res) => {
    const { username, email, password } = req.body;

    // We explicitly set the role to 'admin' here for security
    const adminData = {
        username: username,
        email: email,
        password: password,
        role: 'admin'
    };

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
            message: "Admin created successfully"
        });
    });
};