import 'package:flutter/material.dart';
import 'package:inhouse/Screens/Dashboard.dart';
import 'package:provider/provider.dart';
import '../Providers/SignIn_provider.dart';
import 'Signin_screen.dart';

// Reusable text field widget with the new color scheme
Widget reusableTextField(String hintText, IconData icon, bool isPasswordType,
    TextEditingController controller) {
  return TextField(
    controller: controller,
    obscureText: isPasswordType,
    enableSuggestions: !isPasswordType,
    autocorrect: !isPasswordType,
    cursorColor: Colors.black,
    style: TextStyle(color: Colors.black.withOpacity(0.9)),
    decoration: InputDecoration(
      prefixIcon: Icon(
        icon,
        color: Colors.black54,
      ),
      labelText: hintText,
      labelStyle: TextStyle(color: Colors.black.withOpacity(0.6)),
      filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      fillColor: Colors.grey[200],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(width: 0, style: BorderStyle.none),
      ),
    ),
    keyboardType: isPasswordType
        ? TextInputType.visiblePassword
        : TextInputType.emailAddress,
  );
}

Container signInSignUpButton(
    BuildContext context, bool isLogin, Function onTap) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 50,
    margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(90),
    ),
    child: ElevatedButton(
      onPressed: () {
        onTap();
      },
      child: Text(
        isLogin ? 'LOG IN' : 'Sing Up',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.pressed)) {
            return Colors.black26;
          }
          return Colors.black;
        }),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    ),
  );
}

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // Controllers for the text fields
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SignInViewModel(),
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        body: Consumer<SignInViewModel>(
          builder: (context, viewModel, child) {
            return Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                      20, MediaQuery.of(context).size.height * 0.12, 25, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 80,
                        width: 120,
                        child: Image.asset('assets/images/healthcare_logo.png'),
                      ),
                      const SizedBox(height: 0),
                      const Text(
                        "Welcome,",
                        style: TextStyle(
                            fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        "Sign up to continue",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      const SizedBox(height: 40),
                      reusableTextField("Enter Email", Icons.email_outlined,
                          false, _emailTextController),
                      const SizedBox(height: 20),
                      reusableTextField("Enter Password", Icons.lock_outline,
                          true, _passwordTextController),
                      const SizedBox(height: 20),
                      if (viewModel.errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            viewModel.errorMessage!,
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      const SizedBox(height: 10),
                      signInSignUpButton(context, false, () {
                        viewModel.signUpWithEmail(
                          _emailTextController.text.trim(),
                          _passwordTextController.text.trim(),
                        );

                        // Check for any error messages after the sign-up attempt
                        if (viewModel.errorMessage == null) {
                          // Show a success dialog
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Sign Up Successful'),
                                content:
                                    Text('You have signed up successfully!'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(); // Close the dialog
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Dashboard()),
                                      );
                                    },
                                    child: Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      }),
                      signInOption(context),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Row signInOption(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Already have an account?",
          style: TextStyle(color: Colors.black),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SignInScreen()),
            );
          },
          child: const Text(
            " Sign In",
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _emailTextController.dispose();
    _passwordTextController.dispose();
  }
}
