import 'package:flutter/material.dart';
import '../Providers/SignIn_provider.dart';
import 'signup_screen.dart';
import 'package:provider/provider.dart';

class SignInScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SignInViewModel(),
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        body: Consumer<SignInViewModel>(
          builder: (context, viewModel, child) {
            return SingleChildScrollView(
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
                    const Text(
                      "Welcome,",
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      "Login to continue",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 40),
                    reusableTextField("Email Address", Icons.email_outlined,
                        false, _emailController),
                    const SizedBox(height: 25),
                    reusableTextField("Enter Password", Icons.lock_outline,
                        true, _passwordController),
                    const SizedBox(height: 40),
                    signInSignUpButton(context, true, () {
                      viewModel.signInWithEmail(
                        _emailController.text,
                        _passwordController.text,
                        context,
                      );
                    }),
                    if (viewModel.errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          viewModel.errorMessage!,
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    const SizedBox(height: 10),
                    Center(
                      child: Text(
                        "OR",
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
                    const SizedBox(height: 10),
                    socialLoginButton(
                        'assets/images/facebook_logo.png', 'Facebook Sign in',
                        () {
                      viewModel.signInWithFacebook(context);
                    }),
                    socialLoginButton(
                        'assets/images/Google_logo.png', 'Google Sign in', () {
                      viewModel.signInWithGoogle(context);
                    }),
                    const SizedBox(height: 10),
                    signUpOption(context),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Row signUpOption(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Don't have an account?",
          style: TextStyle(color: Colors.black),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SignUpScreen()),
            );
          },
          child: const Text(
            " Sign Up",
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
  }
}

// Custom reusable text field for email
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

// Sign in button
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
        isLogin ? 'Sign In' : 'Sing Up',
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

// Apple and Google sign-in buttons
Widget socialLoginButton(String assetName, String text, Function onTap) {
  return Container(
    width: double.infinity,
    height: 50,
    margin: const EdgeInsets.symmetric(vertical: 10),
    child: ElevatedButton.icon(
      onPressed: () {
        onTap(); // Trigger the passed function
      },
      icon: Image.asset(
        assetName,
        width: 20,
        height: 20,
      ),
      label: Text(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    ),
  );
}
