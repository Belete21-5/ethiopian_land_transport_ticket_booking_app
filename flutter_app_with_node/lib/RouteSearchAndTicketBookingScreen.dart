import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'PaymentSimulationScreen.dart';

class RouteSearchAndTicketBookingScreen extends StatefulWidget {
  const RouteSearchAndTicketBookingScreen({super.key});

  @override
  _RouteSearchAndTicketBookingScreenState createState() =>
      _RouteSearchAndTicketBookingScreenState();
}

class _RouteSearchAndTicketBookingScreenState
    extends State<RouteSearchAndTicketBookingScreen> {
  final List<String> departureCities = [
    'Addis Ababa',
    'Bahir Dar',
    'Hawassa',
    'Dire Dawa',
    'Mekelle',
    'Woldia',
    'Dessie',
    'Debre Markos',
  ];

  final List<String> destinationCities = [
    'Addis Ababa',
    'Bahir Dar',
    'Hawassa',
    'Dire Dawa',
    'Mekelle',
    'Woldia',
    'Dessie',
    'Debre Markos',
    'Debre Birhan',
    'Axum',
    'Adama',
    'Afar',
    'Assosa',
    'Jijiga',
    'Jimma',
    'Lalibela',
    'Gondar',
    'Harar',
  ];

  String? selectedDeparture;
  String? selectedDestination;
  List<dynamic> availableRoutes = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    selectedDeparture = departureCities.isNotEmpty ? departureCities[0] : null;
    selectedDestination =
        destinationCities.length > 1 ? destinationCities[1] : null;
  }

  Future<void> _searchRoutes() async {
    if (selectedDeparture == null || selectedDestination == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select both departure and destination cities.'),
        ),
      );
      return;
    }

    if (selectedDeparture == selectedDestination) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Departure and destination cannot be the same.'),
        ),
      );
      return;
    }

    // Map city names to numeric IDs
    final cityIds = {
      'Addis Ababa': 1,
      'Bahir Dar': 2,
      'Hawassa': 3,
      'Dire Dawa': 4,
      'Mekelle': 5,
      'Woldia': 6,
      'Dessie': 7,
      'Debre Markos': 8,
      'Debre Birhan': 9,
      'Axum': 10,
      'Adama': 11,
      'Afar': 12,
      'Assosa': 13,
      'Jijiga': 14,
      'Jimma': 15,
      'Lalibela': 16,
      'Gondar': 17,
      'Harar': 18,
    };

    final originId = cityIds[selectedDeparture]!;
    final destinationId = cityIds[selectedDestination]!;

    setState(() {
      isLoading = true;
      availableRoutes = [];
    });

    try {
      final response = await http.get(
        Uri.parse(
          'http://localhost:3000/api/routes?origin=$originId&destination=$destinationId',
        ),
      );

      if (response.statusCode == 200) {
        setState(() {
          availableRoutes = json.decode(response.body);
        });
      } else if (response.statusCode == 404) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('No routes found.')));
      } else {
        final errorMessage =
            json.decode(response.body)['message'] ?? 'Unknown error occurred.';
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Server error: $errorMessage')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to connect to the server.')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _navigateToPaymentScreen(Map<String, dynamic> route) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentSimulationScreen(route: route),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Route Search & Booking')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Departure City:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            DropdownButton<String>(
              value: selectedDeparture,
              isExpanded: true,
              items:
                  departureCities.map((String city) {
                    return DropdownMenuItem<String>(
                      value: city,
                      child: Text(city),
                    );
                  }).toList(),
              onChanged: (newValue) {
                setState(() {
                  selectedDeparture = newValue!;
                });
              },
            ),
            const SizedBox(height: 20),
            const Text(
              'Select Destination City:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            DropdownButton<String>(
              value: selectedDestination,
              isExpanded: true,
              items:
                  destinationCities.map((String city) {
                    return DropdownMenuItem<String>(
                      value: city,
                      child: Text(city),
                    );
                  }).toList(),
              onChanged: (newValue) {
                setState(() {
                  selectedDestination = newValue!;
                });
              },
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: _searchRoutes,
                child: const Text('Search Routes'),
              ),
            ),
            const SizedBox(height: 20),
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else if (availableRoutes.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: availableRoutes.length,
                  itemBuilder: (context, index) {
                    final route = availableRoutes[index];
                    return Card(
                      child: ListTile(
                        title: Text(
                          '${route['bus_name']} (${route['free_chairs']} free chairs)',
                        ),
                        subtitle: Text(
                          'From: ${route['departure_city']} to ${route['destination_city']}\n'
                          'Departure: ${route['departure_time']} | Arrival: ${route['arrival_time']}\n'
                          'Price: ${route['price']} ETB',
                        ),
                        trailing: ElevatedButton(
                          onPressed: () => _navigateToPaymentScreen(route),
                          child: const Text('Book Now'),
                        ),
                      ),
                    );
                  },
                ),
              )
            else
              const Center(child: Text('No routes available.')),
          ],
        ),
      ),
    );
  }
}
