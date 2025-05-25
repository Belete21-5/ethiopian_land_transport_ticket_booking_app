// routes/reviews.js
const express = require("express");
const router = express.Router();

// In-memory store for reviews (replace with database interaction in production)
let reviews = [
  {
    id: 1,
    name: "Alice",
    review: "Great service, very punctual!",
    rating: 5,
    createdAt: new Date(),
  },
  {
    id: 2,
    name: "Bob",
    review: "Bus was clean and comfortable.",
    rating: 4,
    createdAt: new Date(),
  },
];
let nextReviewId = 3; // Simple ID generation

// GET /api/reviews - Fetch all reviews
router.get("/", (req, res) => {
  console.log("GET /api/reviews - Fetching reviews");
  // Sort by newest first (optional)
  const sortedReviews = [...reviews].sort((a, b) => b.createdAt - a.createdAt);
  res.status(200).json(sortedReviews);
});

// POST /api/reviews - Submit a new review
router.post("/", (req, res) => {
  console.log("POST /api/reviews - Received body:", req.body);
  // Trim input fields
  const name = req.body.name ? String(req.body.name).trim() : null;
  const review = req.body.review ? String(req.body.review).trim() : null;
  const rating = req.body.rating; // Keep original type for validation

  // Basic validation
  if (!name || !review || rating === undefined || rating === null) {
    // Check if null, undefined, or empty string after trim
    return res
      .status(400)
      .json({ message: "Missing required fields: name, review, rating" });
  }

  if (typeof rating !== "number" || rating < 1 || rating > 5) {
    return res
      .status(400)
      .json({ message: "Rating must be a number between 1 and 5" });
  }

  const newReview = {
    id: nextReviewId++,
    name: name, // Already trimmed string
    review: review, // Already trimmed string
    rating: Number(rating), // Ensure number type for storage
    createdAt: new Date(),
  };

  reviews.push(newReview);
  console.log("POST /api/reviews - Added new review:", newReview);

  // Respond with the created review and 201 status
  res.status(201).json(newReview);
});

module.exports = router;
