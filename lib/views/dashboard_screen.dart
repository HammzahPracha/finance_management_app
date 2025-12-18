import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_controller.dart';
import '../controllers/transaction_controller.dart';
import '../widgets/balance_card.dart';
import '../widgets/transaction_card.dart';
import '../widgets/category_chart.dart';
import '../widgets/line_chart_widget.dart';
import '../models/transaction_model.dart';
import 'settings_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    final authController = Provider.of<AuthController>(context, listen: false);
    final transactionController = Provider.of<TransactionController>(
      context,
      listen: false,
    );

    if (authController.currentUser != null) {
      await transactionController.loadTransactions(
        authController.currentUser!.id,
      );
    }
  }

  Future<void> _changeCurrency(String currency) async {
    final authController = Provider.of<AuthController>(context, listen: false);
    final transactionController = Provider.of<TransactionController>(
      context,
      listen: false,
    );
    transactionController.setCurrency(currency);
    if (authController.currentUser != null) {
      await transactionController.loadTransactions(
        authController.currentUser!.id,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Consumer<AuthController>(
          builder: (context, authController, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome Back',
                  style: TextStyle(fontSize: 22, color: Colors.grey.shade600),
                ),
                Text(
                  ' ${authController.currentUser?.name ?? 'User'}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827),
                  ),
                ),

              ],
            );
          },
        ),
        actions: [
          Consumer<TransactionController>(
            builder: (context, transactionController, _) {
              return Padding(
                padding: const EdgeInsets.only(right: 4.0),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: transactionController.selectedCurrency,
                    items: const [
                      DropdownMenuItem(value: 'PKR', child: Text('PKR')),
                      DropdownMenuItem(value: 'USD', child: Text('USD')),
                      DropdownMenuItem(value: 'EURO', child: Text('EURO')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        _changeCurrency(value);
                      }
                    },
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const SettingsScreen()));
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Balance Card
              Consumer2<AuthController, TransactionController>(
                builder: (context, authController, transactionController, _) {
                  if (authController.currentUser == null) {
                    return const SizedBox();
                  }

                  return FutureBuilder(
                    future: Future.wait([
                      transactionController.getTotalIncome(
                        authController.currentUser!.id,
                      ),
                      transactionController.getTotalExpense(
                        authController.currentUser!.id,
                      ),
                      transactionController.getBalance(
                        authController.currentUser!.id,
                      ),
                    ]),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final income = snapshot.data?[0] ?? 0.0;
                      final expense = snapshot.data?[1] ?? 0.0;
                      final balance = snapshot.data?[2] ?? 0.0;

                      return BalanceCard(
                        balance: balance,
                        income: income,
                        expense: expense,
                        currency: transactionController.selectedCurrency,
                      );
                      },

                  );
                },
              ),
              const SizedBox(height: 24),
              // Charts Section
              _buildChartsSection(),
              const SizedBox(height: 24),
              // Recent Transactions
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recent Transactions',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF120606),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Navigate to all transactions
                    },
                    child: const Text('See All'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Transactions List
              Consumer2<AuthController, TransactionController>(
                builder: (context, authController, transactionController, _) {
                  if (transactionController.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final transactions = transactionController.transactions
                      .take(5)
                      .toList();

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
                            const SizedBox(height: 8),
                            Text(
                              'Add your first transaction to get started',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade500,
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
          ),
        ),
      ),
    );
  }

  Widget _buildChartsSection() {
    return Consumer2<AuthController, TransactionController>(
      builder: (context, authController, transactionController, _) {
        if (authController.currentUser == null) {
          return const SizedBox();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Analytics',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF112721),
              ),
            ),
            const SizedBox(height: 16),
            // Line Chart
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Income & Expense Trend',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 200,
                    child: LineChartWidget(
                      transactions: transactionController.transactions,
                      type: TransactionType.expense,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Pie Charts Row
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Income',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        FutureBuilder(
                          future: transactionController.getCategoryTotals(
                            authController.currentUser!.id,
                            TransactionType.income,
                            transactionController.selectedCurrency,
                          ),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const SizedBox(
                                height: 150,
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }
                            final data = snapshot.data ?? {};
                            return SizedBox(
                              height: 150,
                              child: CategoryChart(
                                categoryData: data,
                                type: TransactionType.income,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Expense',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        FutureBuilder(
                          future: transactionController.getCategoryTotals(
                            authController.currentUser!.id,
                            TransactionType.expense,
                            transactionController.selectedCurrency,
                          ),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const SizedBox(
                                height: 150,
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }
                            final data = snapshot.data ?? {};
                            return SizedBox(
                              height: 150,
                              child: CategoryChart(
                                categoryData: data,
                                type: TransactionType.expense,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
