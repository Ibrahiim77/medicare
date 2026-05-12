const User = require("../models/userModel");
const db = require("../config/db");

exports.addAdmin = (req, res) => {
    const { email } = req.body;

    User.findByEmail(email, (err, result) => {
        if (err) return res.status(500).json({ success: false });

        if (!result.length) {
            return res.json({ success: false, message: "User not found" });
        }

        const userId = result[0].id;

        db.query(
            "INSERT INTO admins (user_id) VALUES (?)",
            [userId],
            (err) => {
                if (err) return res.status(500).json({ success: false });

                res.json({ success: true });
            }
        );
    });
};