const db = require("../config/db");

// GET ALL
exports.getAll = (cb) => {
    // We now pull patient_name and doctor_name directly from the table
    const query = `
        SELECT
            id,
            patient_name,
            doctor_name,
            reason,
            date,
            time,
            status
        FROM appointments
        ORDER BY id DESC
    `;
    db.query(query, cb);
};

// CREATE
exports.create = (data, cb) => {
    const query = `INSERT INTO appointments
                   (user_id, doctor_id, patient_name, doctor_name, reason, date, time, status)
                   VALUES (?, ?, ?, ?, ?, ?, ?, ?)`;

    const values = [
        data.user_id || null,      // Optional ID
        data.doctor_id || null,    // Optional ID
        data.patient_name,         // The String name from Flutter
        data.doctor_name,          // The String name from Flutter
        data.reason,
        data.date,
        data.time,
        data.status || 'Pending'
    ];

    db.query(query, values, cb);
};

// UPDATE STATUS
exports.updateStatus = (id, status, cb) => {
    const query = "UPDATE appointments SET status = ? WHERE id = ?";
    db.query(query, [status, id], cb);
};