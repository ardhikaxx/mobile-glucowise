import 'package:flutter/material.dart';
import 'package:medical_app/auth/forgot.dart';
import 'package:medical_app/auth/register.dart';
import 'package:medical_app/services/auth_services.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _showPassword = false;
  bool _rememberMe = false;
  late SharedPreferences _preferences;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    _preferences = await SharedPreferences.getInstance();
    setState(() {
      _rememberMe = _preferences.getBool('rememberMe') ?? false;
      if (_rememberMe) {
        _emailController.text = _preferences.getString('email') ?? '';
        _passwordController.text = _preferences.getString('password') ?? '';
      }
    });
  }

  Future<void> _savePreferences() async {
    await _preferences.setBool('rememberMe', _rememberMe);
    if (_rememberMe) {
      await _preferences.setString('email', _emailController.text);
      await _preferences.setString('password', _passwordController.text);
    } else {
      await _preferences.remove('email');
      await _preferences.remove('password');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: -50,
            left: -50,
            child: _buildCircle(200, const Color(0xFFE8F3F1).withOpacity(0.8)),
          ),
          Positioned(
            bottom: 15,
            right: -40,
            child: _buildCircle(135, const Color(0xFFE8F3F1).withOpacity(0.5)),
          ),
          Center(
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset("assets/logo.png", width: 180, height: 180),
                    const Text(
                      "Welcome Back!",
                      style: TextStyle(
                          fontSize: 32,
                          fontFamily: 'DarumadropOne',
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF199A8E)),
                    ),
                    Text(
                      "Please login to your account",
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 15),
                    _buildInputField(
                      controller: _emailController,
                      labelText: "Email",
                      prefixIcon: Icons.email,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 15),
                    _buildInputField(
                      controller: _passwordController,
                      labelText: "Password",
                      prefixIcon: Icons.lock,
                      obscureText: !_showPassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          color: const Color(0xFF199A8E),
                          _showPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _showPassword = !_showPassword;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildRememberMeRow(),
                    const SizedBox(height: 10),
                    _buildLoginButton(),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: TextStyle(
                              color: Colors.black.withOpacity(0.7),
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const RegisterScreen()));
                          },
                          child: const Text("Register",
                              style: TextStyle(
                                  color: Color(0xFF199A8E),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String labelText,
    required IconData prefixIcon,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 3)),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: const TextStyle(fontSize: 16, color: Colors.black),
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFFF9FAFB),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          labelText: labelText,
          labelStyle: const TextStyle(color: Color(0xFF199A8E)),
          prefixIcon: Icon(prefixIcon, color: const Color(0xFF199A8E)),
          suffixIcon: suffixIcon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 2.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
                color: const Color(0xFFE5E7EB).withOpacity(0.5), width: 1.5),
          ),
        ),
      ),
    );
  }

  Widget _buildRememberMeRow() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Checkbox(
                side: const BorderSide(color: Color(0xFF199A8E), width: 1.5),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0)),
                value: _rememberMe,
                onChanged: (value) {
                  setState(() {
                    _rememberMe = value!;
                    _savePreferences();
                  });
                },
                activeColor: const Color(0xFF199A8E),
                checkColor: Colors.white,
              ),
              const Text(
                "Remember me",
                style: TextStyle(
                  color: Color(0xFF199A8E),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ForgotPasswordPage(),
                ),
              );
            },
            child: const Text(
              "Forgot Password?",
              style: TextStyle(
                color: Color(0xFF199A8E),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginButton() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () async {
            String email = _emailController.text;
            String password = _passwordController.text;

            if (email.isEmpty && password.isEmpty) {
              _showQuickAlert(context, "Email dan password tidak boleh kosong",
                  QuickAlertType.error);
              return;
            } else if (email.isEmpty) {
              _showQuickAlert(
                  context, "Email tidak boleh kosong", QuickAlertType.error);
              return;
            } else if (password.isEmpty) {
              _showQuickAlert(
                  context, "Password tidak boleh kosong", QuickAlertType.error);
              return;
            }
            
            await AuthServices.login(context, email, password);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF199A8E),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 5,
          ),
          child: const Text("Login",
              style: TextStyle(fontSize: 18, color: Colors.white)),
        ),
      ),
    );
  }

  void _showQuickAlert(
      BuildContext context, String message, QuickAlertType alertType) {
    QuickAlert.show(
      context: context,
      type: alertType,
      title: 'Pesan',
      text: message,
      confirmBtnText: 'OK',
    );
  }
}
