const express = require("express");
const mongoose = require("mongoose");

const router = express.Router();

// MongoDB Schema for Cities
const citySchema = new mongoose.Schema({
  id: Number,
  name: String,
});

const City = mongoose.model("City", citySchema);

// Fetch All Cities
router.get("/", async (req, res) => {
  try {
    const cities = await City.find().sort({ name: 1 }); // Sort cities alphabetically
    res.status(200).json(cities);
  } catch (err) {
    console.error("Error fetching cities:", err);
    res.status(500).json({ message: "Error fetching cities." });
  }
});

module.exports = router;
