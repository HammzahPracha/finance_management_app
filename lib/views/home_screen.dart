import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_controller.dart';
import '../controllers/transaction_controller.dart';
import 'dashboard_screen.dart';
import 'profile_screen.dart';
import 'add_transaction_screen.dart';
import 'income_screen.dart';
import 'expense_screen.dart';
import 'budget_planning_screen.dart';
import '../controllers/theme_controller.dart';
import 'settings_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = context.watch<AuthController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blue.shade200,
              child: Text(
                authController.currentUser?.name[0] ?? "User name",
                style: const TextStyle(fontSize: 40, color: Colors.white),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              authController.currentUser?.name ?? "User Name",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              authController.currentUser?.email ?? "email@example.com",
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 32),

            // Optional: A Settings tile inside the profile
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Settings"),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 2;

  final List<Widget> _screens = [
     IncomeScreen(),
     ExpenseScreen(),
     DashboardScreen(),
     BudgetPlanningScreen(),
     ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final authController = Provider.of<AuthController>(context, listen: false);
    final transactionController = Provider.of<TransactionController>(context, listen: false);

    if (authController.currentUser != null) {
      await transactionController.loadTransactions(authController.currentUser!.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget screen;

    switch (_currentIndex) {
      case 0:
        screen = const IncomeScreen();
        break;
      case 1:
        screen = const ExpenseScreen();
        break;
      case 2:
        screen = const DashboardScreen();
        break;
      case 3:
        screen = const BudgetPlanningScreen();
        break;
      case 4:
        screen = ProfileScreen(); // no const
        break;
      default:
        screen = const DashboardScreen();
    }

    return Scaffold(
      body: screen,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.trending_up_outlined),
            selectedIcon: Icon(Icons.trending_up),
            label: 'Income',
          ),
          NavigationDestination(
            icon: Icon(Icons.trending_down_outlined),
            selectedIcon: Icon(Icons.trending_down),
            label: 'Expense',
          ),
          NavigationDestination(
            icon: Icon(Icons.analytics_outlined),
            selectedIcon: Icon(Icons.analytics),
            label: 'Analysis',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_balance_wallet_outlined),
            selectedIcon: Icon(Icons.account_balance_wallet),
            label: 'Budget',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const AddTransactionScreen()),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Add'),
      ),
    );
  }
}

