import '../models/hotel.dart';

class BookingService {
  /// ================= SELECTED HOTEL =================
  static Hotel? bookedHotel;

  /// ================= USER BOOKING DATA =================
  static String? userName;

  static int nights = 1;
  static int adults = 2;
  static int kids = 0;
  static bool pets = false;

  /// ================= PRICE CALCULATION =================
  static int get subtotal => (bookedHotel?.price ?? 0) * nights;

  static int get taxes => (subtotal * 0.12).round();

  static int get totalPrice => subtotal + taxes;

  /// ================= RESET BOOKING =================
  static void clearBooking() {
    bookedHotel = null;
    userName = null;
    nights = 1;
    adults = 2;
    kids = 0;
    pets = false;
  }
}
