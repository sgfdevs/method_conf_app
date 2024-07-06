import 'package:flutter/material.dart';

class PageLoader extends StatelessWidget {
  final Widget child;
  final Future? future;

  const PageLoader({Key? key, required this.child, this.future}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return child;
        }

        if (snapshot.hasError) {
          return Center(
            child: Text('Something went wrong.'),
          );
        }

        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
