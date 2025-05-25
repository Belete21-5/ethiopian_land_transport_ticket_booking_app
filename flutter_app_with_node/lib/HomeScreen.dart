import 'package:flutter/material.dart';
import 'RatingsReviewsScreen.dart';
import 'RouteSearchAndTicketBookingScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'AuthScreen.dart'; // Import the View More screen

// Removed: import 'ViewMoreScreen.dart'; // No longer navigating to this screen
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeContent(),
    const RouteSearchAndTicketBookingScreen(),
    const RouteSearchAndTicketBookingScreen(),
    const RatingsReviewsScreen(), // Add the Ratings and Reviews screen
  ];

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token'); // Clear the saved token

    // Navigate back to the login screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const AuthScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Transport Scheduling & Booking')),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () => Scaffold.of(context).openDrawer(),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
            tooltip: 'Logout',
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const UserAccountsDrawerHeader(
              accountName: Text('Transport App'),
              accountEmail: Text('user@transportapp.com'),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.blue,
                child: Icon(Icons.directions_bus, color: Colors.white),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
                _onTabTapped(0);
              },
            ),
            ListTile(
              leading: const Icon(Icons.search),
              title: const Text('Search Routes'),
              onTap: () {
                Navigator.pop(context);
                _onTabTapped(1);
              },
            ),
            ListTile(
              leading: const Icon(Icons.book),
              title: const Text('Book Tickets'),
              onTap: () {
                Navigator.pop(context);
                _onTabTapped(2);
              },
            ),
            ListTile(
              leading: const Icon(Icons.star),
              title: const Text('Ratings & Reviews'),
              onTap: () {
                Navigator.pop(context);
                _onTabTapped(3); // Navigate to Ratings and Reviews tab
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () => _logout(context),
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onTabTapped,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search routes',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Booking'),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Reviews',
          ), // Add Reviews tab
        ],
      ),
    );
  }
}

// Convert HomeContent to a StatefulWidget
class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  bool _isExpanded = false; // State variable to track expansion

  @override
  Widget build(BuildContext context) {
    return Container(
      // Keep the container for background color
      color: const Color.fromARGB(
        255,
        181,
        176,
        176,
      ), // Light gray background color
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text(
              '🏠 Home Page',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(15),
              child: Image.asset(
                'assets/images/bus1.jpg',
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Welcome to the Transport Scheduling & Ticket Booking App!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const Text(
              'How to Use This App:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              '''
1. Search Routes: Use the "Search Routes" tab to find available routes between your origin and destination.
2. Book Tickets: Select a route and book your ticket by choosing your preferred seat.
3. View Reviews: Check out reviews and ratings for different routes and buses.
4. Manage Bookings: Keep track of your bookings and payment history.
              ''',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.left,
            ),
            // Conditionally display more content
            if (_isExpanded)
              const Padding(
                padding: EdgeInsets.only(top: 15.0),
                child: Text(
                  '''
More Details:
5. Payment Options: Securely pay using Telebirr or CBE Birr.
6. Customer Support: Contact us for any assistance via the app or phone.
7. Real-time Updates: Get notifications about your trip status.
                  ''',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.left,
                ),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isExpanded = !_isExpanded; // Toggle the expansion state
                });
              },
              child: Text(
                _isExpanded ? 'View Less' : 'View More',
              ), // Dynamic button text
            ),
          ],
        ),
      ),
    );
  }
}
