import 'package:flutter/material.dart';
import 'package:flutter_flixandchill/helper/hive_database.dart';
import 'package:flutter_flixandchill/main.dart';
import 'package:flutter_flixandchill/model_class/user_model.dart';
import 'package:flutter_flixandchill/screens/register.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class RegisterPage extends StatefulWidget {
  final ThemeData? themeData;
  RegisterPage({this.themeData});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  final HiveDatabase _hive = HiveDatabase();

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
          'Register Page',
          style: widget.themeData!.textTheme.headline5,
        ),
      ),
      body: Container(
        padding: new EdgeInsets.symmetric(horizontal: 10),
        color: widget.themeData!.primaryColor,
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
              validator: (String? value) {
                if (value!.trim().isEmpty) {
                  return 'Username is required';
                }
              },
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
              validator: (String? value) {
                if (value!.trim().isEmpty) {
                  return 'Password is required';
                }
              },
            ),
            _buildRegisterButton(),
          ],
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

  Widget _buildRegisterButton() {
    return _commonSubmitButton(
      labelButton: "Register",
      submitCallback: (value) {
        if (_usernameController.text.isNotEmpty &&
            _passwordController.text.isNotEmpty) {
          _hive.addData(UserModel(
              username: _usernameController.text,
              password: _passwordController.text));
          _usernameController.clear();
          _passwordController.clear();
          setState(() {});

          Navigator.pop(context);
        } else {
          Alert(
            context: context,
            type: AlertType.error,
            title: "Registration Error",
            desc: "Please Try Again",
            buttons: [
              DialogButton(
                color: Color(0xFF090909),
                child: Text(
                  "OK",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () => Navigator.pop(context),
                width: 120,
              )
            ],
          ).show();
        }
      },
    );
  }
}
