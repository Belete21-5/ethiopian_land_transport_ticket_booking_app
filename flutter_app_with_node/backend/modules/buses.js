const express = require("express");
const mongoose = require("mongoose");

const router = express.Router();

// MongoDB Schema for Buses
const busSchema = new mongoose.Schema({
  id: { type: Number, required: true },
  name: { type: String, required: true },
  total_chairs: { type: Number, required: true },
  free_chairs: { type: Number, required: true },
  used_chairs: { type: Number, required: true },
});

const Bus = mongoose.model("Bus", busSchema);

// Fetch All Buses
router.get("/", async (req, res) => {
  try {
    const buses = await Bus.find().sort({ name: 1 }); // Sort buses alphabetically
    res.status(200).json(buses);
  } catch (err) {
    console.error("Error fetching buses:", err);
    res.status(500).json({ message: "Error fetching buses." });
  }
});

// Fetch a Single Bus by ID
router.get("/:id", async (req, res) => {
  const { id } = req.params;

  try {
    const bus = await Bus.findOne({ id: parseInt(id) });
    if (!bus) {
      return res.status(404).json({ message: "Bus not found." });
    }
    res.status(200).json(bus);
  } catch (err) {
    console.error("Error fetching bus:", err);
    res.status(500).json({ message: "Error fetching bus." });
  }
});

// Update Bus Availability
router.put("/:id/update-availability", async (req, res) => {
  const { id } = req.params;
  const { free_chairs, used_chairs } = req.body;

  try {
    const bus = await Bus.findOne({ id: parseInt(id) });
    if (!bus) {
      return res.status(404).json({ message: "Bus not found." });
    }

    // Validate chair updates
    if (
      free_chairs < 0 ||
      used_chairs < 0 ||
      free_chairs + used_chairs > bus.total_chairs
    ) {
      return res.status(400).json({ message: "Invalid chair update values." });
    }

    // Update the bus availability
    bus.free_chairs = free_chairs;
    bus.used_chairs = used_chairs;
    await bus.save();

    res
      .status(200)
      .json({ message: "Bus availability updated successfully.", bus });
  } catch (err) {
    console.error("Error updating bus availability:", err);
    res.status(500).json({ message: "Error updating bus availability." });
  }
});

// Add a New Bus
router.post("/", async (req, res) => {
  const { id, name, total_chairs } = req.body;

  if (!id || !name || !total_chairs) {
    return res.status(400).json({ message: "All fields are required." });
  }

  try {
    const existingBus = await Bus.findOne({ id });
    if (existingBus) {
      return res
        .status(400)
        .json({ message: "Bus with this ID already exists." });
    }

    const newBus = new Bus({
      id,
      name,
      total_chairs,
      free_chairs: total_chairs, // Initially, all chairs are free
      used_chairs: 0, // Initially, no chairs are used
    });

    await newBus.save();
    res.status(201).json({ message: "Bus added successfully.", bus: newBus });
  } catch (err) {
    console.error("Error adding bus:", err);
    res.status(500).json({ message: "Error adding bus." });
  }
});

module.exports = Bus;
