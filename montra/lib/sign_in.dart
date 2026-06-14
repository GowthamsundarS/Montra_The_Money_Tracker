import 'package:flutter/material.dart';
import 'package:montra/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  bool _obscurePassword = true;

  final Color darkGreen = const Color(0xff0B3D2E);

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _usernameController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _dobController = TextEditingController();

  String? emailError;
  String? usernameError;
  String? passwordError;
  String? dobError;

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      String formattedDate =
          "${pickedDate.month.toString().padLeft(2, '0')}/"
          "${pickedDate.day.toString().padLeft(2, '0')}/"
          "${pickedDate.year}";

      setState(() {
        _dobController.text = formattedDate;
      });
    }
  }

Future<void> validateAndCreateAccount() async {
  setState(() {
    emailError = _emailController.text.trim().isEmpty
        ? 'Email is required'
        : null;

    usernameError = _usernameController.text.trim().isEmpty
        ? 'Username is required'
        : null;

    passwordError = _passwordController.text.trim().isEmpty
        ? 'Password is required'
        : null;

    dobError = _dobController.text.trim().isEmpty
        ? 'Date of birth is required'
        : null;
  });

  if (emailError == null &&
      usernameError == null &&
      passwordError == null &&
      dobError == null) {
    final prefs = await SharedPreferences.getInstance();

    List<String> usernames =
        prefs.getStringList('usernames') ?? [];

    List<String> passwords =
        prefs.getStringList('passwords') ?? [];

    List<String> emails =
        prefs.getStringList('emails') ?? [];

    List<String> dobs =
        prefs.getStringList('dobs') ?? [];

    if (usernames.contains(
      _usernameController.text.trim(),
    )) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Username already exists',
          ),
        ),
      );
      return;
    }

    usernames.add(
      _usernameController.text.trim(),
    );

    passwords.add(
      _passwordController.text.trim(),
    );

    emails.add(
      _emailController.text.trim(),
    );

    dobs.add(
      _dobController.text.trim(),
    );

    await prefs.setStringList(
      'usernames',
      usernames,
    );

    await prefs.setStringList(
      'passwords',
      passwords,
    );

    await prefs.setStringList(
      'emails',
      emails,
    );

    await prefs.setStringList(
      'dobs',
      dobs,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Account Created Successfully',
        ),
      ),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            const SignInPage(),
      ),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F111A),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,

        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },

          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),

        child: Column(
          children: [
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
                    'Create Account',

                    textAlign: TextAlign.center,

                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 32),

                 
                  const Padding(
                    padding: EdgeInsets.only(bottom: 8),

                    child: Text(
                      'Email',

                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  
                  TextField(
                    controller: _emailController,

                    style: const TextStyle(color: Colors.white),

                    decoration: InputDecoration(
                      hintText: 'Enter your email',

                      errorText: emailError,

                      hintStyle: const TextStyle(color: Colors.grey),

                      prefixIcon: const Icon(
                        Icons.mail_outline,
                        color: Colors.grey,
                      ),

                      filled: true,

                      fillColor: const Color(0xFF0F111A),

                      contentPadding: const EdgeInsets.symmetric(vertical: 18),

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

                  const SizedBox(height: 20),

                  // USERNAME LABEL
                  const Padding(
                    padding: EdgeInsets.only(bottom: 8),

                    child: Text(
                      'Username',

                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
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

                      contentPadding: const EdgeInsets.symmetric(vertical: 18),

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

                  const SizedBox(height: 20),

                  
                  const Padding(
                    padding: EdgeInsets.only(bottom: 8),

                    child: Text(
                      'Password',

                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
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

                      contentPadding: const EdgeInsets.symmetric(vertical: 18),

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

                  const SizedBox(height: 20),

                 
                  const Padding(
                    padding: EdgeInsets.only(bottom: 8),

                    child: Text(
                      'Date of Birth (DOB)',

                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),

                 
                  TextField(
                    controller: _dobController,

                    readOnly: true,

                    onTap: _selectDate,

                    style: const TextStyle(color: Colors.white),

                    decoration: InputDecoration(
                      hintText: 'mm/dd/yyyy',

                      errorText: dobError,

                      hintStyle: const TextStyle(color: Colors.grey),

                      prefixIcon: const Icon(
                        Icons.calendar_today_outlined,
                        color: Colors.grey,
                      ),

                      suffixIcon: IconButton(
                        onPressed: _selectDate,
                        icon: const Icon(
                          Icons.calendar_month_outlined,
                          color: Colors.grey,
                        ),
                      ),

                      filled: true,

                      fillColor: const Color(0xFF0F111A),

                      contentPadding: const EdgeInsets.symmetric(vertical: 18),

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
                    onPressed: validateAndCreateAccount,

                    style: ElevatedButton.styleFrom(
                      backgroundColor: darkGreen,

                      padding: const EdgeInsets.symmetric(vertical: 16),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),

                    child: const Text(
                      'Create Account',

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
                        'Already have an account? ',

                        style: TextStyle(color: Colors.grey, fontSize: 13),
                      ),

                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,

                            MaterialPageRoute(
                              builder: (context) => const SignInPage(),
                            ),
                          );
                        },

                        child: const Text(
                          'Login',

                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 13,
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
    );
  }
}  