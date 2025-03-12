import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();

  Future<void> _resetPassword(BuildContext context) async {
    // Unfocus text fields to dismiss the keyboard
    _emailFocusNode.unfocus();

    try {
      // Show a loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text.trim(),
      );

      // Close the loading dialog and show success message
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password reset email sent. Check your inbox.')),
      );

      // Navigate back to the login screen
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      Navigator.of(context).pop(); // Close the loading dialog
      if (e.code == 'network-request-failed') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('A network error occurred. Please check your connection.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'Failed to send password reset email.')),
        );
      }
    } catch (e) {
      Navigator.of(context).pop(); // Close the loading dialog
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An unexpected error occurred.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo or Image
              Image.asset(
                'assets/logo.png', // Ensure the image is in the assets folder
                height: 200,
              ),
              const SizedBox(height: 20),

              // Email TextField
              TextField(
                controller: _emailController,
                focusNode: _emailFocusNode,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _resetPassword(context),
              ),
              const SizedBox(height: 20),

              // Reset Password Button
              ElevatedButton(
                onPressed: () => _resetPassword(context),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Reset Password'),
              ),
              const SizedBox(height: 10),

              // Back to Login Button
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Back to Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}