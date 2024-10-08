import 'package:flutter/material.dart';
import 'package:method_conf_app/env.dart';
import 'package:method_conf_app/providers/sponsor_provider_v2.dart';
import 'package:method_conf_app/widgets/app_banner.dart';
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
  const SponsorsScreen({super.key});

  @override
  State<SponsorsScreen> createState() => _SponsorsScreenState();
}

class _SponsorsScreenState extends State<SponsorsScreen> {
  Future? _sponsorsFuture;

  @override
  void initState() {
    super.initState();
    var sponsorProvider =
        Provider.of<SponsorProviderV2>(context, listen: false);

    _sponsorsFuture = sponsorProvider.init();
  }

  @override
  Widget build(BuildContext context) {
    var sponsorProvider = Provider.of<SponsorProvider>(context);
    var sponsorProviderV2 = Provider.of<SponsorProviderV2>(context);

    return AppScreen(
      title: 'Sponsors',
      body: PageLoader(
        future: _sponsorsFuture,
        child: RefreshIndicator(
          onRefresh: () async {
            await sponsorProviderV2.refresh();
          },
          child: ListView(
            padding: const EdgeInsets.all(20),
            physics: const AlwaysScrollableScrollPhysics(),
            children: <Widget>[
              const Text(
                'Method Conference 2024 is proud to be sponsored by',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 15),
              ...sponsorProviderV2.sponsorTiers.expand((tier) {
                return [
                  Text(tier.properties?.title ?? 'Test'),
                  ...tier.properties?.mobileAppSponsors.map((sponsor) {
                        return Text(sponsor.properties?.title ?? 'Test');
                      }) ??
                      [],
                ];
              }),
              ...sponsorProvider.largeSponsors.map((sponsor) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: _buildSponsor(sponsor),
                );
              }),
              ..._buildNormalSponsors(sponsorProvider.normalSponsors),
              ..._buildBanner(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSponsor(Sponsor sponsor) {
    return Container(
      height: sponsor.mobileSponsor! ? 130 : 100,
      color: sponsor.background == 'dark'
          ? AppColors.primaryLight
          : AppColors.neutralExtraLight,
      child: TextButton(
        style: TextButton.styleFrom(padding: const EdgeInsets.all(0)),
        onPressed: () {
          launchUrl(sponsor.url!);
        },
        child: Row(
          children: <Widget>[
            Flexible(flex: 1, child: Container()),
            Flexible(
              flex: 8,
              child: Center(
                child: OverflowBox(
                  maxHeight: sponsor.mobileSponsor! ? 75 : 65,
                  child: CachedNetworkImage(
                    imageUrl: sponsor.image!,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.transparent),
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
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
        padding: const EdgeInsets.only(bottom: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Flexible(
              child: sponsorPair.isNotEmpty
                  ? _buildSponsor(sponsorPair[0])
                  : Container(),
            ),
            const SizedBox(width: 15),
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

  List<Widget> _buildBanner() {
    var eventDate = DateTime.parse(Env.eventDate);

    if (eventDate.isBefore(DateTime.now())) {
      return [Container()];
    }

    return [
      const SizedBox(height: 20),
      AppBanner(
        text: 'Interested in becoming a sponsor?',
        buttonText: 'SEE OPPORTUNITIES',
        onButtonPress: () => launchUrl(Env.sponsorUrl),
      ),
    ];
  }
}
