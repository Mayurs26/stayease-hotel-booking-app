import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/hotel.dart';
import '../widgets/modern_hotel_card.dart';

class SearchScreen extends StatefulWidget {
  final String location;

  const SearchScreen({super.key, required this.location});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Hotel> results = [];
  bool loading = false;

  late TextEditingController searchController;

  /// ================= INIT =================
  @override
  void initState() {
    super.initState();

    searchController = TextEditingController(text: widget.location);

    loadHotels(widget.location);
  }

  /// IMPORTANT (fix memory issue)
  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  /// ================= API CALL =================
  Future<void> loadHotels(String location) async {
    setState(() {
      loading = true;
      results.clear();
    });

    try {
      final data = await ApiService.fetchHotels();

      final filtered = data.where((h) {
        final hotelLocation = h["location"].toString().toLowerCase();

        final searchLocation = location.trim().toLowerCase();

        return hotelLocation.contains(searchLocation);
      }).toList();

      if (!mounted) return;

      setState(() {
        results = filtered.map<Hotel>((h) {
          return Hotel(
            name: h["name"],
            location: h["location"],
            price: h["price"],
            image: h["image"],
          );
        }).toList();

        loading = false;
      });
    } catch (e) {
      print("API ERROR: $e");

      if (!mounted) return;

      setState(() => loading = false);
    }
  }

  /// ================= SEARCH ACTION =================
  void performSearch() {
    FocusScope.of(context).unfocus();

    final query = searchController.text.trim();

    if (query.isEmpty) return;

    loadHotels(query);
  }

  /// ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff4f6f8),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          "Search Hotels",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),

      body: Column(
        children: [
          /// 🔥 SEARCH BAR
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, color: Colors.grey),

                  const SizedBox(width: 8),

                  Expanded(
                    child: TextField(
                      controller: searchController,
                      textInputAction: TextInputAction.search,
                      onSubmitted: (_) => performSearch(),
                      decoration: const InputDecoration(
                        hintText: "Search city (Pune, Mumbai...)",
                        border: InputBorder.none,
                      ),
                    ),
                  ),

                  GestureDetector(
                    onTap: performSearch,
                    child: const CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.red,
                      child: Icon(Icons.search, color: Colors.white, size: 18),
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// RESULT COUNT
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                loading ? "Searching..." : "${results.length} stays found",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),

          /// LIST
          Expanded(
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : results.isEmpty
                ? const EmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: results.length,
                    itemBuilder: (_, i) => ModernHotelCard(hotel: results[i]),
                  ),
          ),
        ],
      ),
    );
  }
}

/// EMPTY STATE
class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.hotel, size: 70, color: Colors.grey),
          SizedBox(height: 10),
          Text(
            "No hotels found",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text("Try another location", style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
