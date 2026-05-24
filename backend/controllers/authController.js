const User = require("../models/userModel");
const jwt = require("jsonwebtoken");
const bcrypt = require("bcrypt");

// Change this string to a secure environment variable in production
const JWT_SECRET = process.env.JWT_SECRET ;
const SALT_ROUNDS = 10;

exports.signup = (req, res) => {
    const { username, email, password } = req.body;

    if (!username || !email || !password) {
        return res.status(400).json({ success: false, message: "All fields are required" });
    }

    // Encrypt password using bcrypt before writing to the database
    bcrypt.hash(password, SALT_ROUNDS, (hashErr, hashedPassword) => {
        if (hashErr) {
            return res.status(500).json({ success: false, message: "Error secure-processing password" });
        }

        const newUser = { username, email, password: hashedPassword, role: "user" };

        User.create(newUser, (err, result) => {
            if (err) {
                return res.status(500).json({ success: false, message: "Database error or email already exists" });
            }

            // Auto-login user upon successful registration by issuing a token
            const token = jwt.sign(
                { id: result.insertId, email: email, role: "user" },
                JWT_SECRET,
                { expiresIn: "7d" }
            );

            res.status(201).json({
                success: true,
                message: "User created securely",
                token: token,
                userId: result.insertId
            });
        });
    });
};

exports.login = (req, res) => {
    const { email, password } = req.body;

    if (!email || !password) {
        return res.status(400).json({ success: false, message: "Email and password are required" });
    }

    User.findByEmail(email, (err, result) => {
        if (err) return res.status(500).json({ success: false, message: "Database error" });
        if (!result || result.length === 0) return res.status(404).json({ success: false, message: "User not found" });

        const user = result[0];

        // Compare the plain text password with the hashed password from the DB
        bcrypt.compare(password, user.password, (compareErr, isMatch) => {
            if (compareErr) {
                return res.status(500).json({ success: false, message: "Error during authorization Verification" });
            }
            if (!isMatch) {
                return res.status(401).json({ success: false, message: "Wrong password" });
            }

            // Generate JWT Token if verification passes
            const token = jwt.sign(
                { id: user.id, email: user.email, role: user.role },
                JWT_SECRET,
                { expiresIn: "7d" }
            );

            res.json({
                success: true,
                message: "Login successful",
                token: token,
                user: { id: user.id, username: user.username, email: user.email, role: user.role }
            });
        });
    });
};