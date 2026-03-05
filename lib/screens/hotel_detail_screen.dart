import 'package:flutter/material.dart';
import '../models/hotel.dart';
import '../services/booking_service.dart';
import 'booking_screen.dart';

class HotelDetailScreen extends StatelessWidget {
  final Hotel hotel;

  const HotelDetailScreen({super.key, required this.hotel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff6f7fb),

      body: Stack(
        children: [
          /// ================= SCROLL CONTENT =================
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// ---------- IMAGE HERO ----------
                Stack(
                  children: [
                    Hero(
                      tag: hotel.name,
                      child: Image.network(
                        hotel.image,
                        height: 320,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),

                    Container(
                      height: 320,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withOpacity(.5),
                            Colors.transparent,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),

                    /// BACK BUTTON
                    Positioned(
                      top: 45,
                      left: 15,
                      child: _circleIcon(
                        Icons.arrow_back,
                        () => Navigator.pop(context),
                      ),
                    ),

                    /// FAVORITE
                    Positioned(
                      top: 45,
                      right: 15,
                      child: _circleIcon(Icons.favorite_border, () {}),
                    ),

                    /// TITLE
                    Positioned(
                      bottom: 20,
                      left: 20,
                      right: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            hotel.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: const [
                              Icon(Icons.star, color: Colors.amber, size: 18),
                              SizedBox(width: 4),
                              Text(
                                "4.7",
                                style: TextStyle(color: Colors.white),
                              ),
                              SizedBox(width: 10),
                              Text(
                                "• Superhost",
                                style: TextStyle(color: Colors.white70),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                /// ---------- DETAILS ----------
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(28),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// LOCATION
                      Row(
                        children: [
                          const Icon(Icons.location_on, color: Colors.red),
                          const SizedBox(width: 6),
                          Text(
                            hotel.location,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 25),

                      /// QUICK INFO
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          InfoTile("4 Guests"),
                          InfoTile("2 Beds"),
                          InfoTile("1 Bath"),
                          InfoTile("Wifi"),
                        ],
                      ),

                      const SizedBox(height: 30),

                      /// AMENITIES
                      const Text(
                        "What this place offers",
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 15),

                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: const [
                          AmenityChip(Icons.wifi, "Free WiFi"),
                          AmenityChip(Icons.pool, "Pool"),
                          AmenityChip(Icons.local_parking, "Parking"),
                          AmenityChip(Icons.restaurant, "Restaurant"),
                          AmenityChip(Icons.ac_unit, "AC"),
                          AmenityChip(Icons.tv, "Smart TV"),
                        ],
                      ),

                      const SizedBox(height: 30),

                      /// DESCRIPTION
                      const Text(
                        "About this stay",
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      const Text(
                        "Enjoy a premium stay experience with modern interiors, "
                        "luxury comfort, and top-class hospitality. "
                        "Located near major attractions and perfect for both "
                        "vacations and business trips.",
                        style: TextStyle(height: 1.6, color: Colors.grey),
                      ),

                      const SizedBox(height: 120),
                    ],
                  ),
                ),
              ],
            ),
          ),

          /// ================= BOOKING BAR =================
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 12)],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "₹${hotel.price}",
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        "/ night",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () {
                      BookingService.bookedHotel = hotel;

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const BookingScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      "Book Now",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// reusable circle icon
  Widget _circleIcon(IconData icon, VoidCallback onTap) {
    return CircleAvatar(
      backgroundColor: Colors.white,
      child: IconButton(
        icon: Icon(icon, color: Colors.black),
        onPressed: onTap,
      ),
    );
  }
}

/// ================= INFO TILE =================
class InfoTile extends StatelessWidget {
  final String text;

  const InfoTile(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xfff2f3f7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(text),
    );
  }
}

/// ================= AMENITY CHIP =================
class AmenityChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const AmenityChip(this.icon, this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xfff2f3f7),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [Icon(icon, size: 18), const SizedBox(width: 6), Text(label)],
      ),
    );
  }
}
