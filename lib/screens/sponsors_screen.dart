import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:method_conf_app/widgets/app_screen.dart';
import 'package:method_conf_app/providers/sponsor_provider.dart';

class SponsorsScreen extends StatefulWidget {
  @override
  _SponsorsScreenState createState() => _SponsorsScreenState();
}

class _SponsorsScreenState extends State<SponsorsScreen> {
  @override
  void initState() {
    super.initState();

    var sponsorProvider = Provider.of<SponsorProvider>(context, listen: false);

    sponsorProvider.fetchInitialSponsors();
  }

  @override
  Widget build(BuildContext context) {
    return AppScreen(
      title: 'Partners',
      body: Container(
        child: Text('Partners'),
      ),
    );
  }
}
