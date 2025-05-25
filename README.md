Ethiopian Land Transport Ticket Booking App
Description
This is a mobile application built with Flutter for booking land transport tickets in Ethiopia cites. 
It provides users with a seamless interface to search for routes, book tickets, simulate payments, and leave reviews for bus services. 
The app is integrated with a Node.js backend to manage buses, routes, schedules, payments, and user data.
Features

Route Search and Ticket Booking: Search for available bus routes and book tickets.
Payment Simulation: Simulate payment processes for ticket purchases.
Ratings and Reviews: Allow users to rate and review bus services.
User Authentication: Secure login and registration for users.
Cross-Platform: Supports Android, iOS, and web platforms via Flutter.
Node.js Backend: Handles data management for buses, cities, routes, schedules, and user accounts.

Technologies

Frontend: Flutter (Dart)
Backend: Node.js with Express
Database: Configurable via backend/database.js (e.g., MongoDB, MySQL)
Assets: Custom images for buses and branding (assets/images/)

Prerequisites

Flutter SDK: Version 3.0 or higher
Dart: Included with Flutter
Node.js: Version 14 or higher
npm: For installing backend dependencies
Git: For cloning the repository
IDE: Recommended (VS Code, Android Studio)

Installation

Clone the Repository:
git clone https://github.com/your-username/ethiopian-transport-app.git


Navigate to the Project:
cd ethipian-land-transport-ticket-booking-mobile-app


Install Flutter Dependencies:
cd flutter_app_with_node
flutter pub get


Install Node.js Dependencies:
cd backend
npm install


Configure the Backend:

Update backend/database.js with your database connection details (e.g., MongoDB URI).
Ensure any environment variables (e.g., .env) are set up for sensitive data like API keys.


Run the Backend:
node server.js


Run the Flutter App:

Return to the flutter_app_with_node directory:cd ..


Run the app on a connected device or emulator:flutter run





Project Structure
ethiopian-land-transport-ticket-booking-mobile-app/
├── flutter_app_with_node/         # Flutter app directory
│   ├── android/                   # Android-specific files
│   ├── ios/                       # iOS-specific files
│   ├── lib/                       # Dart source code
│   │   ├── AuthScreen.dart        # User authentication UI
│   │   ├── HomeScreen.dart        # Main app interface
│   │   ├── PaymentSimulationScreen.dart  # Payment simulation
│   │   ├── RatingsReviewsScreen.dart    # Reviews and ratings
│   │   ├── RouteSearchAndTicketBookingScreen.dart  # Route search and booking
│   │   └── main.dart              # App entry point
│   ├── assets/images/             # Image assets (e.g., bus1.jpg, ethio.jpg)
│   ├── backend/                   # Node.js backend
│   │   ├── database.js            # Database connection
│   │   ├── modules/               # Backend logic (buses, routes, etc.)
│   │   ├── package.json           # Node.js dependencies
│   │   └── server.js              # Backend server
│   ├── web/                       # Web-specific files
│   └── pubspec.yaml               # Flutter dependencies
├── .gitignore                     # Git ignore file
└── README.md                      # This file

Usage

User Flow:
Register or log in via AuthScreen.
Browse available routes on RouteSearchAndTicketBookingScreen.
Book a ticket and simulate payment on PaymentSimulationScreen.
Leave feedback on RatingsReviewsScreen.


Backend:
The Node.js server handles API requests for managing buses, routes, schedules, payments, and user data.
Configure the backend to connect to your preferred database.



Contributing

Fork the repository.
Create a feature branch:git checkout -b feature/your-feature


Commit your changes:git commit -m "Add your feature"


Push to the branch:git push origin feature/your-feature


Create a pull request on GitHub.

License
This project is licensed under the MIT License. See the LICENSE file for details.
Contact
For questions or feedback, contact Belete Siyum at beletesiyum40@gmail.com.





Course tittle: mobile application development
Course code: Seng4061
Group 5
No   Name                                                 ID 
1.    Belete Siyum ---------------------------------------  WDU145584 
2.    Meba Tadesse --------------------------------------  WDU146733 
3.    Abenezer Tewodros -------------------------------  WDU145267 
4.    Sisay Bizualew --------------------------------------  WDU147285 
5.    Hilina mogess ---------------------------------------  WDU146417

                                                                       Submitted to: Mr. Girma  
                                                                       Submission date: 16/09/2017 E.C
