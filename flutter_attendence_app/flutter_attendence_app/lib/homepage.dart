import 'package:flutter/material.dart';
import 'package:flutter_attendence_app/help_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatelessWidget {
  final String name;
  final String email;
  final Map<String, dynamic> profile;

  const HomePage({super.key, required this.name, required this.email, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8), // Subtle light background
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF1A73E8), // Professional blue
        title: const Text(
          'Student Dashboard',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section
            AnimatedHeader(name: name),

            // Main Content Section
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: CategoryCard(
                          title: 'Attendance',
                          icon: Icons.check_circle_outline,
                          gradient: const LinearGradient(
                            colors: [Color(0xFF34A853), Color(0xFF81C784)],
                          ),
                          onTap: () {
                            Navigator.pushNamed(context, '/attendancepage');
                          },
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: CategoryCard(
                          title: 'Time Table',
                          icon: Icons.schedule,
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFFA000), Color(0xFFFFC107)],
                          ),
                          onTap: () {
                            Navigator.pushNamed(context, '/timetablepage');
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: CategoryCard(
                          title: 'Result',
                          icon: Icons.school,
                          gradient: const LinearGradient(
                            colors: [Color(0xFF1976D2), Color(0xFF64B5F6)],
                          ),
                          onTap: () async {
                            const url = 'https://coe.act.edu.in/students/';
                            if (await canLaunch(url)) {
                              await launch(url);
                            } else {
                              throw 'Could not launch $url';
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: CategoryCard(
                          title: 'Profile',
                          icon: Icons.person_outline,
                          gradient: const LinearGradient(
                            colors: [Color(0xFF009688), Color(0xFF4DB6AC)],
                          ),
                          onTap: () {
                            Navigator.pushNamed(context, '/profilepage');
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: CategoryCard(
                          title: 'CGPA Calculator',
                          icon: Icons.calculate,
                          gradient: const LinearGradient(
                            colors: [Color(0xFF8E24AA), Color(0xFFBA68C8)],
                          ),
                          onTap: () {
                            Navigator.pushNamed(context, '/cgpaCalculator');
                          },
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: CategoryCard(
                          title: 'GPA Calculator',
                          icon: Icons.calculate_outlined,
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFFA726), Color(0xFFFF7043)],
                          ),
                          onTap: () {
                            Navigator.pushNamed(context, '/gpaCalculator');
                          },
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HelpPage()),
          );
        },
        backgroundColor: const Color(0xFF1A73E8),
        child: const Icon(Icons.help_outline),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF1A73E8),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == 0) {
            // Home
          } else if (index == 1) {
            // Notifications
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UserDetailsPage(name: name, email: email),
              ),
            ); // Navigate to User Details Page
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person), // Changed to User Icon
            label: 'User',
          ),
        ],
      ),
    );
  }
}

class AnimatedHeader extends StatelessWidget {
  final String name;

  const AnimatedHeader({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1A73E8), Color(0xFF4285F4)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hello, $name!',
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
          const SizedBox(height: 5),
          Text(
            'Welcome to your dashboard',
            style: const TextStyle(fontSize: 14, color: Colors.white70),
          ),
          const SizedBox(height: 10),
          const Text(
            '"Education is the most powerful weapon which you can use to change the world."',
            style: TextStyle(
              fontSize: 14,
              fontStyle: FontStyle.italic,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final LinearGradient gradient;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.title,
    required this.icon,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        height: 120,
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.white.withOpacity(0.8),
              child: Icon(icon, size: 30, color: Colors.black87),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UserDetailsPage extends StatelessWidget {
  final String name;
  final String email;

  const UserDetailsPage({super.key, required this.name, required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Details'),
        backgroundColor: const Color(0xFF1A73E8),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // User Avatar
            CircleAvatar(
              radius: 50,
              backgroundColor: const Color(0xFF1A73E8),
              child: const Icon(Icons.person, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 20),

            // User Details Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'User Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A73E8),
                      ),
                    ),
                    const Divider(color: Colors.grey),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.person, color: Color(0xFF1A73E8)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Name: $name',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        const Icon(Icons.email, color: Color(0xFF1A73E8)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Email: $email',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),

            // Logout Button
            ElevatedButton.icon(
              onPressed: () async {
                // Clear SharedPreferences
                final prefs = await SharedPreferences.getInstance();
                await prefs.clear();

                // Navigate to the login page and clear the navigation stack
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/loginpage',
                  (Route<dynamic> route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A73E8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 50,
                  vertical: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              icon: const Icon(Icons.logout, color: Colors.white),
              label: const Text(
                'Logout',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
