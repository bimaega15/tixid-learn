import 'package:flutter/material.dart';

class TicketsScreen extends StatefulWidget {
  const TicketsScreen({Key? key}) : super(key: key);

  @override
  State<TicketsScreen> createState() => _TicketsScreenState();
}

class _TicketsScreenState extends State<TicketsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tickets'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.red,
          labelColor: Colors.red,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: 'Upcoming'),
            Tab(text: 'Past'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTicketsList(isUpcoming: true),
          _buildTicketsList(isUpcoming: false),
        ],
      ),
    );
  }

  Widget _buildTicketsList({required bool isUpcoming}) {
    // Mock data for tickets
    final List<Map<String, dynamic>> tickets = isUpcoming
        ? [
            {
              'movieTitle': 'Avengers: Endgame',
              'date': 'Dec 15, 2023',
              'time': '19:30',
              'cinema': 'CineWorld Jakarta',
              'seats': 'G7, G8',
              'imageAsset': 'assets/movie1.jpg',
            },
            {
              'movieTitle': 'Spider-Man: No Way Home',
              'date': 'Dec 20, 2023',
              'time': '20:15',
              'cinema': 'CineWorld Bandung',
              'seats': 'E4, E5, E6',
              'imageAsset': 'assets/movie2.jpg',
            },
          ]
        : [
            {
              'movieTitle': 'Black Widow',
              'date': 'Nov 12, 2023',
              'time': '18:45',
              'cinema': 'CineWorld Jakarta',
              'seats': 'D10, D11',
              'imageAsset': 'assets/movie3.jpg',
            },
            {
              'movieTitle': 'Dune',
              'date': 'Nov 5, 2023',
              'time': '21:00',
              'cinema': 'CineWorld Surabaya',
              'seats': 'H3',
              'imageAsset': 'assets/movie4.jpg',
            },
          ];

    return tickets.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.confirmation_number_outlined,
                    size: 80, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  isUpcoming ? 'No upcoming tickets' : 'No past tickets',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600]),
                ),
                const SizedBox(height: 8),
                Text(
                  isUpcoming
                      ? 'Book a movie to see tickets here'
                      : 'Your movie history will appear here',
                  style: TextStyle(color: Colors.grey[500]),
                ),
              ],
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: tickets.length,
            itemBuilder: (context, index) {
              final ticket = tickets[index];
              return _buildTicketCard(ticket, isUpcoming);
            },
          );
  }

  Widget _buildTicketCard(Map<String, dynamic> ticket, bool isUpcoming) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Movie info section
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Movie poster
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: 80,
                    height: 120,
                    color: Colors.grey[300],
                    child: Center(child: Text('Poster')),
                    // In a real app: Image.asset(ticket['imageAsset'], fit: BoxFit.cover)
                  ),
                ),
                const SizedBox(width: 16),
                // Movie details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ticket['movieTitle'],
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      _buildDetailRow(Icons.calendar_today, ticket['date']),
                      const SizedBox(height: 4),
                      _buildDetailRow(Icons.access_time, ticket['time']),
                      const SizedBox(height: 4),
                      _buildDetailRow(Icons.location_on, ticket['cinema']),
                      const SizedBox(height: 4),
                      _buildDetailRow(
                          Icons.event_seat, 'Seats: ${ticket['seats']}'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Divider with movie ticket style cut
          Stack(
            children: [
              const Divider(height: 1, thickness: 1, color: Colors.grey),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  30,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    width: 5,
                    height: 1,
                    color: Colors.white,
                  ),
                ),
              ),
              Positioned(
                left: -10,
                top: -10,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(
                    color: Colors.grey,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                right: -10,
                top: -10,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(
                    color: Colors.grey,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          // Action buttons
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(
                  icon: Icons.qr_code,
                  label: 'Show QR',
                  onPressed: () {
                    // Show QR code
                  },
                ),
                _buildActionButton(
                  icon: isUpcoming ? Icons.calendar_today : Icons.replay,
                  label: isUpcoming ? 'Add Calendar' : 'Book Again',
                  onPressed: () {
                    // Add to calendar or book again
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(color: Colors.grey),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }
}
