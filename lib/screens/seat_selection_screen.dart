import 'package:flutter/material.dart';
import 'payment_screen.dart';

class SeatSelectionScreen extends StatefulWidget {
  final String movieTitle;
  final String date;
  final String time;
  final String cinema;
  final int regularTickets;
  final int vipTickets;
  final double totalAmount;

  const SeatSelectionScreen({
    Key? key,
    required this.movieTitle,
    required this.date,
    required this.time,
    required this.cinema,
    required this.regularTickets,
    required this.vipTickets,
    required this.totalAmount,
  }) : super(key: key);

  @override
  State<SeatSelectionScreen> createState() => _SeatSelectionScreenState();
}

class _SeatSelectionScreenState extends State<SeatSelectionScreen> {
  List<String> selectedSeats = [];
  int get totalTickets => widget.regularTickets + widget.vipTickets;

  // Predefined unavailable seats for demo
  final List<String> unavailableSeats = [
    'A3',
    'A4',
    'B5',
    'B6',
    'C2',
    'C3',
    'D7',
    'D8',
    'E1',
    'E2',
    'F4',
    'F5',
    'G3',
    'G7',
    'H2',
    'H8'
  ];

  // VIP seats are in the last two rows
  bool isVipSeat(String seat) {
    return seat.startsWith('G') || seat.startsWith('H');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Seats'),
        backgroundColor: Colors.red,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.movieTitle,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(widget.cinema),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(widget.date),
                    const SizedBox(width: 12),
                    Text('• ${widget.time}'),
                  ],
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _SeatLegend(color: Colors.grey, label: 'Unavailable'),
                _SeatLegend(color: Colors.white, label: 'Available'),
                _SeatLegend(color: Colors.red, label: 'Selected'),
                _SeatLegend(color: Colors.amber, label: 'VIP'),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8),
            width: double.infinity,
            color: Colors.grey[300],
            child: const Text('SCREEN',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    for (int row = 0; row < 8; row++)
                      _buildSeatRow(
                          String.fromCharCode(65 + row), 10, row >= 6),
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Selected seats (${selectedSeats.length}/$totalTickets):',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      selectedSeats.isEmpty
                          ? '- - -'
                          : selectedSeats.join(', '),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: selectedSeats.length == totalTickets
                        ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PaymentScreen(
                                  movieTitle: widget.movieTitle,
                                  date: widget.date,
                                  time: widget.time,
                                  cinema: widget.cinema,
                                  seats: selectedSeats,
                                  totalAmount: widget.totalAmount,
                                ),
                              ),
                            );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      selectedSeats.length < totalTickets
                          ? 'Select ${totalTickets - selectedSeats.length} more seat(s)'
                          : 'Continue to Payment',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeatRow(String rowName, int seatsCount, bool isVip) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          SizedBox(
            width: 30,
            child: Text(
              rowName,
              style: const TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 1; i <= seatsCount; i++)
                  _buildSeat('$rowName$i', isVip),
              ],
            ),
          ),
          const SizedBox(width: 30), // For symmetry
        ],
      ),
    );
  }

  Widget _buildSeat(String seatId, bool isVip) {
    bool isUnavailable = unavailableSeats.contains(seatId);
    bool isSelected = selectedSeats.contains(seatId);

    Color seatColor;
    if (isSelected) {
      seatColor = Colors.red;
    } else if (isUnavailable) {
      seatColor = Colors.grey;
    } else if (isVip) {
      seatColor = Colors.amber;
    } else {
      seatColor = Colors.white;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5.0),
      child: InkWell(
        onTap: isUnavailable
            ? null
            : () {
                setState(() {
                  if (isSelected) {
                    selectedSeats.remove(seatId);
                  } else {
                    if (selectedSeats.length < totalTickets) {
                      // Check if we're selecting appropriate seat type
                      if (isVip &&
                          selectedSeats.length >= widget.regularTickets) {
                        selectedSeats.add(seatId);
                      } else if (!isVip &&
                          selectedSeats.length < widget.regularTickets) {
                        selectedSeats.add(seatId);
                      } else {
                        // Show toast or alert that user needs to select the correct seat type
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(isVip
                                ? 'Please select regular seats first.'
                                : 'Please select VIP seats for your VIP tickets.'),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      }
                    }
                  }
                });
              },
        child: Container(
          width: 25,
          height: 25,
          decoration: BoxDecoration(
            color: seatColor,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: Colors.grey),
          ),
          child: isSelected
              ? const Icon(Icons.check, size: 16, color: Colors.white)
              : null,
        ),
      ),
    );
  }
}

class _SeatLegend extends StatelessWidget {
  final Color color;
  final String label;

  const _SeatLegend({
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
