const db = require("../config/db");

const User = {
    findByEmail: (email, cb) => {
        db.query(
            "SELECT * FROM users WHERE email = ?",
            [email],
            (err, result) => {
                if (err) return cb(err);
                cb(null, result);
            }
        );
    },

    create: (data, cb) => {
        db.query(
            "INSERT INTO users (username, email, password, role) VALUES (?, ?, ?, ?)",
            [
                data.username,
                data.email,
                data.password,
                data.role || "user"
            ],
            cb
        );
    }
};

module.exports = User;