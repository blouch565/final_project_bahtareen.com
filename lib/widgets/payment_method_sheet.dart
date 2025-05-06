import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaymentMethodSheet extends StatelessWidget {
  final Function(String) onPaymentSelected;

  const PaymentMethodSheet({
    Key? key,
    required this.onPaymentSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 16),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Title
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              'Select Payment Method',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          // Payment methods
          _buildPaymentMethod(
            context,
            'Credit/Debit Card',
            Icons.credit_card,
            'card',
          ),

          _buildPaymentMethod(
            context,
            'Easypaisa',
            Icons.account_balance_wallet,
            'easypaisa',
            color: Colors.green,
          ),

          _buildPaymentMethod(
            context,
            'JazzCash',
            Icons.phone_android,
            'jazzcash',
            color: Colors.red,
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildPaymentMethod(
      BuildContext context,
      String title,
      IconData icon,
      String method, {
        Color? color,
      }) {
    return InkWell(
      onTap: () => onPaymentSelected(method),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: (color ?? const Color(0xFF1E2A78)).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: color ?? const Color(0xFF1E2A78),
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey[400],
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}