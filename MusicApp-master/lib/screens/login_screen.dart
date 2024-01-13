import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:music_app/main.dart';
import 'package:email_validator/email_validator.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController(text: '');
  final passwordController = TextEditingController(text: '');
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LoginScreenHeader(size: size),
                LoginForm(
                  emailController: emailController,
                  passwordController: passwordController,
                ),
                const LoginScreenFooter()
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LoginScreenFooter extends StatelessWidget {
  const LoginScreenFooter({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      const Text(
        "OR",
        style: TextStyle(color: Color.fromARGB(255, 15, 15, 15)),
      ),
      const SizedBox(
        height: 10,
      ),
      SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
            icon: const Image(
              image: AssetImage("assets/images/google.png"),
              width: 20,
            ),
            onPressed: () {},
            label: const Text("Sign-In with Google"),
            style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: Colors.white,
                // backgroundColor: const Color(0xFF272727),
                side: const BorderSide(color: Color(0xFF272727)),
                padding: const EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)))),
      ),
      const SizedBox(
        height: 10,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Don't have an Account? ",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
          const Icon(Icons.arrow_right_alt),
          TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed("/sign_up");
              },
              child: const Text("Sign-up"))
        ],
      )
    ]);
  }
}

class LoginScreenHeader extends StatelessWidget {
  const LoginScreenHeader({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image(
          image: const AssetImage("assets/images/logo.png"),
          height: size.height * 0.25,
        ),
        const Text(
          "Welcome back,",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 30),
        ),
        const Text(
          "Millions of songs. Let's enjoy them",
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
      ],
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({
    Key? key,
    required this.emailController,
    required this.passwordController,
  }) : super(key: key);
  final TextEditingController emailController;
  final TextEditingController passwordController;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  late bool _passwordInVisible;
  @override
  void initState() {
    _passwordInVisible = true;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: widget.emailController,
              style: const TextStyle(
                color: Colors.black, // set the color of the text
              ),
              decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.email),
                  labelText: "E-Mail",
                  hintText: "E-mail",
                  border: OutlineInputBorder()),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (email) =>
                  email != null && !EmailValidator.validate(email)
                      ? 'Enter a valid email'
                      : null,
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: widget.passwordController,
              style: const TextStyle(
                color: Colors.black, // set the color of the text
              ),
              obscureText: _passwordInVisible,
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock),
                  labelText: "Password",
                  hintText: "Password",
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _passwordInVisible = !_passwordInVisible;
                      });
                    },
                    icon: Icon(
                      _passwordInVisible
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                  )),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => value != null && value.length < 6
                  ? 'Enter.min 6 characters'
                  : null,
            ),
            const SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                  onPressed: () {}, child: const Text("Forgot Password?")),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: signIn,
                  style: ElevatedButton.styleFrom(
                      elevation: 0,
                      // backgroundColor: Colors.white,
                      backgroundColor: const Color(0xFF272727),
                      side: const BorderSide(color: Colors.white),
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5))),
                  child: const Text("LOGIN"),
                ))
          ],
        ),
      ),
    );
  }

  Future signIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: widget.emailController.text.trim(),
        password: widget.passwordController.text.trim(),
      );
      navigatorKey.currentState?.pushNamed('/');
    } on FirebaseAuthException catch (e) {
      scaffoldMessengerKey.currentState?.showSnackBar(
          SnackBar(content: Text("${e.message}"), backgroundColor: Colors.red));
    }
  }
}
