const db = require("../config/db");

exports.getDoctors = (cb) => {
    db.query(
        `SELECT d.id, u.username AS name, d.specialty
         FROM doctors d
         JOIN users u ON d.user_id = u.id`,
        cb
    );
};

exports.addDoctor = (userId, specialty, cb) => {
    db.query(
        "INSERT INTO doctors (user_id, specialty) VALUES (?, ?)",
        [userId, specialty],
        cb
    );
};