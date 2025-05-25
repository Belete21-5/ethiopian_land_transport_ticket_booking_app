const express = require("express");
const mongoose = require("mongoose");
const Bus = require("./buses"); // Import the Bus model

const router = express.Router();

// Check if the Payment model already exists
const Payment =
  mongoose.models.Payment ||
  mongoose.model(
    "Payment",
    new mongoose.Schema({
      user_phone: { type: String, required: true },
      payment_receiver_phone: { type: String }, // Only for Telebirr
      transaction_id: { type: String }, // Only for CBE Birr
      departure_city: { type: String, required: true },
      destination_city: { type: String, required: true },
      bus_name: { type: String, required: true },
      amount: { type: Number, required: true },
      departure_time: { type: Date, required: true },
      arrival_time: { type: Date, required: true },
      payment_method: { type: String, required: true }, // Telebirr or CBE Birr
      created_at: { type: Date, default: Date.now },
    })
  );

// Save payment data
router.post("/", async (req, res) => {
  const {
    user_phone,
    payment_receiver_phone,
    transaction_id,
    departure_city,
    destination_city,
    bus_name,
    amount,
    departure_time,
    arrival_time,
    payment_method,
  } = req.body;

  if (
    !user_phone ||
    !departure_city ||
    !destination_city ||
    !bus_name ||
    !amount ||
    !departure_time ||
    !arrival_time ||
    !payment_method
  ) {
    return res
      .status(400)
      .json({ message: "All required fields must be filled." });
  }

  if (payment_method === "Telebirr" && !payment_receiver_phone) {
    return res
      .status(400)
      .json({ message: "Receiver phone number is required for Telebirr." });
  }

  if (payment_method === "CBE Birr" && !transaction_id) {
    return res
      .status(400)
      .json({ message: "Transaction ID is required for CBE Birr." });
  }

  try {
    // Save the payment
    const payment = new Payment({
      user_phone,
      payment_receiver_phone,
      transaction_id,
      departure_city,
      destination_city,
      bus_name,
      amount,
      departure_time,
      arrival_time,
      payment_method,
    });

    await payment.save();

    // Update the bus availability
    const bus = await Bus.findOne({ name: bus_name });
    if (!bus) {
      return res.status(404).json({ message: "Bus not found." });
    }

    if (bus.free_chairs <= 0) {
      return res
        .status(400)
        .json({ message: "No available seats on this bus." });
    }

    bus.free_chairs -= 1; // Decrement free chairs
    bus.used_chairs += 1; // Increment used chairs
    await bus.save();

    res.status(201).json({ message: "Payment processed successfully." });
  } catch (err) {
    console.error("Error processing payment:", err.stack); // Log the full error stack
    res.status(500).json({ message: "Server error.", error: err.message });
  }
});

module.exports = router;
