import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sample_login/screens/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Object for calling http requests
  final Dio dioClient = Dio();

  bool isCallingApi = false;

  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset('assets/login.jpg'),
                const Center(
                  child: Text(
                    'Login',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
                  ),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  onChanged: (name) => email = name,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    contentPadding: const EdgeInsets.all(12),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelText: 'Email',
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  onChanged: (pass) => password = pass,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    contentPadding: const EdgeInsets.all(12),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelText: 'Password',
                  ),
                ),
                const SizedBox(height: 24),
                GestureDetector(
                  onTap: attemptLogin,
                  child: Container(
                    height: 48,
                    alignment: Alignment.center,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xFF007CFF),
                    ),
                    child: isCallingApi
                        ? const CircularProgressIndicator.adaptive(
                            backgroundColor: Colors.white,
                          )
                        : const Text(
                            'Login',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void attemptLogin() async {
    setState(() => isCallingApi = true);
    var response = await dioClient.post(
      'https://khposter.com/api/p1-user-login',
      options: Options(
        headers: {
          "Content-Type": "application/json",
          'Accept': '*/*',

          ///? This is just the requirement from khposter.com,
          ///? Some other website no need this
          'poster_check': 'HTRF35Poster90io@#Xcv100RF',
        },
      ),
      data: {
        "p1_email": email,
        "p1_password": password,
        "p1_user_token": 23423423432,
      },
    );

    /// If the http calling return some problems, meaning it failed
    if (response.data['status'] == 0) {
      setState(() => isCallingApi = false);
      showError(response.data['message']);
      return;
    }

    /// If it's not fail then we go to the next page

    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) {
        return const HomePage();
      },
    ));
  }

  void showError(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Could not Login'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Ok'),
            )
          ],
        );
      },
    );
  }
}
