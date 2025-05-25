import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RatingsReviewsScreen extends StatefulWidget {
  const RatingsReviewsScreen({super.key});

  @override
  _RatingsReviewsScreenState createState() => _RatingsReviewsScreenState();
}

class _RatingsReviewsScreenState extends State<RatingsReviewsScreen> {
  final _nameController = TextEditingController();
  final _reviewController = TextEditingController();
  int _selectedRating = 5; // Default rating
  List<dynamic> _reviews = []; // To store fetched reviews
  bool _isLoadingReviews = false;
  bool _isSubmitting = false;

  // --- Backend Interaction ---
  // Use 10.0.2.2 for Android Emulator accessing host machine's localhost
  // Use your machine's local IP if running on a physical device on the same network
  // Example: final String _baseUrl = 'http://192.168.1.10:3000/api';
  final String _baseUrl = 'http://localhost:3000/api';

  @override
  void initState() {
    super.initState();
    _fetchReviews(); // Fetch reviews when the screen loads
  }

  @override
  void dispose() {
    _nameController.dispose();
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Keep AppBar managed by HomeScreen or add one if needed independently
      // appBar: AppBar(title: const Text('Ratings & Reviews')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Submit Review Section ---
              const Text(
                'Submit a Review',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _nameController, // Assign controller
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  labelText: 'Your Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _reviewController, // Assign controller
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.rate_review),
                  labelText: 'Your Review',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Text('Rating:', style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 10),
                  DropdownButton<int>(
                    value: _selectedRating,
                    items: List.generate(5, (index) {
                      return DropdownMenuItem<int>(
                        value: index + 1,
                        child: Text('${index + 1} Stars'),
                      );
                    }),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedRating = value;
                        });
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isSubmitting ? null : _submitReview,
                child:
                    _isSubmitting
                        ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                        : const Text('Submit Review'),
              ),
              const SizedBox(height: 30),

              // --- Recent Reviews Section ---
              const Text(
                'Recent Reviews',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _isLoadingReviews
                  ? const Center(child: CircularProgressIndicator())
                  : _buildReviewList(),
            ],
          ),
        ),
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _buildReviewList() {
    if (_reviews.isEmpty) {
      return const Center(
        child: Text('No reviews yet. Be the first to submit one!'),
      );
    }
    // Use ListView.separated for dividers and shrinkWrap/physics for embedding
    return ListView.separated(
      shrinkWrap: true, // Important when inside SingleChildScrollView
      physics:
          const NeverScrollableScrollPhysics(), // Disable its own scrolling
      itemCount: _reviews.length,
      itemBuilder: (context, index) {
        final review = _reviews[index];
        // Defensive coding: check for null or missing keys
        final name = review['name']?.toString() ?? 'Anonymous';
        final reviewText = review['review']?.toString() ?? 'No comment';
        final rating = review['rating'] as int? ?? 0; // Default to 0 stars

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 5),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Row(
                  children: List.generate(5, (starIndex) {
                    return Icon(
                      starIndex < rating ? Icons.star : Icons.star_border,
                      color: Colors.orangeAccent,
                      size: 18,
                    );
                  }),
                ),
                const SizedBox(height: 8),
                Text(reviewText),
              ],
            ),
          ),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 5),
    );
  }

  // --- API Calls ---

  Future<void> _fetchReviews() async {
    setState(() {
      _isLoadingReviews = true;
    });
    try {
      final response = await http.get(Uri.parse('$_baseUrl/reviews'));
      if (response.statusCode == 200) {
        setState(() {
          _reviews = json.decode(response.body);
        });
      } else {
        // Consider parsing error message from body if backend provides one
        _showErrorSnackbar('Failed to load reviews: ${response.statusCode}');
      }
    } catch (e) {
      _showErrorSnackbar('Error fetching reviews: $e');
      // Log the error for debugging: print('Fetch Reviews Error: $e');
    } finally {
      setState(() {
        _isLoadingReviews = false;
      });
    }
  }

  Future<void> _submitReview() async {
    if (_nameController.text.isEmpty || _reviewController.text.isEmpty) {
      _showErrorSnackbar('Please fill in your name and review.');
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/reviews'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': _nameController.text,
          'review': _reviewController.text,
          'rating': _selectedRating,
        }),
      );

      if (response.statusCode == 201) {
        // Success
        _nameController.clear();
        _reviewController.clear();
        setState(() {
          _selectedRating = 5; // Reset rating
        });
        if (mounted) {
          // Check if widget is still in the tree
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Review submitted successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        }
        _fetchReviews(); // Refresh the list
      } else {
        // Consider parsing error message from body if backend provides one
        _showErrorSnackbar('Failed to submit review: ${response.statusCode}');
      }
    } catch (e) {
      _showErrorSnackbar('Error submitting review: $e');
      // Log the error for debugging: print('Submit Review Error: $e');
    } finally {
      setState(() {
        _isSubmitting = false; // Ensure this runs even on error
      });
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }
}
