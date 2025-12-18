import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_controller.dart';
import '../models/user_model.dart';
import '../widgets/custom_text_field.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final auth = Provider.of<AuthController>(context, listen: false);
    final user = auth.currentUser;
    if (user != null) {
      _nameController.text = user.name;
      _emailController.text = user.email;
      _phoneController.text = user.phoneNumber ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = Provider.of<AuthController>(context, listen: false);
    final current = auth.currentUser;
    if (current == null) return;

    final updated = UserModel(
      id: current.id,
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      profileImageUrl: current.profileImageUrl,
      createdAt: current.createdAt,
      phoneNumber: _phoneController.text.trim().isEmpty
          ? null
          : _phoneController.text.trim(),
    );
    await auth.updateProfile(updated);
    if (!mounted) return;
    Navigator.of(context).pop(updated);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextField(
                label: 'Name',
                hint: 'Your name',
                controller: _nameController,
                prefixIcon: const Icon(Icons.person_outline),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Email',
                hint: 'you@example.com',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                prefixIcon: const Icon(Icons.email_outlined),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Phone (optional)',
                hint: '0300-0000000',
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                prefixIcon: const Icon(Icons.phone_outlined),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _save,
                  icon: const Icon(Icons.save_outlined),
                  label: const Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
