import 'package:finance/screens/registration.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:finance/screens/home_base.dart';
import '../widgets/custom_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  String _errorMessage = '';
  bool _isLoggedIn = false;
  int _counter = 0;
  bool _isPasswordVisible = false;

  void _showToast(String message, {bool isError = true}) {
    toastification.show(
      context: context,
      type: isError ? ToastificationType.error : ToastificationType.success,
      style: ToastificationStyle.minimal,
      autoCloseDuration: const Duration(seconds: 2),
      description: Text(
        message,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      backgroundColor: Colors.white,
      primaryColor: isError ? Colors.red : Colors.green,
      alignment: Alignment.topRight,
      direction: TextDirection.ltr,
      borderRadius: BorderRadius.circular(12),
    );
  }

  Future<void> _signIn() async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      if (mounted) {
        _showToast('Амжилттай нэвтэрлээ', isError: false);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeBase()),
        );
      }
    } on FirebaseAuthException catch (e) {
      _showToast(e.message ?? 'Алдаа гарлаа');
    }
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Color(0xFF3E7C78);
    final secondaryColor = Color(0xFF5AB8CD);

    if (_isLoggedIn) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Home'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                setState(() {
                  _isLoggedIn = false;
                  _counter = 0;
                });
                _auth.signOut();
              },
            ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Та энэ товчлуурыг олон удаа дарсан:',
              ),
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _incrementCounter,
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ),
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              primaryColor,
              secondaryColor,
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top +
                  AppBar().preferredSize.height +
                  20,
              left: 24.0,
              right: 24.0,
              bottom: 24.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/login.png',
                  height: 200,
                ),
                const SizedBox(height: 24),
                Text(
                  'Тавтай морилно уу',
                  style: GoogleFonts.caveat(
                    fontSize: 40,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 32),
                // Email Field
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'И-мейл хаяг',
                    labelStyle: const TextStyle(color: Colors.white70),
                    prefixIcon:
                        const Icon(Icons.email_outlined, color: Colors.white70),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.2),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.white30),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                // Password Field
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Нууц үг',
                    labelStyle: const TextStyle(color: Colors.white70),
                    prefixIcon:
                        const Icon(Icons.lock_outline, color: Colors.white70),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.white70,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.2),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.white30),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                  obscureText: !_isPasswordVisible,
                ),
                const SizedBox(height: 24),
                if (_errorMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      _errorMessage,
                      style: TextStyle(
                        color: Colors.red[300],
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: CustomButton(
                    text: 'Нэвтрэх',
                    onPressed: _signIn,
                    backgroundColor: Colors.white,
                    foregroundColor: primaryColor,
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegistrationPage(),
                          ),
                        );
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Бүртгэл үүсээгүй?',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            'Бүртгүүлэх',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
