import 'package:flutter/material.dart';

class PetPolicyScreen extends StatelessWidget {
  const PetPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pet Policy")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: const [
            Text(
              "Pets Allowed 🐾",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 12),

            Text(
              "We welcome pets! Please follow the safety and care rules below.",
            ),

            SizedBox(height: 20),

            Text(
              "Allowed Pets",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Text("• Dogs and Cats only"),
            Text("• Maximum 2 pets allowed per booking"),

            SizedBox(height: 20),

            Text(
              "Safety Policy",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Text("• Pets must be vaccinated"),
            Text("• Pets must not disturb other guests"),
            Text("• Owners are responsible for damages"),
            Text("• Keep pets on leash in public areas"),

            SizedBox(height: 20),

            Text(
              "Care Guidelines",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Text("• Do not leave pets unattended"),
            Text("• Use designated pet areas"),
            Text("• Clean after your pets"),

            SizedBox(height: 40),
          ],
        ),
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context, true);
          },
          child: const Text("I Agree & Bring Pets"),
        ),
      ),
    );
  }
}
