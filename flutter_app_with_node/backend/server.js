const express = require("express");
const bodyParser = require("body-parser");
const cors = require("cors");
const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");
const connectDB = require("./database"); // Import database connection
const User = require("./modules/user"); // Import User model
const routeRouter = require("./modules/route"); // Import Route API
const citiesRouter = require("./modules/cities"); // Import Cities API
const busesRouter = require("./modules/buses"); // Import Buses API
const scheduleRouter = require("./modules/schedule"); // Import Schedule API
const paymentsRouter = require("./modules/payments"); // Import Payments API
const reviewRouter = require("./modules/reviews"); // Import Review API

const app = express();
const PORT = 3000;
const JWT_SECRET = "belete"; // Secret key for JWT

// Middleware
app.use(cors());
app.use(bodyParser.json());

// Connect to MongoDB
connectDB();

// Routes

// Registration Endpoint
app.post("/api/register", async (req, res) => {
  const { fullName, phone, email, password } = req.body;

  if (!fullName || !phone || !email || !password) {
    return res.status(400).json({ message: "All fields are required." });
  }

  try {
    // Check if user already exists
    const existingUser = await User.findOne({ $or: [{ phone }, { email }] });
    if (existingUser) {
      return res.status(400).json({ message: "User already exists." });
    }

    // Hash the password
    const hashedPassword = await bcrypt.hash(password, 10);

    // Create a new user
    const newUser = new User({
      fullName,
      phone,
      email,
      password: hashedPassword,
    });

    await newUser.save();
    res.status(201).json({ message: "User registered successfully." });
  } catch (err) {
    console.error("Error during registration:", err);
    res.status(500).json({ message: "Server error." });
  }
});

// Login Endpoint
app.post("/api/login", async (req, res) => {
  const { phone, password } = req.body;

  if (!phone || !password) {
    return res
      .status(400)
      .json({ message: "Phone and password are required." });
  }

  try {
    // Find the user by phone
    const user = await User.findOne({ phone });
    if (!user) {
      return res.status(400).json({ message: "Invalid phone or password." });
    }

    // Compare the password
    const isPasswordValid = await bcrypt.compare(password, user.password);
    if (!isPasswordValid) {
      return res.status(400).json({ message: "Invalid phone or password." });
    }

    // Generate a JWT token
    const token = jwt.sign({ id: user._id }, JWT_SECRET, { expiresIn: "1h" });

    res.status(200).json({ token });
  } catch (err) {
    console.error("Error during login:", err);
    res.status(500).json({ message: "Server error." });
  }
});

// Route API
app.use("/api/routes", routeRouter); // Use the Route API
app.use("/api/cities", citiesRouter); // Use the Cities API
app.use("/api/buses", busesRouter); // Use the Buses API
app.use("/api/schedules", scheduleRouter); // Use the Schedule API
app.use("/api/payments", paymentsRouter); // Use the Payments API
app.use("/api/reviews", reviewRouter); // Use the Review API

// Start the Server
app.listen(PORT, () => {
  console.log(`Server is running on http://localhost:${PORT}`);
});
