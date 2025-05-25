const express = require("express");
const Schedule = require("./schedule"); // Import the Schedule model

const router = express.Router();

// Fetch routes based on departure and destination city IDs
router.get("/", async (req, res) => {
  const { origin, destination } = req.query;

  // Validate query parameters
  if (!origin || !destination) {
    return res
      .status(400)
      .json({ message: "Both origin and destination city IDs are required." });
  }

  const originId = parseInt(origin);
  const destinationId = parseInt(destination);

  if (isNaN(originId) || isNaN(destinationId)) {
    return res.status(400).json({
      message: "Origin and destination city IDs must be valid numbers.",
    });
  }

  try {
    // Fetch schedules from the database
    const schedules = await Schedule.aggregate([
      {
        $match: {
          departure_city_id: originId,
          destination_city_id: destinationId,
        },
      },
      {
        $lookup: {
          from: "buses", // Collection name for buses
          localField: "bus_id",
          foreignField: "id",
          as: "bus_details",
        },
      },
      {
        $lookup: {
          from: "cities", // Collection name for cities
          localField: "departure_city_id",
          foreignField: "id",
          as: "departure_city_details",
        },
      },
      {
        $lookup: {
          from: "cities", // Collection name for cities
          localField: "destination_city_id",
          foreignField: "id",
          as: "destination_city_details",
        },
      },
      {
        $project: {
          bus_name: { $arrayElemAt: ["$bus_details.name", 0] },
          free_chairs: { $arrayElemAt: ["$bus_details.free_chairs", 0] },
          departure_city: { $arrayElemAt: ["$departure_city_details.name", 0] },
          destination_city: {
            $arrayElemAt: ["$destination_city_details.name", 0],
          },
          departure_time: 1,
          arrival_time: 1,
          price: 1,
        },
      },
    ]);

    if (schedules.length === 0) {
      return res.status(404).json({ message: "No routes found." });
    }

    res.status(200).json(schedules);
  } catch (err) {
    console.error("Error fetching routes:", err);
    res.status(500).json({ message: "Server error." });
  }
});

module.exports = router;
