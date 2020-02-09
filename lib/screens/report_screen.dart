import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:method_conf_app/env.dart';

import 'package:method_conf_app/theme.dart';
import 'package:method_conf_app/widgets/app_html.dart';
import 'package:method_conf_app/widgets/app_navigator.dart';
import 'package:method_conf_app/widgets/app_screen.dart';
import 'package:method_conf_app/widgets/half_border_box.dart';

class ReportScreen extends StatefulWidget {
  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final _formKey = GlobalKey<FormState>();

  bool processing = false;

  String message = '';

  String resolution = '';

  String name = '';

  String email = '';

  String phone = '';

  @override
  Widget build(BuildContext context) {
    return AppScreen(
      title: 'Report Issue',
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(20),
          children: <Widget>[
            Text(
              'Message',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text('Required', style: TextStyle(fontSize: 12)),
            SizedBox(height: 10),
            HalfBorderBox(
              child: TextFormField(
                maxLines: 4,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.neutralExtraLight,
                  hintText: 'What is the issue?',
                  border: InputBorder.none,
                ),
                onSaved: (value) {
                  setState(() {
                    message = value;
                  });
                },
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Resolution Suggestion',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text('optional', style: TextStyle(fontSize: 12)),
            SizedBox(height: 10),
            HalfBorderBox(
              child: TextFormField(
                maxLines: 4,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.neutralExtraLight,
                  hintText: 'How can this be fixed?',
                  border: InputBorder.none,
                ),
                onSaved: (value) {
                  setState(() {
                    resolution = value;
                  });
                },
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Your Info',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text('optional', style: TextStyle(fontSize: 12)),
            SizedBox(height: 10),
            HalfBorderBox(
              child: TextFormField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.neutralExtraLight,
                  hintText: 'Your Name',
                  border: InputBorder.none,
                ),
                onSaved: (value) {
                  setState(() {
                    name = value;
                  });
                },
              ),
            ),
            SizedBox(height: 15),
            HalfBorderBox(
              child: TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.neutralExtraLight,
                  hintText: 'Email',
                  border: InputBorder.none,
                ),
                onSaved: (value) {
                  setState(() {
                    email = value;
                  });
                },
              ),
            ),
            SizedBox(height: 15),
            HalfBorderBox(
              child: TextFormField(
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.neutralExtraLight,
                  hintText: 'Phone Number',
                  border: InputBorder.none,
                ),
                onSaved: (value) {
                  setState(() {
                    phone = value;
                  });
                },
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                FlatButton(
                  onPressed: _submitReport,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  color: AppColors.primary,
                  child: Text(
                    'SEND',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                SizedBox(width: 15),
                Visibility(
                  visible: processing,
                  child: CircularProgressIndicator(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitReport() async {
    _formKey.currentState.save();

    if (message == '') {
      showErrorDialog(
        'Looks like there are some required fields not filled out in the form. Please go back and try again.',
      );
      return;
    }

    setState(() {
      processing = true;
    });

    var data = json.encode({
      'message': message,
      'resolution': resolution,
      'name': name,
      'email;': email,
      'phone': phone,
    });

    http.Response response;

    try {
      response = await http.post(Env.reportEndpoint, body: data, headers: {
        'Content-Type': 'application/json'
      });
    } catch(err) {
      _requestErrorDialog();
    } finally {
      setState(() {
        processing = false;
      });
    }

    if(response.statusCode != 200) {
      _requestErrorDialog();
      return;
    }

    AppNavigator.pushReplacementNamed('/more/report/success');
  }

  void _requestErrorDialog() {
    showErrorDialog(
      'There was an error submitting your report. Please text Shawna Baron at <a href="tel:4178949926">417-894-9926</a>',
    );
  }

  Future<void> showErrorDialog(String message) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Whoops'),
          content: IntrinsicHeight(child: AppHtml(markup: message)),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'Ok',
                style: TextStyle(color: AppColors.accent),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
