import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../controllers/auth_controller.dart';
import '../controllers/transaction_controller.dart';
import '../models/transaction_model.dart';
import '../models/category_model.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  TransactionType _selectedType = TransactionType.expense;
  CategoryModel? _selectedCategory;
  DateTime _selectedDate = DateTime.now();
  String _selectedCurrency = 'PKR';

  @override
  void initState() {
    super.initState();
    final transactionController =
    Provider.of<TransactionController>(context, listen: false);
    _selectedCurrency = transactionController.selectedCurrency;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectCategory() async {
    final categories = _selectedType == TransactionType.income
        ? Categories.incomeCategories
        : Categories.expenseCategories;

    final selected = await showModalBottomSheet<CategoryModel>(
      context: context,
      isScrollControlled: true, // ⭐ VERY IMPORTANT
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.6, // ⭐ LIMIT HEIGHT
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text(
                    'Select Category',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  Expanded( // ⭐ THIS FIXES OVERFLOW
                    child: GridView.builder(
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        return InkWell(
                          onTap: () => Navigator.of(context).pop(category),
                          child: Container(
                            decoration: BoxDecoration(
                              color: category.color.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(category.icon,
                                    style: const TextStyle(fontSize: 24)),
                                const SizedBox(height: 4),
                                Text(
                                  category.name,
                                  style: const TextStyle(fontSize: 10),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    if (selected != null) {
      setState(() {
        _selectedCategory = selected;
      });
    }
  }

  Future<void> _saveTransaction() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a category')),
      );
      return;
    }

    final authController = Provider.of<AuthController>(context, listen: false);
    final transactionController =
    Provider.of<TransactionController>(context, listen: false);

    if (authController.currentUser == null) return;

    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount')),
      );
      return;
    }

    final success = await transactionController.addTransaction(
      title: _titleController.text.trim(),
      amount: amount,
      type: _selectedType,
      category: _selectedCategory!.id,
      userId: authController.currentUser!.id,
      currency: _selectedCurrency,
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      date: _selectedDate,
    );

    if (!mounted) return;

    if (success) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Transaction added successfully'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Transaction'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Type buttons
              Row(
                children: [
                  Expanded(
                    child: _buildTypeButton(
                        'Income', TransactionType.income, Colors.green),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTypeButton(
                        'Expense', TransactionType.expense, Colors.red),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Title
              CustomTextField(
                label: 'Title',
                hint: 'Enter title',
                controller: _titleController,
                prefixIcon: const Icon(Icons.title),
              ),

              const SizedBox(height: 20),

              // Amount
              CustomTextField(
                label: 'Amount',
                hint: '0.00',
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(),
                prefixIcon: getCurrencyIcon(),
              ),

              const SizedBox(height: 20),

              // Currency Row
              Row(
                children: [
                  const Text('Currency'),
                  const SizedBox(width: 16),
                  DropdownButton<String>(
                    value: _selectedCurrency,
                    items: const [
                      'USD',
                      'PKR',
                      'EURO',
                    ].map((c) {
                      return DropdownMenuItem(value: c, child: Text(c));
                    }).toList(),
                    onChanged: (v) => setState(() => _selectedCurrency = v!),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Category
              InkWell(
                onTap: _selectCategory,
                child: Container(
                  padding: const EdgeInsets.all(19),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(19),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    children: [
                      _selectedCategory != null
                          ? Text(_selectedCategory!.icon,
                          style: const TextStyle(fontSize: 24))
                          : const Text("Select category"),
                      const Spacer(),
                      const Icon(Icons.chevron_right),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Date
              InkWell(
                onTap: _selectDate,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today),
                      const SizedBox(width: 12),
                      Text(DateFormat('MMM dd, yyyy').format(_selectedDate)),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Description
              CustomTextField(
                label: 'Description (Optional)',
                hint: 'Add a note',
                controller: _descriptionController,
                maxLines: 3,
                prefixIcon: const Icon(Icons.note),
              ),

              const SizedBox(height: 32),

              // Button
              Consumer<TransactionController>(
                builder: (context, controller, _) => CustomButton(
                  text: 'Add Transaction',
                  isLoading: controller.isLoading,
                  onPressed: _saveTransaction,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Highlighted button
  Widget _buildTypeButton(String label, TransactionType type, Color color) {
    final isSelected = _selectedType == type;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedType = type;
          _selectedCategory = null;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.2) : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? color : Colors.transparent),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? color : Colors.black54,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  // Currency Icons
  Widget getCurrencyIcon() {
    switch (_selectedCurrency) {
      case 'USD':
        return const Icon(Icons.attach_money);
      case 'PKR':
        return const Icon(Icons.currency_rupee); // closest icon
      case 'EURO':
        return const Icon(Icons.euro);
      default:
        return const Icon(Icons.money);
    }
  }
}
