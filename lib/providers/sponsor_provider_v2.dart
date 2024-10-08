import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:method_conf_app/data/umbraco/get_child_nodes_of_type.dart';
import 'package:method_conf_app/data/umbraco/models/sponsor_tier.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:method_conf_app/data/umbraco/models/sponsors.dart';
import 'package:method_conf_app/providers/conference_provider.dart';

const _sponsorsStorageKey = 'app-sponsors-v2';

class SponsorProviderV2 extends ChangeNotifier {
  ConferenceProvider conferenceProvider;

  Sponsors? _sponsors;

  Sponsors? get sponsors => _sponsors;

  set sponsors(Sponsors? value) {
    _sponsors = value;
    notifyListeners();
  }

  List<SponsorTier> get sponsorTiers =>
      sponsors?.properties?.tiers
          .where(
              (tier) => tier.properties?.mobileAppSponsors.isNotEmpty ?? false)
          .toList() ??
      [];

  SponsorProviderV2({required this.conferenceProvider});

  Future<void> init() async {
    await conferenceProvider.init(enableBackgroundRefresh: false);

    sponsors ??= await load();

    if (sponsors == null) {
      await refresh();
    } else {
      refresh();
    }
  }

  Future<Sponsors?> load() async {
    var prefs = await SharedPreferences.getInstance();

    final jsonString = prefs.getString(_sponsorsStorageKey);
    return jsonString != null
        ? Sponsors.fromJson(json.decode(jsonString))
        : null;
  }

  Future<void> store(Sponsors? newSponsors) async {
    var prefs = await SharedPreferences.getInstance();

    if (newSponsors == null) {
      await prefs.remove(_sponsorsStorageKey);
      return;
    }

    await prefs.setString(
        _sponsorsStorageKey, json.encode(newSponsors.toJson()));
  }

  Future<Sponsors?> fetch() async {
    var conference = conferenceProvider.conference;

    if (conference == null) {
      return null;
    }

    var item =
        await getFirstChildNodeOfType(nodeId: conference.id, type: 'sponsors');

    if (item is! Sponsors) {
      return null;
    }

    return item;
  }

  Future<void> refresh() async {
    final newSponsors = await fetch();

    sponsors = newSponsors;

    await store(newSponsors);
  }
}
