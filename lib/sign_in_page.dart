import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shopping_list/authentication_service.dart';
import 'package:flutter_shopping_list/sign_up_page.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  dynamic firebaseResponse = "";
  bool _isObscure = true;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('Shopping list')),
          backgroundColor: Colors.green.shade200,
        ),
        body: Center(
            child: ListView(
                // shrinkWrap: true,
                padding: const EdgeInsets.all(10),
                children: [
              const SizedBox(height: 50),
              TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                      labelText: "Email",
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.green.shade200, width: 2.0)))),
              const SizedBox(height: 10),
              TextField(
                  obscureText: _isObscure,
                  controller: passwordController,
                  decoration: InputDecoration(
                      labelText: "Password",
                      suffixIcon: IconButton(
                          icon: Icon(_isObscure
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              _isObscure = !_isObscure;
                            });
                          }),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.green.shade200, width: 2.0)))),
              const SizedBox(height: 25),
              Center(
                  child: Text(firebaseResponse.toString(),
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center)),
              const SizedBox(height: 25),
              Container(
                  margin: const EdgeInsets.only(left: 115, right: 115),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size(1, 50),
                          primary: Colors.green.shade200),
                      onPressed: () async {
                        firebaseResponse = await context
                            .read<AuthenticationService>()
                            .signIn(emailController.text.trim(),
                                passwordController.text.trim());
                        setState(() {
                          if (firebaseResponse ==
                              'Given String is empty or null') {
                            firebaseResponse = 'Email or password missing.';
                          }
                        });
                      },
                      child: const Text("Sign in"))),
              const SizedBox(height: 35),
              const SizedBox(height: 35),
              Center(
                  child: IntrinsicWidth(
                      child: Row(
                children: [
                  const Text("Don't have an account yet?"),
                  const SizedBox(width: 10),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.green.shade200),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignUpPage()));
                      },
                      child: const Text("Sign up here"))
                ],
              ))),
            ])));
  }
}
