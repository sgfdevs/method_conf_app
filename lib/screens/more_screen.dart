import 'package:flutter/material.dart';

import 'package:method_conf_app/providers/conference_provider.dart';
import 'package:method_conf_app/utils/utils.dart';
import 'package:method_conf_app/widgets/app_list_item.dart';
import 'package:method_conf_app/widgets/app_navigator.dart';
import 'package:method_conf_app/widgets/app_screen.dart';
import 'package:method_conf_app/widgets/page_loader.dart';
import 'package:provider/provider.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  Future? _conferenceFuture;

  @override
  void initState() {
    super.initState();

    final conferenceProvider =
        Provider.of<ConferenceProvider>(context, listen: false);

    _conferenceFuture = conferenceProvider.init();
  }

  @override
  Widget build(BuildContext context) {
    final conferenceProvider = Provider.of<ConferenceProvider>(context);

    final mobileAppLinks =
        conferenceProvider.conference?.properties?.mobileAppLinks ?? [];

    return AppScreen(
      title: 'More ...',
      body: PageLoader(
        future: _conferenceFuture,
        child: RefreshIndicator(
          onRefresh: () async {
            await conferenceProvider.refresh();
          },
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              ...mobileAppLinks.map(
                (link) => AppListItem(
                  text: link.title ?? '',
                  onTap: () {
                    final url = link.fullUrl;

                    if (url != null) {
                      launchUrl(url);
                    }
                  },
                ),
              ),
              AppListItem(
                text: 'Speakers',
                onTap: () => AppNavigator.pushNamed('/more/speakers'),
              ),
              AppListItem(
                text: 'Report Issue',
                onTap: () => AppNavigator.pushNamed('/more/report'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
