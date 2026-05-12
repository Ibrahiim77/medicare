const express = require("express");
const cors = require("cors");
const app = express();

app.use(cors());
app.use(express.json()); // Must be above routes

// Routes
app.use("/api/auth", require("./routes/authRoutes"));
app.use("/api/doctors", require("./routes/doctorRoutes"));
app.use("/api/appointments", require("./routes/appointmentRoutes"));

// THE DEBUGGER: This replaces the HTML error with a JSON error
app.use((req, res) => {
    console.log(`404 Error: ${req.method} ${req.url}`);
    res.status(404).json({ success: false, message: "Route not found" });
});

module.exports = app;