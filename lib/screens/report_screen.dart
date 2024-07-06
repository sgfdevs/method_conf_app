import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:method_conf_app/env.dart';
import 'package:method_conf_app/theme.dart';
import 'package:method_conf_app/widgets/app_navigator.dart';
import 'package:method_conf_app/widgets/app_screen.dart';
import 'package:method_conf_app/widgets/half_border_box.dart';
import 'package:method_conf_app/utils/utils.dart';

class ReportScreen extends StatefulWidget {
  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _message = '';
  String? _resolution = '';
  String? _name = '';
  String? _email = '';
  String? _phone = '';
  bool _processing = false;

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
                    _message = value;
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
                    _resolution = value;
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
                    _name = value;
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
                    _email = value;
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
                    _phone = value;
                  });
                },
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    backgroundColor: Colors.black,
                  ),
                  onPressed: _submitReport,
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
                  visible: _processing,
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
    _formKey.currentState!.save();

    if (_message == '') {
      showErrorDialog(
        context: context,
        message:
            'Looks like there are some required fields not filled out in the form. Please go back and try again.',
      );
      return;
    }

    setState(() {
      _processing = true;
    });

    var data = json.encode({
      'message': _message,
      'resolution': _resolution,
      'name': _name,
      'email': _email,
      'phone': _phone,
    });

    late http.Response response;

    try {
      response = await http.post(
        Uri.parse(Env.reportEndpoint),
        body: data,
        headers: {'Content-Type': 'application/json'},
      );
    } catch (err) {
      _requestErrorDialog();
    } finally {
      setState(() {
        _processing = false;
      });
    }

    if (response.statusCode < 200 && response.statusCode >= 300) {
      _requestErrorDialog();
      return;
    }

    AppNavigator.pushReplacementNamed('/more/report/success');
  }

  void _requestErrorDialog() {
    showErrorDialog(
      context: context,
      message:
          'There was an error submitting your report. Please text Shawna Baron at <a href="tel:4178949926">417-894-9926</a>',
    );
  }
}
