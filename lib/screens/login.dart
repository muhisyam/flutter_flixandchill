import 'package:flutter/material.dart';
import 'package:flutter_flixandchill/helper/hive_database.dart';
import 'package:flutter_flixandchill/main.dart';
import 'package:flutter_flixandchill/screens/register.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class LoginPage extends StatefulWidget {
  final ThemeData? themeData;
  LoginPage({this.themeData});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void validateAndSave() {
    final FormState? form = _formKey.currentState;
    if (form != null) {
      if (form.validate()) {
        print('Form is valid');
      } else {
        print('Form is invalid');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: widget.themeData!.primaryColor,
        leading: IconButton(
          icon: Icon(Icons.clear, color: widget.themeData!.primaryColor),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Log In',
          style: widget.themeData!.textTheme.headline5,
        ),
      ),
      body: Container(
        padding: new EdgeInsets.symmetric(horizontal: 10),
        color: widget.themeData!.primaryColor,
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Center(
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      'https://upload.wikimedia.org/wikipedia/commons/thumb/7/75/The_Guardian_2018.svg/295px-The_Guardian_2018.svg.png?20200131140441',
                      // width: 200,
                      // height: 200,
                      // fit: BoxFit.cover,
                    )),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  contentPadding: const EdgeInsets.all(10),
                  hintText: "Username",
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black45, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black87, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                  fillColor: Colors.white,
                  filled: true,
                  icon: Icon(
                    Icons.account_circle,
                    color: Colors.white,
                    size: 35,
                  ),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Username cannot be blank' : null,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  contentPadding: const EdgeInsets.all(10),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black45, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black87, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                  fillColor: Colors.white,
                  filled: true,
                  icon: Icon(
                    Icons.vpn_key_outlined,
                    color: Colors.white,
                    size: 35,
                  ),
                  hintText: "Password",
                ),
                obscureText: true,
                validator: (value) =>
                    value!.isEmpty ? 'Password cannot be blank' : null,
              ),
              _buildLoginButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _commonSubmitButton({
    required String labelButton,
    required Function(String) submitCallback,
  }) {
    return Container(
      padding: new EdgeInsets.only(top: 15),
      width: MediaQuery.of(context).size.width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(30.0),
            ),
            primary: Color(0xFF262626),
            textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        child: Text(labelButton),
        onPressed: () {
          submitCallback(labelButton);
        },
      ),
    );
  }

  Widget _buildLoginButton() {
    return _commonSubmitButton(
      labelButton: "Login",
      submitCallback: (value) {
        validateAndSave();
        String currentUsername = _usernameController.value.text;
        String currentPassword = _passwordController.value.text;

        _processLogin(currentUsername, currentPassword);
      },
    );
  }

  void _processLogin(String username, String password) async {
    final HiveDatabase _hive = HiveDatabase();
    bool found = false;

    found = _hive.checkLogin(username, password);

    if (!found) {
      Alert(
        context: context,
        type: AlertType.error,
        title: "Login Error",
        desc: "Please Try Again",
        buttons: [
          DialogButton(
            color: Color(0xFF242424),
            child: Text(
              "OK",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.pop(context),
            width: 120,
          )
        ],
      ).show();
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => MyHomePage(),
        ),
      );
    }
  }
}
