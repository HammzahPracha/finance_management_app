import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_controller.dart';
import '../controllers/transaction_controller.dart';
import '../widgets/transaction_card.dart';
import 'settings_screen.dart';
import 'edit_profile_screen.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'Profile',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF111827),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const EditProfileScreen()),
              );
              // rebuild after edit
              if (context.mounted) {
                setState(() {});
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );

            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Consumer<AuthController>(
          builder: (context, authController, _) {
            final user = authController.currentUser;
            if (user == null) {
              return const Center(child: Text('Not logged in'));
            }

            return Column(
              children: [
                // Profile Header
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.primary.withOpacity(0.1),
                        child: Text(
                          user.name.isNotEmpty
                              ? user.name[0].toUpperCase()
                              : 'U',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        user.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF111827),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user.email,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      if (user.phoneNumber != null &&
                          user.phoneNumber!.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          user.phoneNumber!,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Stats
                Consumer<TransactionController>(
                  builder: (context, transactionController, _) {
                    return FutureBuilder(
                      future: Future.wait([
                        transactionController.getTotalIncome(user.id),
                        transactionController.getTotalExpense(user.id),
                      ]),
                      builder: (context, snapshot) {
                        final income = snapshot.data?[0] ?? 0.0;
                        final expense = snapshot.data?[1] ?? 0.0;

                        return Row(
                          children: [
                            Expanded(
                              child: _buildStatCard(
                                context,
                                'Total Income',
                                '\$${income.toStringAsFixed(2)}',
                                const Color(0xFF10B981),
                                Icons.trending_up,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildStatCard(
                                context,
                                'Total Expense',
                                '\$${expense.toStringAsFixed(2)}',
                                const Color(0xFFEF4444),
                                Icons.trending_down,
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: 24),
                // All Transactions
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'All Transactions',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF111827),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Consumer<TransactionController>(
                  builder: (context, transactionController, _) {
                    if (transactionController.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final transactions = transactionController.transactions;

                    if (transactions.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Column(
                            children: [
                              Icon(
                                Icons.receipt_long_outlined,
                                size: 64,
                                color: Colors.grey.shade300,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No transactions yet',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    return Column(
                      children: transactions.map((transaction) {
                        return TransactionCard(
                          transaction: transaction,
                          onDelete: () async {
                            await transactionController.deleteTransaction(
                              transaction.id,
                            );
                            if (authController.currentUser != null) {
                              await transactionController.loadTransactions(
                                authController.currentUser!.id,
                              );
                            }
                          },
                        );
                      }).toList(),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatCard(
      BuildContext context,
      String label,
      String value,
      Color color,
      IconData icon,
      ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

}

