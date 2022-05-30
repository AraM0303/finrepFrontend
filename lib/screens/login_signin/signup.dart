import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'constants.dart';
import '/model/value_objects/user.dart';
import 'package:http/http.dart' as http;
import '../../env.sample.dart';
import 'package:get/get.dart';
import 'package:flutter_frontend_test/screens/elegir_empresas.dart';

class SignUp extends StatefulWidget {
  final Function onLogInSelected;

  SignUp({required this.onLogInSelected});

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  final TextEditingController _controller3 = TextEditingController();
  Future<User>? _futureUser;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.all(size.height > 770
          ? 64
          : size.height > 670
              ? 32
              : 16),
      child: Center(
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(25),
            ),
          ),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            height: size.height *
                (size.height > 770
                    ? 0.7
                    : size.height > 670
                        ? 0.8
                        : 0.9),
            width: 500,
            color: Colors.white,
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Registro",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Container(
                        width: 30,
                        child: Divider(
                          color: kPrimaryColor,
                          thickness: 2,
                        ),
                      ),
                      SizedBox(
                        height: 32,
                      ),
                      TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          hintText: 'Nombre',
                          labelText: 'Nombre',
                          suffixIcon: Icon(
                            Icons.person_outline,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 32,
                      ),
                      TextField(
                        controller: _controller2,
                        decoration: InputDecoration(
                          hintText: 'Correo',
                          labelText: 'Correo',
                          suffixIcon: Icon(
                            Icons.mail_outline,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 32,
                      ),
                      TextField(
                        controller: _controller3,
                        decoration: InputDecoration(
                          hintText: 'Contraseña',
                          labelText: 'Contraseña',
                          suffixIcon: Icon(
                            Icons.lock_outline,
                          ),
                        ),
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                      ),
                      SizedBox(
                        height: 64,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _futureUser = registerUser(_controller.text,
                                _controller2.text, _controller3.text);
                          });
                        },
                        child: const Text('Registrarse'),
                      ),
                      //actionButton("Crear cuenta"),
                      SizedBox(
                        height: 32,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "¿Ya tienes cuenta?",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          GestureDetector(
                            onTap: () {
                              widget.onLogInSelected();
                            },
                            child: Row(
                              children: [
                                Text(
                                  "Iniciar Sesión",
                                  style: TextStyle(
                                    color: kPrimaryColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Icon(
                                  Icons.arrow_forward,
                                  color: kPrimaryColor,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  FutureBuilder<User> buildFutureBuilder() {
    return FutureBuilder<User>(
      future: _futureUser,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text(snapshot.data!.username);
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        return const CircularProgressIndicator();
      },
    );
  }
}

Future<User> registerUser(
    String username, String email, String password) async {
  final response = await http.post(
    Uri.parse("${Env.URL_PREFIX}/register"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'username': username,
      'email': email,
      'password': password
    }),
  );
  if (response.statusCode == 201) {
    developer.log("se armo");
    Get.to(const ElegirEmpresa());
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    return User.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception('Failed to register employee.');
  }
}