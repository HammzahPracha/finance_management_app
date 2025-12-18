import 'package:flutter/material.dart';

class LanguageSettings extends StatelessWidget {
  final String currentLanguage;
  const LanguageSettings({super.key, required this.currentLanguage});

  @override
  Widget build(BuildContext context) {
    // List of available languages
    final languages = ["English", "Urdu", "Spanish", "French", "German"];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Language"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.builder(
        itemCount: languages.length,
        itemBuilder: (context, index) {
          final language = languages[index];
          final isSelected = language == currentLanguage;

          return ListTile(
            title: Text(language),
            trailing: isSelected ? const Icon(Icons.check, color: Colors.green) : null,
            onTap: () {
              // Return the selected language back to SettingsScreen
              Navigator.pop(context, language);
            },
          );
        },
      ),
    );
  }
}
