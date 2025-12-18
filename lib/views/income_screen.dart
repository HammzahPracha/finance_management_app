import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_controller.dart';
import '../controllers/transaction_controller.dart';
import '../models/transaction_model.dart';
import '../widgets/transaction_card.dart';

class IncomeScreen extends StatefulWidget {
  const IncomeScreen({super.key});

  @override
  State<IncomeScreen> createState() => _IncomeScreenState();
}

class _IncomeScreenState extends State<IncomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _load();
    });
  }

  Future<void> _load() async {
    final auth = Provider.of<AuthController>(context, listen: false);
    final tx = Provider.of<TransactionController>(context, listen: false);
    if (auth.currentUser != null) {
      await tx.loadTransactions(auth.currentUser!.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Income'),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: RefreshIndicator(
        onRefresh: _load,
        child: Consumer<TransactionController>(
          builder: (context, txController, _) {
            final items = txController.transactions
                .where((t) => t.type == TransactionType.income)
                .toList();

            if (txController.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (items.isEmpty) {
              return const Center(child: Text('No income yet'));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final transaction = items[index];
                return TransactionCard(transaction: transaction);
              },
            );
          },
        ),
      ),
    );
  }
}
