const router = require("express").Router();
const doc = require("../controllers/doctorController");

router.get("/", doc.getDoctors);
router.post("/", doc.addDoctor);

module.exports = router;