import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:shared_preferences/shared_preferences.dart';
import 'homepage.dart';
import 'changepassword.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';
  bool _isPasswordVisible = false; // To toggle password visibility
  mongo.Db? _db; // Reusable MongoDB connection

  // MongoDB connection details
  final String mongoUri =
      "mongodb+srv://digioptimized:digi123@cluster0.iuajg.mongodb.net/attendance_DB";
  final String collectionName = "profile";

  @override
  void initState() {
    super.initState();
    _initializeDatabase(); // Initialize the MongoDB connection
    _checkLoginStatus(); // Check if the user is already logged in
  }

  @override
  void dispose() {
    _db?.close(); // Close the database connection when the widget is disposed
    super.dispose();
  }

  Future<void> _initializeDatabase() async {
    try {
      print('Connecting to MongoDB...');
      _db = await mongo.Db.create(mongoUri);
      await _db!.open();
      print('Connected to MongoDB successfully.');
    } catch (e) {
      print('Failed to connect to MongoDB: $e');
    }
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');
    final name = prefs.getString('name');

    if (email != null && name != null) {
      // If email and name exist in SharedPreferences, navigate to HomePage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(name: name, email: email, profile: {}),
        ),
      );
    }
  }

  void _login() async {
    setState(() {
      _errorMessage = '';
    });

    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isNotEmpty && password.isNotEmpty) {
      try {
        final collection = _db!.collection(collectionName);

        // Query MongoDB for the user
        print('Email: $email');
        print('Password: $password');
        final user = await collection.findOne({
          "College Email ": {
            "\$regex": "^$email\$",
            "\$options": "i",
          }, // Case-insensitive email
          "Password": password, // Compare password as a string
        });
        print('User found: $user');

        if (user != null) {
          // Check if the user has already changed their password
          if (user["isPasswordChanged"] == true) {
            // Save email and name in SharedPreferences
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString('email', email);
            await prefs.setString('name', user["Name"]);

            // Navigate to HomePage
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder:
                    (context) => HomePage(
                      name: user["Name"],
                      email: user["College Email "],
                      profile: user, // Pass the required 'profile' argument
                    ),
              ),
            );
          } else {
            // Navigate to ChangePasswordPage for first-time login
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder:
                    (context) => ChangePasswordPage(email: email, db: _db!),
              ),
            );
          }
        } else {
          setState(() {
            _errorMessage =
                'Invalid credentials. Please check your email and password.';
          });
        }
      } catch (e) {
        setState(() {
          _errorMessage = 'Failed to connect to the database.';
        });
        print('Error: $e'); // Debug: Log the error
      }
    } else {
      setState(() {
        _errorMessage = 'Please fill in all fields.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFD194), Color(0xFF70E1F5)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'Welcome Back!',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Login to continue',
                    style: TextStyle(fontSize: 18, color: Colors.white70),
                  ),
                  const SizedBox(height: 40),
                  _buildTextField(
                    controller: _emailController,
                    hintText: 'College Email',
                    icon: Icons.email_outlined,
                  ),
                  const SizedBox(height: 20),
                  _buildPasswordField(), // Password field with eye icon
                  const SizedBox(height: 10),
                  if (_errorMessage.isNotEmpty)
                    Text(
                      _errorMessage,
                      style: const TextStyle(color: Colors.red),
                    ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 190, 166, 7),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 15,
                      ),
                      textStyle: const TextStyle(fontSize: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text('Login'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool obscureText = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 15,
          ),
          prefixIcon: Icon(icon, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: _passwordController,
        obscureText: !_isPasswordVisible, // Toggle password visibility
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Password',
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 15,
          ),
          prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
          suffixIcon: IconButton(
            icon: Icon(
              _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              color: Colors.grey,
            ),
            onPressed: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
          ),
        ),
      ),
    );
  }
}
