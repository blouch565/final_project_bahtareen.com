import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Sample notifications data
    final List<Map<String, dynamic>> notifications = [
      {
        'title': 'Order Confirmed',
        'message': 'Your order #12345 has been confirmed and is being processed.',
        'time': '2 hours ago',
        'isRead': false,
        'icon': Icons.check_circle,
        'iconColor': Colors.green,
      },
      {
        'title': 'Flash Sale',
        'message': 'Don\'t miss our 50% off flash sale on all Electronics!',
        'time': '5 hours ago',
        'isRead': true,
        'icon': Icons.bolt,
        'iconColor': Colors.orange,
      },
      {
        'title': 'New Arrival',
        'message': 'Check out our newly arrived Fashion collection for summer.',
        'time': '1 day ago',
        'isRead': true,
        'icon': Icons.new_releases,
        'iconColor': Colors.blue,
      },
      {
        'title': 'Shipping Update',
        'message': 'Your order #12288 has been shipped and will arrive in 2 days.',
        'time': '2 days ago',
        'isRead': true,
        'icon': Icons.local_shipping,
        'iconColor': Colors.purple,
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Text(
          'Notifications',
          style: GoogleFonts.poppins(
            color: const Color(0xFF1E2A78),
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1E2A78)),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Mark all as read
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All notifications marked as read')),
              );
            },
            child: Text(
              'Mark all as read',
              style: GoogleFonts.poppins(
                color: const Color(0xFF1E2A78),
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
      body: notifications.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_off_outlined,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No notifications yet',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'You\'ll be notified about updates',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return _buildNotificationCard(context, notification);
        },
      ),
    );
  }

  Widget _buildNotificationCard(BuildContext context, Map<String, dynamic> notification) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // Handle notification tap
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Notification: ${notification['title']} tapped')),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: notification['isRead'] ? Colors.white : const Color(0xFFEEF1FF),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: notification['iconColor'].withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  notification['icon'],
                  color: notification['iconColor'],
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          notification['title'],
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          notification['time'],
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification['message'],
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}