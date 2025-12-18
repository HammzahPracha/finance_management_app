import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_controller.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [

              // NAME
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Name",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter your name";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // EMAIL
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter your email";
                  }
                  if (!value.contains("@")) {
                    return "Enter valid email";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // PASSWORD
              TextFormField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  labelText: "Password",
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter password";
                  }
                  if (value.length < 6) {
                    return "Minimum 6 characters";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // BUTTON
              ElevatedButton(
                onPressed: authController.isLoading
                    ? null
                    : () async {
                  if (_formKey.currentState!.validate()) {
                    final success = await authController.register(
                      _nameController.text.trim(),
                      _emailController.text.trim(),
                      _passwordController.text.trim(),
                    );

                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Registered Successfully")),
                      );
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(authController.errorMessage ?? "Error")),
                      );
                    }
                  }
                },
                child: authController.isLoading
                    ? const CircularProgressIndicator()
                    : const Text("Register"),
              ),

              const SizedBox(height: 10),

              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Already have an account? Login"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
