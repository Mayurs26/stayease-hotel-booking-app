import 'package:flutter/material.dart';
import '../services/booking_service.dart';
import 'success_screen.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    /// ✅ SAFE NULL CHECK (NO MORE CRASH)
    final hotel = BookingService.bookedHotel;

    if (hotel == null) {
      return const Scaffold(
        body: Center(
          child: Text("Booking expired", style: TextStyle(fontSize: 18)),
        ),
      );
    }

    final nights = BookingService.nights;
    final guestName = BookingService.userName ?? "Guest";
    final adults = BookingService.adults;
    final kids = BookingService.kids;
    final pets = BookingService.pets;

    /// centralized pricing
    final subtotal = BookingService.subtotal;
    final taxes = BookingService.taxes;
    final total = BookingService.totalPrice;

    return Scaffold(
      backgroundColor: const Color(0xfff6f7fb),

      appBar: AppBar(
        title: const Text("Confirm Payment"),
        backgroundColor: Colors.white,
        elevation: 0,
      ),

      body: Stack(
        children: [
          /// ================= SCROLL =================
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 140),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// ================= HOTEL CARD =================
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: _cardDecoration(),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.network(
                          hotel.image,
                          height: 90,
                          width: 110,
                          fit: BoxFit.cover,
                        ),
                      ),

                      const SizedBox(width: 14),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              hotel.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              hotel.location,
                              style: const TextStyle(color: Colors.grey),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "₹${hotel.price}/night",
                              style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(.06),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "$nights Nights",
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                /// ================= BOOKING DETAILS =================
                const Text(
                  "Booking Details",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 12),

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: _cardDecoration(),
                  child: Column(
                    children: [
                      _detailRow(Icons.person, "Guest Name", guestName),
                      _detailRow(
                        Icons.hotel,
                        "Stay Duration",
                        "$nights Night${nights > 1 ? "s" : ""}",
                      ),
                      _detailRow(
                        Icons.group,
                        "Adults",
                        "$adults Guest${adults > 1 ? "s" : ""}",
                      ),
                      _detailRow(
                        Icons.child_care,
                        "Kids",
                        "$kids ${kids == 1 ? "Child" : "Children"}",
                      ),
                      _detailRow(
                        Icons.pets,
                        "Pets",
                        pets ? "Included" : "Not Included",
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                /// ================= PRICE BREAKDOWN =================
                const Text(
                  "Price Breakdown",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 12),

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: _cardDecoration(),
                  child: Column(
                    children: [
                      _priceRow(
                        "₹${hotel.price} × $nights nights",
                        "₹$subtotal",
                      ),
                      _priceRow("GST & Taxes (12%)", "₹$taxes"),
                      const Divider(height: 25),
                      _priceRow("Total Payable", "₹$total", bold: true),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                /// PAYMENT METHOD
                const Text(
                  "Payment Method",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 12),

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: _cardDecoration(),
                  child: const Row(
                    children: [
                      Icon(Icons.credit_card),
                      SizedBox(width: 10),
                      Text("UPI / Card / Net Banking"),
                    ],
                  ),
                ),
              ],
            ),
          ),

          /// ================= PAYMENT BUTTON =================
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 20,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Total Amount",
                          style: TextStyle(color: Colors.grey),
                        ),
                        Text(
                          "₹$total",
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),

                    /// ✅ FIXED NAVIGATION (NO NULL ERROR)
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SuccessScreen(),
                        ),
                        (route) => false,
                      );

                      /// clear AFTER navigation
                      Future.microtask(() {
                        BookingService.clearBooking();
                      });
                    },

                    child: const Text(
                      "Confirm Payment",
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

  /// ================= HELPERS =================

  static BoxDecoration _cardDecoration() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(18),
    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
  );

  static Widget _priceRow(String title, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  static Widget _detailRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey),
          const SizedBox(width: 10),
          Expanded(child: Text(title)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
