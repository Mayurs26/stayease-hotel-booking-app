import 'package:flutter/material.dart';
import '../services/booking_service.dart';
import 'home_screen.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final hotel = BookingService.bookedHotel;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 90),

            const SizedBox(height: 20),

            Text(
              "Booking Confirmed!",
              style: Theme.of(context).textTheme.headlineSmall,
            ),

            const SizedBox(height: 10),

            Text(
              hotel != null
                  ? "${BookingService.userName ?? "Guest"} booked ${hotel.name}"
                  : "Your booking was successful",
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const HomeScreen()),
                  (route) => false,
                );
              },
              child: const Text("Back to Home"),
            ),
          ],
        ),
      ),
    );
  }
}
