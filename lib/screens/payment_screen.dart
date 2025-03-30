import 'package:flutter/material.dart';
import 'ticket_confirmation_screen.dart';

class PaymentScreen extends StatefulWidget {
  final String movieTitle;
  final String date;
  final String time;
  final String cinema;
  final List<String> seats;
  final double totalAmount;

  const PaymentScreen({
    Key? key,
    required this.movieTitle,
    required this.date,
    required this.time,
    required this.cinema,
    required this.seats,
    required this.totalAmount,
  }) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String? selectedPaymentMethod;
  bool isProcessing = false;

  final List<Map<String, dynamic>> paymentMethods = [
    {
      'name': 'Credit/Debit Card',
      'icon': Icons.credit_card,
      'type': 'card',
      'description': 'Pay securely with your card',
    },
    {
      'name': 'E-Wallet',
      'icon': Icons.account_balance_wallet,
      'type': 'wallet',
      'description': 'DANA, OVO, GoPay, LinkAja',
    },
    {
      'name': 'Bank Transfer',
      'icon': Icons.account_balance,
      'type': 'transfer',
      'description': 'Direct transfer to our bank account',
    },
    {
      'name': 'PayLater',
      'icon': Icons.watch_later_outlined,
      'type': 'later',
      'description': 'Buy now, pay later with installments',
    },
  ];

  void processPayment() {
    setState(() {
      isProcessing = true;
    });

    // Simulate payment processing delay
    Future.delayed(const Duration(seconds: 2), () {
      // Check for network issues or simulate payment failures
      bool paymentSuccessful =
          DateTime.now().second % 2 == 0; // Simulate success or failure

      if (paymentSuccessful) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => TicketConfirmationScreen(
              movieTitle: widget.movieTitle,
              date: widget.date,
              time: widget.time,
              cinema: widget.cinema,
              seats: widget.seats,
              totalAmount: widget.totalAmount,
              paymentMethod: selectedPaymentMethod!,
            ),
          ),
        );
      } else {
        setState(() {
          isProcessing = false;
        });

        // Show payment failure dialog
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Payment Failed'),
            content: const Text(
                'We couldn\'t process your payment. Please try again or use a different payment method.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        backgroundColor: Colors.red,
      ),
      body: Container(
        color: Colors.white,
        child: Stack(
          children: [
            Column(
              children: [
                _buildOrderSummary(),
                const SizedBox(height: 16),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Payment Methods',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.builder(
                    itemCount: paymentMethods.length,
                    itemBuilder: (context, index) {
                      final method = paymentMethods[index];
                      final isSelected =
                          selectedPaymentMethod == method['type'];

                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        elevation: isSelected ? 4 : 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: isSelected ? Colors.red : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              selectedPaymentMethod = method['type'];
                            });
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                Icon(method['icon'], color: Colors.red),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        method['name'],
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        method['description'],
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (isSelected)
                                  const Icon(Icons.check_circle,
                                      color: Colors.red),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: selectedPaymentMethod != null && !isProcessing
                          ? processPayment
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        isProcessing ? 'Processing...' : 'Pay Now',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (isProcessing)
              Container(
                color: Colors.black.withOpacity(0.3),
                child: const Center(
                  child: CircularProgressIndicator(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      color: Colors.grey[100],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Order Summary',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.movieTitle,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(widget.cinema),
                    const SizedBox(height: 4),
                    Text('${widget.date} • ${widget.time}'),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('${widget.seats.length} Tickets'),
                  Text(
                    'Rp ${widget.totalAmount.toInt()}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Amount',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'Rp ${widget.totalAmount.toInt()}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
