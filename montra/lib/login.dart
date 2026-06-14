
import 'package:flutter/material.dart';
import 'package:montra/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:montra/sign_in.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool _obscurePassword = true;

  final Color darkGreen = const Color(0xff0B3D2E);

  final TextEditingController _usernameController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  String? usernameError;
  String? passwordError;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> validateAndLogin() async {
  setState(() {
    usernameError = _usernameController.text.trim().isEmpty
        ? 'Username is required'
        : null;

    passwordError = _passwordController.text.trim().isEmpty
        ? 'Password is required'
        : null;
  });

  if (usernameError != null ||
      passwordError != null) {
    return;
  }

  final prefs = await SharedPreferences.getInstance();

  List<String> usernames =
      prefs.getStringList('usernames') ?? [];

  List<String> passwords =
      prefs.getStringList('passwords') ?? [];

  bool loginSuccess = false;

  for (int i = 0;
      i < usernames.length;
      i++) {
    if (usernames[i] ==
            _usernameController.text.trim() &&
        passwords[i] ==
            _passwordController.text.trim()) {
      loginSuccess = true;
      break;
    }
  }

  if (loginSuccess) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => Myhome(
          username:
              _usernameController.text.trim(),
        ),
      ),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Invalid Username or Password',
        ),
      ),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F111A),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              const SizedBox(height: 40),

              Container(
                padding: const EdgeInsets.all(24.0),

                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 50, 47, 45),

                  borderRadius: BorderRadius.circular(20),

                  border: Border.all(color: darkGreen),
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,

                  children: [
                    const Text(
                      'LOGIN',

                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 32),

                    const Padding(
                      padding: EdgeInsets.only(bottom: 8),

                      child: Text(
                        'Username',

                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    TextField(
                      controller: _usernameController,

                      style: const TextStyle(color: Colors.white),

                      decoration: InputDecoration(
                        hintText: 'Enter your username',

                        errorText: usernameError,

                        hintStyle: const TextStyle(color: Colors.grey),

                        prefixIcon: const Icon(
                          Icons.person_outline,
                          color: Colors.grey,
                        ),

                        filled: true,

                        fillColor: const Color(0xFF0F111A),

                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 18,
                          horizontal: 16,
                        ),

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),

                          borderSide: BorderSide(color: darkGreen),
                        ),

                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),

                          borderSide: BorderSide(color: darkGreen),
                        ),

                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),

                          borderSide: BorderSide(color: darkGreen, width: 2),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    const Padding(
                      padding: EdgeInsets.only(bottom: 8),

                      child: Text(
                        'Password',

                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    TextField(
                      controller: _passwordController,

                      obscureText: _obscurePassword,

                      style: const TextStyle(color: Colors.white),

                      decoration: InputDecoration(
                        hintText: 'Enter your password',

                        errorText: passwordError,

                        hintStyle: const TextStyle(color: Colors.grey),

                        prefixIcon: const Icon(
                          Icons.lock_outline,
                          color: Colors.grey,
                        ),

                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,

                            color: Colors.grey,
                          ),

                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),

                        filled: true,

                        fillColor: const Color(0xFF0F111A),

                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 18,
                          horizontal: 16,
                        ),

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),

                          borderSide: BorderSide(color: darkGreen),
                        ),

                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),

                          borderSide: BorderSide(color: darkGreen),
                        ),

                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),

                          borderSide: BorderSide(color: darkGreen, width: 2),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    ElevatedButton(
                      onPressed: validateAndLogin,

                      style: ElevatedButton.styleFrom(
                        backgroundColor: darkGreen,

                        padding: const EdgeInsets.symmetric(vertical: 16),

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),

                      child: const Text(
                        'LOGIN',

                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: [
                        const Text(
                          "Don't have an account? ",

                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),

                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,

                              MaterialPageRoute<void>(
                                builder: (context) => const CreateAccountPage(),
                              ),
                            );
                          },

                          child: const Text(
                            'Signup',

                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 