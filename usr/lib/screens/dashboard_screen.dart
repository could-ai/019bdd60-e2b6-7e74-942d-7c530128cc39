import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Mock data
  final double _balance = 12450.75;
  final List<Map<String, dynamic>> _transactions = [
    {
      'type': 'Deposit',
      'amount': 5000.00,
      'date': DateTime.now().subtract(const Duration(days: 1)),
      'status': 'Completed',
      'coin': 'USDT',
    },
    {
      'type': 'Withdrawal',
      'amount': 1200.00,
      'date': DateTime.now().subtract(const Duration(days: 3)),
      'status': 'Pending Approval',
      'coin': 'BTC',
    },
    {
      'type': 'Deposit',
      'amount': 2500.00,
      'date': DateTime.now().subtract(const Duration(days: 5)),
      'status': 'Completed',
      'coin': 'ETH',
    },
    {
      'type': 'Withdrawal',
      'amount': 500.00,
      'date': DateTime.now().subtract(const Duration(days: 10)),
      'status': 'Approved',
      'coin': 'USDT',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '\$');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () {
              // Logout for demo
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Balance Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6C63FF), Color(0xFF4834D4)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6C63FF).withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Total Balance',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    currencyFormat.format(_balance),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: _ActionButton(
                          icon: Icons.arrow_downward,
                          label: 'Deposit',
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Deposit feature coming soon')),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _ActionButton(
                          icon: Icons.arrow_upward,
                          label: 'Withdraw',
                          onTap: () {
                            Navigator.pushNamed(context, '/withdraw');
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Recent Transactions
            const Text(
              'Recent Transactions',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _transactions.length,
              itemBuilder: (context, index) {
                final tx = _transactions[index];
                final isDeposit = tx['type'] == 'Deposit';
                final isPending = tx['status'] == 'Pending Approval';
                
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: CircleAvatar(
                      backgroundColor: isDeposit 
                          ? Colors.green.withOpacity(0.1) 
                          : Colors.red.withOpacity(0.1),
                      child: Icon(
                        isDeposit ? Icons.arrow_downward : Icons.arrow_upward,
                        color: isDeposit ? Colors.green : Colors.red,
                      ),
                    ),
                    title: Text(
                      tx['type'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(DateFormat('MMM d, yyyy • h:mm a').format(tx['date'])),
                        if (isPending)
                          Container(
                            margin: const EdgeInsets.only(top: 4),
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'Pending Approval',
                              style: TextStyle(
                                color: Colors.orange,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${isDeposit ? '+' : '-'}${currencyFormat.format(tx['amount'])}',
                          style: TextStyle(
                            color: isDeposit ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          tx['coin'],
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withOpacity(0.2),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
