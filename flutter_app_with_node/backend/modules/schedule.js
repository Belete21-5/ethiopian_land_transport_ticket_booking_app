const mongoose = require("mongoose");

// Check if the Schedule model is already compiled
const Schedule =
  mongoose.models.Schedule ||
  mongoose.model(
    "Schedule",
    new mongoose.Schema({
      bus_id: { type: Number, required: true },
      departure_city_id: { type: Number, required: true },
      destination_city_id: { type: Number, required: true },
      departure_time: { type: Date, required: true },
      arrival_time: { type: Date, required: true },
      price: { type: Number, required: true },
      bus_name: { type: String, required: true },
      created_at: { type: Date, default: Date.now },
      updated_at: { type: Date, default: Date.now },
    })
  );

module.exports = Schedule;
