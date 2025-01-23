import 'package:flutter/material.dart';
import 'profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phonenoController = TextEditingController();

  bool _isPasswordVisible1 = false;
  bool _isPasswordVisible2 = false;
  // Method to toggle password visibility
  void _togglePasswordVisibility1() {
    setState(() {
      _isPasswordVisible1 = !_isPasswordVisible1;
    });
  }

  void _togglePasswordVisibility2() {
    setState(() {
      _isPasswordVisible2 = !_isPasswordVisible2;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 252, 243),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.undo),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: 350,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Let's get started",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 50,
                      height:
                          1.2, // Adjust this value to increase or decrease line spacing
                    ),
                  ),
                  SizedBox(height: 40),
                  Container(
                    height: 50,
                    child: Opacity(
                      opacity: 0.3,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.mail),
                            hintText: 'Email',
                            border: InputBorder.none,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            bool emailValid = RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&’*+/=?^_‘{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(value);
                            if (!emailValid) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    height: 50,
                    child: Opacity(
                      opacity: 0.3,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextFormField(
                          controller: _passwordController,
                          obscureText: !_isPasswordVisible1,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock),
                            hintText: 'Password',
                            border: InputBorder.none,
                            suffixIcon: GestureDetector(
                              onTap: () {
                                _togglePasswordVisibility1();
                              },
                              child: Icon(_isPasswordVisible1
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a password';
                            }
                            if (value.length < 8) {
                              return 'Password must be at least 8 characters';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    height: 50,
                    child: Stack(
                      alignment: Alignment.centerRight,
                      children: [
                        Opacity(
                          opacity: 0.3,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: TextFormField(
                              controller: _confirmPasswordController,
                              obscureText: !_isPasswordVisible2,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.lock),
                                hintText: 'Confirm Password',
                                border: InputBorder.none,
                                suffixIcon: GestureDetector(
                                  onTap: _togglePasswordVisibility2,
                                  child: Icon(_isPasswordVisible2
                                      ? Icons.visibility
                                      : Icons.visibility_off),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a confirm password';
                                }
                                if (value.length < 8) {
                                  return 'Password must be at least 8 characters';
                                }
                                if (value != _passwordController.text) {
                                  return 'Passwords do not match';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        if (_formKey.currentState?.validate() ?? false)
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Icon(
                              Icons.error_outline,
                              color: Colors.red,
                            ),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(height: 25),
                  Container(
                    height: 50,
                    child: Opacity(
                      opacity: 0.3,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextFormField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.person),
                            hintText: 'Username',
                            border: InputBorder.none,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your username';
                            }

                            if (value.length < 5) {
                              return 'Username must be at least 5 characters';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    height: 50,
                    child: Opacity(
                      opacity: 0.3,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextFormField(
                          controller: _phonenoController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.call),
                            hintText: 'Phone no.',
                            border: InputBorder.none,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your phone number';
                            }

                            if (value.length < 10) {
                              return 'phone number must be at least 10 characters';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    height: 50,
                    width: 350,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          if (_passwordController.text ==
                              _confirmPasswordController.text) {
                            try {
                              // Register the user with Firebase Authentication
                              UserCredential userCredential = await FirebaseAuth
                                  .instance
                                  .createUserWithEmailAndPassword(
                                email: _emailController.text,
                                password: _passwordController.text,
                              );

                              // Store user information in Firestore
                              await FirebaseFirestore.instance
                                  .collection('User')
                                  .doc(userCredential.user!.uid)
                                  .set({
                                'email': _emailController.text,
                                'username': _usernameController.text,
                                'phoneNumber': _phonenoController.text,
                                'password': _passwordController.text,
                                'location': GeoPoint(0, 0), // Set initial location to (0,0)
                              });

                              // Show registration success message
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Register Successful',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                  backgroundColor: Colors.green,
                                  duration: Duration(seconds: 2),
                                ),
                              );

                              // Navigate to login screen
                              Navigator.pushNamed(context, '/login');
                            } catch (e) {
                              // Show error message if registration fails
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('$e'),
                                  backgroundColor: Colors.red,
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            }
                          } else {
                            // Passwords don't match, display an error message
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Passwords do not match'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        }
                      },
                      child: Text(
                        'Register',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: Text(
                      'or continue with',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  SizedBox(height: 20),
                  Column(
                    children: [
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/google.png',
                                width: 20,
                                height: 20,
                              ),
                              SizedBox(width: 10),
                              Text('Continue with Google'),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/apple.png',
                                width: 20,
                                height: 20,
                              ),
                              SizedBox(width: 10),
                              Text('Continue with Apple'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account?",
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(width: 5),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/login');
                        },
                        child: Text(
                          "Sign in",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PasswordVisibilityToggle extends StatelessWidget {
  final bool isPasswordVisible;
  final VoidCallback onTap;

  const PasswordVisibilityToggle({
    Key? key,
    required this.isPasswordVisible,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(
        isPasswordVisible ? Icons.visibility : Icons.visibility_off,
      ),
    );
  }
}
