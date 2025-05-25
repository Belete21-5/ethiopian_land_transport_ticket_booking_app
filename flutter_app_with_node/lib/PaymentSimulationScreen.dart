import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PaymentSimulationScreen extends StatefulWidget {
  final Map<String, dynamic> route;

  const PaymentSimulationScreen({super.key, required this.route});

  @override
  _PaymentSimulationScreenState createState() =>
      _PaymentSimulationScreenState();
}

class _PaymentSimulationScreenState extends State<PaymentSimulationScreen> {
  final TextEditingController userPhoneController = TextEditingController();
  final TextEditingController receiverPhoneController = TextEditingController();
  final TextEditingController transactionIdController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  String selectedMethod = 'Telebirr';

  @override
  void initState() {
    super.initState();
    amountController.text = widget.route['price'].toString();
  }

  Future<void> submitPayment() async {
    final paymentData = {
      'user_phone': userPhoneController.text,
      'payment_receiver_phone':
          selectedMethod == 'Telebirr' ? receiverPhoneController.text : null,
      'transaction_id':
          selectedMethod == 'CBE Birr' ? transactionIdController.text : null,
      'payment_method': selectedMethod,
      'amount': double.tryParse(amountController.text),
      'bus_name': widget.route['bus_name'],
      'departure_time': widget.route['departure_time'],
      'arrival_time': widget.route['arrival_time'],
      'departure_city': widget.route['departure_city'],
      'destination_city': widget.route['destination_city'],
      'created_at': DateTime.now().toIso8601String(),
    };

    try {
      // Send payment data to the backend
      final response = await http.post(
        Uri.parse('http://localhost:3000/api/payments'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(paymentData),
      );

      if (response.statusCode == 201) {
        // Payment processed successfully
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Payment processed successfully!')),
        );

        Navigator.pop(context); // Navigate back after successful payment
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${response.body}')));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Center(child: Text('Payment Simulation'))),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'Enter Payment Details',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: userPhoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Your Phone Number',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone_android),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedMethod,
                items: const [
                  DropdownMenuItem(value: 'Telebirr', child: Text('Telebirr')),
                  DropdownMenuItem(value: 'CBE Birr', child: Text('CBE Birr')),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedMethod = value!;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Payment Method',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              if (selectedMethod == 'Telebirr')
                TextField(
                  controller: receiverPhoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Receiver Phone Number',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.phone),
                  ),
                ),
              if (selectedMethod == 'CBE Birr')
                TextField(
                  controller: transactionIdController,
                  decoration: const InputDecoration(
                    labelText: 'Transaction ID',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.confirmation_number),
                  ),
                ),
              const SizedBox(height: 16),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Amount (ETB)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.attach_money),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Bus: ${widget.route['bus_name']}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'From: ${widget.route['departure_city']} to ${widget.route['destination_city']}',
              ),
              Text(
                'Departure: ${widget.route['departure_time']} | Arrival: ${widget.route['arrival_time']}',
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (userPhoneController.text.isEmpty ||
                        (selectedMethod == 'Telebirr' &&
                            receiverPhoneController.text.isEmpty) ||
                        (selectedMethod == 'CBE Birr' &&
                            transactionIdController.text.isEmpty)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please fill in all required fields.'),
                        ),
                      );
                      return;
                    }
                    submitPayment();
                  },
                  icon: const Icon(Icons.payment),
                  label: const Text('Submit Payment'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
