import 'package:flutter/material.dart';
import 'seat_selection_screen.dart';
import 'payment_screen.dart'; // Add this import
import 'dart:ui';
import 'package:intl/intl.dart'; // Add this import for number formatting

class TicketSelectionScreen extends StatefulWidget {
  final String movieTitle;
  final String date;
  final String time;
  final String cinema;

  const TicketSelectionScreen({
    Key? key,
    required this.movieTitle,
    required this.date,
    required this.time,
    required this.cinema,
  }) : super(key: key);

  @override
  State<TicketSelectionScreen> createState() => _TicketSelectionScreenState();
}

class _TicketSelectionScreenState extends State<TicketSelectionScreen>
    with SingleTickerProviderStateMixin {
  int regularTickets = 0;
  int vipTickets = 0;
  Set<String> selectedSeats = {};

  // Changed from late to nullable with initialization
  AnimationController? _animationController;
  Animation<double>? _animation;

  final double regularPrice = 45000;
  final double vipPrice = 85000;

  // Custom colors
  final Color primaryColor = const Color(0xFFE41E30);
  final Color vipSeatColor = const Color(0xFFFFC107);
  final Color regularSeatColor = const Color(0xFF64B5F6);
  final Color selectedSeatColor = const Color(0xFFE41E30);
  final Color backgroundColor = const Color(0xFFF8F8F8);
  final Color darkTextColor = const Color(0xFF212121);
  final Color lightTextColor = const Color(0xFF757575);

  double get totalAmount =>
      (regularTickets * regularPrice) + (vipTickets * vipPrice);
  int get totalTickets => regularTickets + vipTickets;

  // Define seat layout
  final List<List<bool>> seatAvailability = List.generate(
    8, // rows
    (i) => List.generate(
      10, // seats per row
      (j) => true, // all seats available initially
    ),
  );

  // Add money formatter helper method
  String formatMoney(double amount) {
    final formatter = NumberFormat('#,###', 'id_ID');
    return 'Rp ${formatter.format(amount.toInt())}';
  }

  @override
  void initState() {
    super.initState();
    // Initialize the animation controller
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    // Initialize the animation
    _animation = CurvedAnimation(
      parent: _animationController!,
      curve: Curves.easeInOut,
    );
    // Start the animation
    _animationController!.forward();
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  void _updateTicketCounts() {
    // Count selected seats in regular and VIP sections
    int regular = 0;
    int vip = 0;

    for (String seat in selectedSeats) {
      // Row A-D are VIP, E-H are regular
      int row = seat.codeUnitAt(0) - 'A'.codeUnitAt(0);
      if (row < 4) {
        vip++;
      } else {
        regular++;
      }
    }

    setState(() {
      vipTickets = vip;
      regularTickets = regular;
    });
  }

  void _toggleSeat(int row, int seat) {
    String seatId =
        '${String.fromCharCode('A'.codeUnitAt(0) + row)}${seat + 1}';

    setState(() {
      if (selectedSeats.contains(seatId)) {
        selectedSeats.remove(seatId);
      } else {
        selectedSeats.add(seatId);
      }
      _updateTicketCounts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Select Tickets',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: primaryColor,
        centerTitle: true,
      ),
      // Modified to handle nullable _animation
      body: _animation != null
          ? FadeTransition(
              opacity: _animation!,
              // Fix the overflow by using a Stack with a scrollable content and fixed bottom button
              child: Stack(
                children: [
                  // Scrollable content
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          bottom:
                              80.0), // Add padding at bottom for the fixed button
                      child: Column(
                        children: [
                          // Movie Info Card
                          Container(
                            margin: const EdgeInsets.all(16.0),
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 10,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.movieTitle,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: darkTextColor,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Icon(Icons.location_on,
                                        size: 16, color: primaryColor),
                                    const SizedBox(width: 6),
                                    Text(
                                      widget.cinema,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: lightTextColor,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(Icons.calendar_today,
                                        size: 16, color: primaryColor),
                                    const SizedBox(width: 6),
                                    Text(
                                      widget.date,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: lightTextColor,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Icon(Icons.access_time,
                                        size: 16, color: primaryColor),
                                    const SizedBox(width: 6),
                                    Text(
                                      widget.time,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: lightTextColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // Seat Selection Section
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            child: Column(
                              children: [
                                // Screen
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 40.0, vertical: 8.0),
                                  alignment: Alignment.center,
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10.0),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.grey.withOpacity(0.1),
                                          Colors.grey.withOpacity(0.3)
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                      ),
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                      ),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        'SCREEN',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black54,
                                          letterSpacing: 3,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                // Seats grid with more padding at top to show perspective
                                const SizedBox(height: 10),
                                SizedBox(
                                  height: 240,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: List.generate(
                                        seatAvailability.length,
                                        (rowIndex) {
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 3.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  width: 24,
                                                  child: Text(
                                                    '${String.fromCharCode('A'.codeUnitAt(0) + rowIndex)}',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: rowIndex < 4
                                                          ? vipSeatColor
                                                          : regularSeatColor,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                ...List.generate(
                                                  seatAvailability[rowIndex]
                                                      .length,
                                                  (seatIndex) {
                                                    String seatId =
                                                        '${String.fromCharCode('A'.codeUnitAt(0) + rowIndex)}${seatIndex + 1}';
                                                    bool isSelected =
                                                        selectedSeats
                                                            .contains(seatId);
                                                    bool isVip = rowIndex <
                                                        4; // Rows A-D are VIP

                                                    return GestureDetector(
                                                      onTap: () => _toggleSeat(
                                                          rowIndex, seatIndex),
                                                      child: Container(
                                                        margin: const EdgeInsets
                                                            .all(2),
                                                        width: 26,
                                                        height: 26,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: isSelected
                                                              ? selectedSeatColor
                                                              : (isVip
                                                                  ? vipSeatColor
                                                                      .withOpacity(
                                                                          0.2)
                                                                  : regularSeatColor
                                                                      .withOpacity(
                                                                          0.2)),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(6),
                                                          border: Border.all(
                                                            color: isSelected
                                                                ? selectedSeatColor
                                                                : (isVip
                                                                    ? vipSeatColor
                                                                    : regularSeatColor),
                                                            width: 1.5,
                                                          ),
                                                          boxShadow: isSelected
                                                              ? [
                                                                  BoxShadow(
                                                                    color: selectedSeatColor
                                                                        .withOpacity(
                                                                            0.4),
                                                                    blurRadius:
                                                                        4,
                                                                    spreadRadius:
                                                                        0,
                                                                  )
                                                                ]
                                                              : null,
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                            (seatIndex + 1)
                                                                .toString(),
                                                            style: TextStyle(
                                                              fontSize: 11,
                                                              fontWeight: isSelected
                                                                  ? FontWeight
                                                                      .bold
                                                                  : FontWeight
                                                                      .normal,
                                                              color: isSelected
                                                                  ? Colors.white
                                                                  : (isVip
                                                                      ? vipSeatColor
                                                                          .withOpacity(
                                                                              0.9)
                                                                      : regularSeatColor
                                                                          .withOpacity(
                                                                              0.9)),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),

                                // Legend with improved design
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 16.0, bottom: 8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      _buildLegendItem(vipSeatColor, 'VIP'),
                                      const SizedBox(width: 20),
                                      _buildLegendItem(
                                          regularSeatColor, 'Regular'),
                                      const SizedBox(width: 20),
                                      _buildLegendItem(
                                          selectedSeatColor, 'Selected'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const Divider(
                              height: 1,
                              thickness: 1,
                              color: Color(0xFFEEEEEE)),

                          // Tickets Summary - Enhanced UI
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Tickets Summary',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: darkTextColor,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 10,
                                        spreadRadius: 0,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Regular Seats',
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: lightTextColor,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 4),
                                                decoration: BoxDecoration(
                                                  color: regularSeatColor
                                                      .withOpacity(0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: Text(
                                                  '$regularTickets',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: regularSeatColor,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                formatMoney(regularPrice),
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 12.0),
                                        child: Divider(height: 1),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'VIP Seats',
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: lightTextColor,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 4),
                                                decoration: BoxDecoration(
                                                  color: vipSeatColor
                                                      .withOpacity(0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: Text(
                                                  '$vipTickets',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: vipSeatColor,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                formatMoney(vipPrice),
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),
                                if (totalTickets > 0)
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.05),
                                          blurRadius: 10,
                                          offset: const Offset(0, -2),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              'Total Amount',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Text(
                                              formatMoney(totalAmount),
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                                color: primaryColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Fixed Checkout button at bottom
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, -2),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: totalTickets > 0
                            ? () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PaymentScreen(
                                      movieTitle: widget.movieTitle,
                                      date: widget.date,
                                      time: widget.time,
                                      cinema: widget.cinema,
                                      totalAmount: totalAmount,
                                      seats: selectedSeats
                                          .toList(), // Convert Set to List
                                    ),
                                  ),
                                );
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Checkout',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : Container(
              // Fallback if animation isn't ready
              color: backgroundColor,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            color: label == 'Selected' ? color : color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: color, width: 1.5),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: darkTextColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
