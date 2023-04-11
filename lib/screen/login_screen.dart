import 'package:flutter/material.dart';
import 'package:gellary/screen/gellary_screen.dart';
import 'package:get/get.dart';
import 'package:gellary/controller/get_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final controller = Get.put(GetController());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  FocusNode myFocusNode = FocusNode();
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    myFocusNode.dispose();
  }

  void _submitForm() async {
    setState(() {
      _isLoading = true;
    });
    if (_userController.text.isEmpty || _passwordController.text.isEmpty) {
      setState(() {
        _isLoading = false;
      });
      return Get.defaultDialog(
          title: "Invalid Value!",
          content: const Text('Please Enter Value'),
          confirm: InkWell(
            onTap: () {
              Get.back();
            },
            child: Container(
                width: MediaQuery.of(context).size.width * .4,
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Text(
                  "Ok",
                  style: TextStyle(color: Colors.white),
                )),
          ),
          onConfirm: () {
            Get.back();
          });
    }
    _formKey.currentState!.save();
    String result = await controller.logInAuth(
        _userController.text, _passwordController.text);
    print("################!!!!!!!!!!${result}");
    setState(() {
      _isLoading = false;
    });
    if (result == "success") {
      Get.off(() => const GellaryScreen());
    } else {
      Get.defaultDialog(
        title: 'Something went wrong',
        content: const Text('Try again'),
        confirm: InkWell(
          onTap: () {
            Get.back();
          },
          child: Container(
              width: MediaQuery.of(context).size.width * .4,
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Text(
                "Ok",
                style: TextStyle(color: Colors.white),
              )),
        ),
      );
    }
    setState(() {
      _isLoading = false;
    });
  }

  // the title of the page
  Widget buildTitleOfTheScreen() {
    return Container(
      padding: const EdgeInsets.only(top: 70),
      child: const Center(
        child: Text(
          "My\nGellary",
          style: TextStyle(
            fontSize: 35,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  // the text of login
  Widget buildTextOfUserLogin() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * .9,
      child: const Text(
        "LOG IN",
        style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  // text form field of userName for login
  Widget buildTextFormFieldUserLogin() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(18),
      ),
      child: TextFormField(
        controller: _userController,
        textAlign: TextAlign.left,
        autofocus: true,
        decoration: const InputDecoration(
          hintText: 'User Name',
          hintStyle: TextStyle(color: Colors.black),
          border: InputBorder.none,
        ),
        style: const TextStyle(color: Colors.black),
        onFieldSubmitted: (value) {
          myFocusNode.requestFocus();
        },
      ),
    );
  }

  // text form field of password for login
  Widget buildTextFormFieldPasswordLogin() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(18),
      ),
      child: TextFormField(
        controller: _passwordController,
        textAlign: TextAlign.left,
        obscureText: true,
        focusNode: myFocusNode,
        decoration: const InputDecoration(
          hintText: 'Password',
          hintStyle: TextStyle(color: Colors.black),
          border: InputBorder.none,
        ),
        style: const TextStyle(color: Colors.black),
      ),
    );
  }

  // button for login
  Widget buildLoginButton() {
    return Container(
      width: MediaQuery.of(context).size.width * .7,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: TextButton(
        onPressed: () {
          setState(() {
            _isLoading = true;
          });
          _submitForm();
        },
        child: const Text(
          "SUBMIT",
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/background_login.jpeg'),
              fit: BoxFit.cover),
        ),
        child: ListView(
          children: [
            // the title of the page
            buildTitleOfTheScreen(),
            Form(
              key: _formKey,
              child: Container(
                  height: MediaQuery.of(context).size.height > 600
                      ? MediaQuery.of(context).size.height * .5
                      : MediaQuery.of(context).size.height * .7,
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white54,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      buildTextOfUserLogin(),
                      buildTextFormFieldUserLogin(),
                      buildTextFormFieldPasswordLogin(),
                      buildLoginButton(),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
