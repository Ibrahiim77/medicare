const db = require("../config/db");

const Doctor = {
    getDoctors: (cb) => {
        // We use an INNER JOIN to link the credentials (users) with the profile (doctors)
        const query = `
            SELECT
                u.username AS name,
                d.specialty,
                u.email,
                d.id AS doctor_id
            FROM doctors d
            INNER JOIN users u ON d.user_id = u.id
            WHERE u.role = 'doctor'`;

        db.query(query, cb);
    },

    addDoctorProfile: (userId, specialty, cb) => {
        db.query(
            "INSERT INTO doctors (user_id, specialty) VALUES (?, ?)",
            [userId, specialty],
            cb
        );
    }
};

module.exports = Doctor;