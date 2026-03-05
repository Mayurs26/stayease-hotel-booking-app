import 'package:flutter/material.dart';
import '../models/hotel.dart';
import '../screens/hotel_detail_screen.dart';

class HotelCard extends StatelessWidget {
  final Hotel hotel;

  const HotelCard({super.key, required this.hotel});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Image.network(hotel.image, width: 60),
        title: Text(hotel.name),
        subtitle: Text("₹${hotel.price}/night"),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  HotelDetailScreen(hotel: hotel),
            ),
          );
        },
      ),
    );
  }
}