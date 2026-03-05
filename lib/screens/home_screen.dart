import 'package:flutter/material.dart';
import 'search_screen.dart';
import 'login_screen.dart';
import '../services/auth_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController controller = TextEditingController();

  /// used to force rebuild on refresh
  Key refreshKey = UniqueKey();

  /// ================= IMAGE PRECACHE =================
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (var img in [
        "assets/images/img_1.jpg",
        "assets/images/img_2.jpg",
        "assets/images/img_3.jpg",
      ]) {
        precacheImage(AssetImage(img), context);
      }
    });
  }

  /// ================= PULL TO REFRESH =================
  Future<void> refreshPage() async {
    await Future.delayed(const Duration(milliseconds: 600));

    /// clear search text
    controller.clear();

    /// force full UI rebuild
    setState(() {
      refreshKey = UniqueKey();
    });
  }

  /// ================= LOGIN CHECK =================
  Future<bool> checkLogin() async {
    bool loggedIn = await AuthService.isLoggedIn();

    if (!loggedIn) {
      if (!mounted) return false;

      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
      return false;
    }
    return true;
  }

  /// ================= SEARCH =================
  Future<void> search() async {
    String location = controller.text.trim();

    if (location.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Enter location first")));
      return;
    }

    bool allowed = await checkLogin();
    if (!allowed) return;

    FocusScope.of(context).unfocus();

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => SearchScreen(location: location)),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  /// ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: refreshPage,
          child: ListView(
            key: refreshKey,
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              /// ---------------- TOP BAR ----------------
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.home_work_rounded,
                      color: Colors.red,
                      size: 28,
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      "StayEase",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    const Icon(Icons.language),
                    const SizedBox(width: 12),

                    /// MENU
                    PopupMenuButton<String>(
                      icon: const CircleAvatar(
                        radius: 16,
                        child: Icon(Icons.menu),
                      ),
                      onSelected: (value) async {
                        if (value == "login") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LoginScreen(),
                            ),
                          );
                        } else if (value == "profile") {
                          bool allowed = await checkLogin();
                          if (!allowed) return;

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Open Profile Screen"),
                            ),
                          );
                        } else if (value == "logout") {
                          await AuthService.logout();

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Logged out")),
                          );
                        }
                      },
                      itemBuilder: (context) => const [
                        PopupMenuItem(value: "login", child: Text("Login")),
                        PopupMenuItem(value: "profile", child: Text("Profile")),
                        PopupMenuItem(value: "logout", child: Text("Logout")),
                      ],
                    ),
                  ],
                ),
              ),

              /// ---------------- SEARCH BAR ----------------
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 8),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search),
                      const SizedBox(width: 10),

                      Expanded(
                        child: TextField(
                          controller: controller,
                          textInputAction: TextInputAction.search,
                          onSubmitted: (_) => search(),
                          decoration: const InputDecoration(
                            hintText: "Search destinations",
                            border: InputBorder.none,
                          ),
                        ),
                      ),

                      GestureDetector(
                        onTap: search,
                        child: const CircleAvatar(
                          backgroundColor: Colors.red,
                          child: Icon(Icons.search, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 25),

              const SectionTitle(title: "Popular homes in North Goa"),
              const HorizontalHotelList(),

              const SectionTitle(title: "Available in South Goa this weekend"),
              const HorizontalHotelList(),

              const SectionTitle(title: "Stay in Mumbai"),
              const HorizontalHotelList(),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

/// ================= SECTION TITLE =================
class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          const Icon(Icons.arrow_forward_ios, size: 16),
        ],
      ),
    );
  }
}

/// ================= HOTEL LIST =================
class HorizontalHotelList extends StatelessWidget {
  const HorizontalHotelList({super.key});

  @override
  Widget build(BuildContext context) {
    final hotels = [
      {
        "image": "assets/images/img_1.jpg",
        "title": "Flat in Arpora",
        "price": "₹5,194 for 2 nights",
        "rating": "4.94",
      },
      {
        "image": "assets/images/img_2.jpg",
        "title": "Flat in Candolim",
        "price": "₹12,188 for 2 nights",
        "rating": "4.89",
      },
      {
        "image": "assets/images/img_3.jpg",
        "title": "Flat in Vagator",
        "price": "₹7,304 for 2 nights",
        "rating": "5.0",
      },
    ];

    return SizedBox(
      height: 260,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: hotels.length,
        itemBuilder: (context, index) {
          final hotel = hotels[index];

          return HotelCard(
            image: hotel["image"]!,
            title: hotel["title"]!,
            price: hotel["price"]!,
            rating: hotel["rating"]!,
          );
        },
      ),
    );
  }
}

/// ================= HOTEL CARD =================
class HotelCard extends StatelessWidget {
  final String image;
  final String title;
  final String price;
  final String rating;

  const HotelCard({
    super.key,
    required this.image,
    required this.title,
    required this.price,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              image,
              height: 150,
              width: 200,
              fit: BoxFit.cover,
              gaplessPlayback: true,
              filterQuality: FilterQuality.high,
            ),
          ),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(price, style: const TextStyle(color: Colors.grey)),
          Row(children: [const Icon(Icons.star, size: 16), Text(" $rating")]),
        ],
      ),
    );
  }
}
