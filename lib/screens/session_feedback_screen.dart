import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:method_conf_app/env.dart';
import 'package:method_conf_app/models/session.dart';
import 'package:method_conf_app/screens/not_found_screen.dart';
import 'package:method_conf_app/theme.dart';
import 'package:method_conf_app/utils/utils.dart';
import 'package:method_conf_app/widgets/app_navigator.dart';
import 'package:method_conf_app/widgets/app_screen.dart';
import 'package:method_conf_app/widgets/half_border_box.dart';
import 'package:method_conf_app/widgets/rating.dart';

class SessionFeedbackScreen extends StatefulWidget {
  @override
  _SessionFeedbackScreenState createState() => _SessionFeedbackScreenState();
}

class _SessionFeedbackScreenState extends State<SessionFeedbackScreen> {
  late TextEditingController _commentController;
  int? _speakerRating;
  int? _contentRating;
  int? _venueRating;
  bool _processing = false;

  @override
  void initState() {
    super.initState();
    _commentController = TextEditingController();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var session = ModalRoute.of(context)!.settings.arguments as Session?;

    if (session == null) {
      return NotFoundScreen();
    }

    return AppScreen(
      title: 'Session Feedback',
      body: ListView(
        padding: EdgeInsets.all(20),
        children: <Widget>[
          Text(
            'Rate Speaker',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            '1 is meh, 5 is freaking amazing',
            style: TextStyle(fontSize: 12),
          ),
          Rating(
            currentValue: _speakerRating,
            onSelected: (value) {
              setState(() {
                _speakerRating = value;
              });
            },
          ),
          SizedBox(height: 20),
          Text(
            'Rate Content Relevance',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            '1 is meh, 5 is freaking amazing',
            style: TextStyle(fontSize: 12),
          ),
          Rating(
            currentValue: _contentRating,
            onSelected: (value) {
              setState(() {
                _contentRating = value;
              });
            },
          ),
          SizedBox(height: 20),

          Text(
            'Rate Venue',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            '1 is meh, 5 is freaking amazing',
            style: TextStyle(fontSize: 12),
          ),
          Rating(
            currentValue: _venueRating,
            onSelected: (value) {
              setState(() {
                _venueRating = value;
              });
            },
          ),
          SizedBox(height: 20),
          Text(
            'Comments',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text('Optional', style: TextStyle(fontSize: 12)),
          SizedBox(height: 10),
          HalfBorderBox(
            child: TextFormField(
              controller: _commentController,
              maxLines: 4,
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.neutralExtraLight,
                hintText: 'Your thoughts',
                border: InputBorder.none,
              ),
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  _submitFeedback(session);
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  backgroundColor: Colors.black
                ),
                child: Text(
                  'SEND FEEDBACK',
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
    );
  }

  Future<void> _submitFeedback(Session session) async {
    if (_speakerRating == null) {
      showErrorDialog(context: context, message: 'Please rate the speaker.');
      return;
    }

    if (_contentRating == null) {
      showErrorDialog(
        context: context,
        message: 'Please rate the content relevance.',
      );
      return;
    }

    if (_venueRating == null) {
      showErrorDialog(context: context, message: 'Please rate the venue.');
      return;
    }

    setState(() {
      _processing = true;
    });

    var data = json.encode({
      'sessionTitle': session.title,
      'speakerRating': _speakerRating,
      'contentRating': _contentRating,
      'venueRating': _venueRating,
      'comments': _commentController.text,
    });

    late http.Response response;

    try {
      response = await http.post(
        Uri.parse(Env.feedbackEndpoint),
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

    AppNavigator.pushReplacementNamed('/more/feedback/success');
  }

  void _requestErrorDialog() {
    showErrorDialog(
      context: context,
      message: 'There was an error submitting your feedback',
    );
  }
}
