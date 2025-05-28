import 'package:flutter/material.dart';
import 'package:flutter_attendence_app/attendancedetails.dart';
import 'package:flutter_attendence_app/cgpa_calculator.dart';
import 'package:flutter_attendence_app/gpa_calculator.dart';
import 'package:flutter_attendence_app/help_page.dart';
import 'package:flutter_attendence_app/homepage.dart';
import 'package:flutter_attendence_app/logo.dart';
import 'package:flutter_attendence_app/loginpage.dart';
import 'package:flutter_attendence_app/attendance.dart';
import 'package:flutter_attendence_app/profile_page.dart';
import 'package:flutter_attendence_app/timetable_page.dart';
import 'package:flutter_attendence_app/attendancemark.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // Initialize the NotificationService
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Attendance App',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/logopage', // Ensure this route exists
      routes: {
        '/logopage': (context) => const LogoPage(),
        '/loginpage': (context) => const LoginPage(),
        '/homepage':
            (context) => const HomePage(
              name: 'Default Name',
              email: 'default@example.com',
              profile: {
                'key': 'Default Profile',
              }, // Provide a default or dynamic value
            ),
        '/attendancepage': (context) => const AttendanceSelectionPage(),
        '/attendancemark': (context) => const AttendanceScreen(),
        '/attendancedetails':
            (context) => AttendanceDetailsScreen(
              department:
                  'Default Department', // Provide a default or dynamic value
              year: 'Default Year', // Provide a default or dynamic value
              section: 'Default Section', // Provide a default or dynamic value
              presentStudents: [],
              absentStudents: [],
              onDutyStudents: [],
              onEdit: (Map<String, bool> updatedAttendance) {
                // Add your onEdit logic here
                print(updatedAttendance);
              },
            ),
        '/cgpaCalculator': (context) => const CgpaCalculatorPage(),
        '/profilepage': (context) => const ProfilePage(),
        '/gpaCalculator': (context) => const GPACalculatorPage(),
        '/help': (context) => const HelpPage(),
        '/timetablepage': (context) => TimetablePage(),
      },
    );
  }
}
