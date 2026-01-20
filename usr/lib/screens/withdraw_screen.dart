import 'package:flutter/material.dart';

class WithdrawScreen extends StatefulWidget {
  const WithdrawScreen({super.key});

  @override
  State<WithdrawScreen> createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {
  final _amountController = TextEditingController();
  final _addressController = TextEditingController();
  String _selectedCoin = 'USDT';
  bool _isLoading = false;

  final List<String> _coins = ['USDT', 'BTC', 'ETH', 'BNB'];

  void _submitWithdrawal() async {
    if (_amountController.text.isEmpty || _addressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      
      // Show success dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('Withdrawal Requested'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle_outline,
                color: Colors.green,
                size: 64,
              ),
              SizedBox(height: 16),
              Text(
                'Your withdrawal request has been submitted successfully.',
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12),
              Text(
                'Please note: All withdrawals require admin approval before processing.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Go back to dashboard
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Withdraw Funds'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                border: Border.all(color: Colors.orange.withOpacity(0.3)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.orange),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'For security reasons, all withdrawals must be approved by an administrator.',
                      style: TextStyle(color: Colors.orange),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            const Text('Select Asset'),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF2C2C2C),
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedCoin,
                  isExpanded: true,
                  dropdownColor: const Color(0xFF2C2C2C),
                  items: _coins.map((String coin) {
                    return DropdownMenuItem<String>(
                      value: coin,
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.grey[800],
                            child: Text(coin[0], style: const TextStyle(fontSize: 10)),
                          ),
                          const SizedBox(width: 12),
                          Text(coin),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedCoin = newValue!;
                    });
                  },
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            const Text('Amount'),
            const SizedBox(height: 8),
            TextField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                hintText: '0.00',
                suffixText: _selectedCoin,
              ),
            ),
            
            const SizedBox(height: 24),
            
            const Text('Wallet Address'),
            const SizedBox(height: 8),
            TextField(
              controller: _addressController,
              decoration: const InputDecoration(
                hintText: 'Enter destination address',
                suffixIcon: Icon(Icons.qr_code_scanner),
              ),
            ),
            
            const SizedBox(height: 48),
            
            ElevatedButton(
              onPressed: _isLoading ? null : _submitWithdrawal,
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      'Request Withdrawal',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
