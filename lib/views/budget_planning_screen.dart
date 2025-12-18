import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controllers/auth_controller.dart';
import '../controllers/transaction_controller.dart';

class BudgetPlanningScreen extends StatefulWidget {
  const BudgetPlanningScreen({super.key});

  @override
  State<BudgetPlanningScreen> createState() => _BudgetPlanningScreenState();
}

class _BudgetPlanningScreenState extends State<BudgetPlanningScreen> {
  final _budgetController = TextEditingController();
  double _currentExpense = 0;
  double _budget = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _load();
    });
  }

  @override
  void dispose() {
    _budgetController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final auth = Provider.of<AuthController>(context, listen: false);
    final tx = Provider.of<TransactionController>(context, listen: false);
    if (auth.currentUser == null) return;

    final currency = tx.selectedCurrency;
    final prefs = await SharedPreferences.getInstance();
    final savedBudget = prefs.getDouble('budget_$currency') ?? 0;
    final expense = await tx.getTotalExpense(auth.currentUser!.id);

    setState(() {
      _budget = savedBudget;
      _budgetController.text = savedBudget == 0
          ? ''
          : savedBudget.toStringAsFixed(0);
      _currentExpense = expense;
    });
  }

  Future<void> _saveBudget() async {
    final tx = Provider.of<TransactionController>(context, listen: false);
    final currency = tx.selectedCurrency;
    final prefs = await SharedPreferences.getInstance();
    final value = double.tryParse(_budgetController.text.trim()) ?? 0;
    await prefs.setDouble('budget_$currency', value);
    setState(() {
      _budget = value;
    });
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Budget saved')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final tx = Provider.of<TransactionController>(context);
    final currency = tx.selectedCurrency;
    final remaining = _budget - _currentExpense;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Budget Planning'),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Current Month Overview',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _row('Selected Currency', currency),
                    _row('Budget', '$currency ${_budget.toStringAsFixed(0)}'),
                    _row(
                      'Spent',
                      '$currency ${_currentExpense.toStringAsFixed(0)}',
                    ),
                    _row(
                      'Remaining',
                      '$currency ${remaining.toStringAsFixed(0)}',
                      valueColor: remaining >= 0
                          ? const Color(0xFF10B981)
                          : const Color(0xFFEF4444),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _budgetController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Monthly Budget',
                hintText: 'Enter amount',
                prefixIcon: Icon(Icons.savings_outlined),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _saveBudget,
                icon: const Icon(Icons.check_circle_outline),
                label: const Text('Save Budget'),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Tip: Use the currency switch on Dashboard to plan budgets in PKR or USD separately.',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey.shade700)),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: valueColor ?? const Color(0xFF111827),
            ),
          ),
        ],
      ),
    );
  }
}
