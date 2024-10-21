import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'Signin_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

final storage = FlutterSecureStorage();

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  // Check if user is logged in by checking the stored session
  Future<void> checkLoginStatus() async {
    String? user = await storage.read(key: "user");
    setState(() {
      isLoggedIn = user != null;
    });
  }

  // Handle login button press and navigate to sign-in page
  void handleLogin() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignInScreen()),
    );

    // If the user successfully logs in, store session info
    if (result != null && result == "loggedIn") {
      await storage.write(key: "user", value: "loggedIn");
      setState(() {
        isLoggedIn = true;
      });
    }
  }

  // Handle logout, clear session, and update UI
  Future<void> handleLogout() async {
    await FirebaseAuth.instance.signOut();
    await storage.delete(key: "user");
    setState(() {
      isLoggedIn = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: EdgeInsets.fromLTRB(
            20, MediaQuery.of(context).size.height * 0.10, 25, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Center(
              child: Image.asset(
                'assets/images/healthcare_logo.png',
                height: 120,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Welcome to Patient-Doctor App",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Your one-stop solution for managing health appointments.",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black.withOpacity(0.6),
              ),
            ),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: isLoggedIn ? handleLogout : handleLogin,
                child: Text(isLoggedIn ? "Sign Out" : "Log In"),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }
}
