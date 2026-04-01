import 'package:flutter/material.dart';

class InscriptionPage extends StatelessWidget {
  const InscriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inscription')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ValidationDemo(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Retour'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ValidationDemo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ValidationDemoState();
  }
}

class ValidationDemoState extends State<ValidationDemo> {
  final _formKey = GlobalKey<FormState>();
  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15.0),
      child: Form(
        key: _formKey,
        child: formUI(),
      ),
    );
  }

  Widget formUI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        TextFormField(
          decoration: const InputDecoration(labelText: 'Nom/Surnom'),
          validator: _validateUsername,
        ),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Email'),
          validator: _validateEmail,
          keyboardType: TextInputType.emailAddress,
        ),
        TextFormField(
          keyboardType: TextInputType.text,
          validator: _validatePassword,
          obscureText: !isPasswordVisible,
          decoration: InputDecoration(
            labelText: 'Mot de passe',
            hintText: 'Entrez un mot de passe',
            suffixIcon: IconButton(
              icon: Icon(
                isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                color: Theme.of(context).primaryColorDark,
              ),
              onPressed: () {
                setState(() {
                  isPasswordVisible = !isPasswordVisible;
                });
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Processing data')),
                );
                Navigator.of(context).pushNamedAndRemoveUntil('/general', (Route route) => false);
              }
            },
            child: const Text('S\'inscrire'),
          ),
        ),
      ],
    );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email field cannot be empty!';
    }
    String p = "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}"
        "\\@"
        "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}"
        "("
        "\\."
        "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}"
        ")+";
    RegExp regExp = RegExp(p);
    if (regExp.hasMatch(value)) {
      return null;
    }
    return 'Email provided isn\'t valid. Try another email address';
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password field cannot be empty';
    }
    if (value.length < 6) {
      return 'Password length must be greater than 6';
    }
    return null;
  }

  String? _validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username cannot be empty';
    }
    if (value.length < 6) {
      return 'Username length must be greater than 6';
    }
    return null;
  }
}