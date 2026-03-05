import 'package:flutter/material.dart';
import '../services/booking_service.dart';
import '../services/auth_service.dart';
import 'payment_screen.dart';
import 'login_screen.dart';
import 'pet_policy_screen.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final nameController = TextEditingController();

  int nights = 1;
  int adults = 2;
  int kids = 0;
  bool bringingPets = false;

  /// ================= PAYMENT VALIDATION =================
  Future<void> handlePayment() async {
    if (nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Enter guest name")));
      return;
    }

    bool loggedIn = await AuthService.isLoggedIn();

    if (!loggedIn) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
      return;
    }

    BookingService.userName = nameController.text;
    BookingService.nights = nights;
    BookingService.adults = adults;
    BookingService.kids = kids;
    BookingService.pets = bringingPets;

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PaymentScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hotel = BookingService.bookedHotel!;
    final subtotal = hotel.price * nights;
    final taxes = (subtotal * 0.12).round();
    final total = subtotal + taxes;

    return Scaffold(
      backgroundColor: const Color(0xfff6f7fb),
      resizeToAvoidBottomInset: false,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          "Confirm & Pay",
          style: TextStyle(color: Colors.black),
        ),
      ),

      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 160),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// HOTEL SUMMARY
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: _cardDecoration(),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          hotel.image,
                          height: 90,
                          width: 110,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 12),
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
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                /// GUEST NAME
                const Text(
                  "Guest Details",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 12),

                Container(
                  decoration: _cardDecoration(),
                  child: TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person_outline),
                      hintText: "Guest full name",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 18),
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                /// NIGHT SELECTOR
                const Text(
                  "Stay Duration",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 12),

                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: _cardDecoration(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Nights", style: TextStyle(fontSize: 16)),
                      Row(
                        children: [
                          _qtyButton(Icons.remove, () {
                            if (nights > 1) setState(() => nights--);
                          }),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            child: Text(
                              "$nights",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          _qtyButton(Icons.add, () => setState(() => nights++)),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                /// GUESTS & PETS
                const Text(
                  "Guests & Pets",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 12),

                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: _cardDecoration(),
                  child: Column(
                    children: [
                      _counterRow("Adults", adults, () {
                        if (adults > 1) setState(() => adults--);
                      }, () => setState(() => adults++)),

                      const Divider(),

                      _counterRow("Kids", kids, () {
                        if (kids > 0) setState(() => kids--);
                      }, () => setState(() => kids++)),

                      const Divider(),

                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.pets),
                        title: const Text("Bringing Pets"),
                        subtitle: Text(
                          bringingPets ? "Pets Included" : "View pet policy",
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const PetPolicyScreen(),
                            ),
                          );

                          if (result != null) {
                            setState(() => bringingPets = result);
                          }
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                /// PRICE DETAILS
                const Text(
                  "Price Details",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 12),

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: _cardDecoration(),
                  child: Column(
                    children: [
                      _priceRow(
                        "₹${hotel.price} x $nights nights",
                        "₹$subtotal",
                      ),
                      _priceRow("Taxes & Fees (12%)", "₹$taxes"),
                      const Divider(height: 25),
                      _priceRow("Total", "₹$total", bold: true),
                    ],
                  ),
                ),
              ],
            ),
          ),

          /// PAYMENT BAR
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(18),
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
                          style: TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "₹$total",
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: handlePayment,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 26,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xff000000), Color(0xff2b2b2b)],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Row(
                        children: [
                          Text(
                            "Pay Now",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 6),
                          Icon(
                            Icons.arrow_forward_rounded,
                            color: Colors.white,
                          ),
                        ],
                      ),
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

  BoxDecoration _cardDecoration() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
  );

  Widget _qtyButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: const Color(0xfff1f2f6),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon),
      ),
    );
  }

  Widget _counterRow(
    String title,
    int value,
    VoidCallback minus,
    VoidCallback plus,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 16)),
        Row(
          children: [
            _qtyButton(Icons.remove, minus),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Text(
                "$value",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            _qtyButton(Icons.add, plus),
          ],
        ),
      ],
    );
  }

  Widget _priceRow(String title, String value, {bool bold = false}) {
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
}
