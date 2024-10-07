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
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
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
          padding: const EdgeInsets.all(20),
          children: <Widget>[
            const Text(
              'Message',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Text('Required', style: TextStyle(fontSize: 12)),
            const SizedBox(height: 10),
            HalfBorderBox(
              child: TextFormField(
                maxLines: 4,
                decoration: const InputDecoration(
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
            const SizedBox(height: 20),
            const Text(
              'Resolution Suggestion',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Text('optional', style: TextStyle(fontSize: 12)),
            const SizedBox(height: 10),
            HalfBorderBox(
              child: TextFormField(
                maxLines: 4,
                decoration: const InputDecoration(
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
            const SizedBox(height: 20),
            const Text(
              'Your Info',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Text('optional', style: TextStyle(fontSize: 12)),
            const SizedBox(height: 10),
            HalfBorderBox(
              child: TextFormField(
                decoration: const InputDecoration(
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
            const SizedBox(height: 15),
            HalfBorderBox(
              child: TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
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
            const SizedBox(height: 15),
            HalfBorderBox(
              child: TextFormField(
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
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
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    backgroundColor: Colors.black,
                  ),
                  onPressed: _submitReport,
                  child: const Text(
                    'SEND',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Visibility(
                  visible: _processing,
                  child: const CircularProgressIndicator(),
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
