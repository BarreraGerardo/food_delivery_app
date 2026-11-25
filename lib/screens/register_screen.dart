import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/loading_dialog.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _closeLoadingDialog() {
    if (!mounted) return;
    final navigator = Navigator.of(context, rootNavigator: true);
    if (navigator.canPop()) {
      navigator.pop();
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _registerUser() async {
    if (_isSubmitting) return;

    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      _showMessage('Completa nombre, correo y contraseña.');
      return;
    }

    if (password.length < 6) {
      _showMessage('La contraseña debe tener al menos 6 caracteres.');
      return;
    }

    if (password != confirmPassword) {
      _showMessage('Las contraseñas no coinciden.');
      return;
    }

    setState(() => _isSubmitting = true);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const LoadingDialog(message: 'Creando cuenta'),
    );

    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: email,
            password: password,
          )
          .timeout(const Duration(seconds: 6));

      final user = credential.user;
      if (user != null) {
        unawaited(user.updateDisplayName(name).catchError((_) {}));
        unawaited(
          FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .set({
                'uid': user.uid,
                'name': name,
                'email': email,
                'role': 'customer',
                'createdAt': FieldValue.serverTimestamp(),
              })
              .timeout(const Duration(seconds: 3))
              .catchError((_) {}),
        );
      }

      _closeLoadingDialog();
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      _closeLoadingDialog();
      String errorText = 'Error al registrar (${e.code})';
      if (e.code == 'email-already-in-use') {
        errorText = 'Ese correo ya está registrado. Intenta con otro.';
      } else if (e.code == 'invalid-email') {
        errorText = 'El formato del correo no es válido.';
      } else if (e.code == 'weak-password') {
        errorText = 'La contraseña es muy débil.';
      } else if (e.code == 'network-request-failed') {
        errorText = 'Sin conexión a internet en el emulador.';
      }
      _showMessage(errorText);
    } on TimeoutException {
      _closeLoadingDialog();
      _showMessage('Firebase tardó en responder. Revisa la red del emulador.');
    } catch (e) {
      _closeLoadingDialog();
      _showMessage('Error: $e');
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro de Usuario'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Icon(
              Icons.fastfood,
              size: 76,
              color: Theme.of(context).colorScheme.secondary,
            ),
            const SizedBox(height: 24),
            CustomTextField(
              controller: _nameController,
              data: Icons.person,
              hintText: 'Nombre completo',
              isObsecure: false,
            ),
            const SizedBox(height: 14),
            CustomTextField(
              controller: _emailController,
              data: Icons.email,
              hintText: 'Correo electrónico',
              isObsecure: false,
            ),
            const SizedBox(height: 14),
            CustomTextField(
              controller: _passwordController,
              data: Icons.lock,
              hintText: 'Contraseña',
              isObsecure: true,
            ),
            const SizedBox(height: 14),
            CustomTextField(
              controller: _confirmPasswordController,
              data: Icons.lock_outline,
              hintText: 'Confirmar contraseña',
              isObsecure: true,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _registerUser,
                child: const Text('Registrarse'),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
              child: const Text('Continuar como invitado'),
            ),
          ],
        ),
      ),
    );
  }
}