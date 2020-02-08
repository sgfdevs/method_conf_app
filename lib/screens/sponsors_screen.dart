import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:quiver/iterables.dart' show partition;

import 'package:method_conf_app/theme.dart';
import 'package:method_conf_app/utils/utils.dart';
import 'package:method_conf_app/widgets/page_loader.dart';
import 'package:method_conf_app/models/sponsor.dart';
import 'package:method_conf_app/widgets/app_screen.dart';
import 'package:method_conf_app/providers/sponsor_provider.dart';

class SponsorsScreen extends StatefulWidget {
  @override
  _SponsorsScreenState createState() => _SponsorsScreenState();
}

class _SponsorsScreenState extends State<SponsorsScreen> {
  Future _sponsorsFuture;

  @override
  void initState() {
    super.initState();

    var sponsorProvider = Provider.of<SponsorProvider>(context, listen: false);

    _sponsorsFuture = sponsorProvider.fetchInitialSponsors();
  }

  @override
  Widget build(BuildContext context) {
    var sponsorProvider = Provider.of<SponsorProvider>(context);

    return AppScreen(
      title: 'Partners',
      body: PageLoader(
        future: _sponsorsFuture,
        child: RefreshIndicator(
          onRefresh: () async {
            await sponsorProvider.fetchSponsors();
          },
          child: ListView(
            padding: EdgeInsets.all(20),
            physics: AlwaysScrollableScrollPhysics(),
            children: <Widget>[
              Text(
                'Method Conference Springfield, MO 2020 is proud to be sponsored by:',
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 15),
              ...sponsorProvider.largeSponsors.map((sponsor) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 15),
                  child: _buildSponsor(sponsor),
                );
              }),
              ..._buildNormalSponsors(sponsorProvider.normalSponsors),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSponsor(Sponsor sponsor) {
    return Container(
      height: sponsor.mobileSponsor ? 130 : 100,
      color: sponsor.background == 'dark'
          ? AppColors.primaryLight
          : AppColors.neutralExtraLight,
      child: FlatButton(
        padding: EdgeInsets.all(0),
        onPressed: () {
          launchUrl(sponsor.url);
        },
        child: Row(
          children: <Widget>[
            Flexible(flex: 1, child: Container()),
            Flexible(
              flex: 8,
              child: Center(
                child: OverflowBox(
                  maxHeight: sponsor.mobileSponsor ? 85 : 65,
                  child: CachedNetworkImage(
                    imageUrl: sponsor.image,
                    placeholder: (context, url) => CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.transparent),
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
              ),
            ),
            Flexible(flex: 1, child: Container()),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildNormalSponsors(List<Sponsor> sponsors) {
    var chunked = partition(sponsors, 2);
    return chunked.map((sponsorPair) {
      return Padding(
        padding: EdgeInsets.only(bottom: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Flexible(
              child: sponsorPair.length >= 1
                  ? _buildSponsor(sponsorPair[0])
                  : Container(),
            ),
            SizedBox(width: 15),
            Flexible(
              child: sponsorPair.length >= 2
                  ? _buildSponsor(sponsorPair[1])
                  : Container(),
            ),
          ],
        ),
      );
    }).toList();
  }
}
