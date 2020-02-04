import 'package:configurable_expansion_tile/configurable_expansion_tile.dart';
import 'package:flutter/material.dart';
import 'package:method_conf_app/theme.dart';

class SessionExpansionTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.neutralExtraLight,
      padding: EdgeInsets.all(10),
      child: ConfigurableExpansionTile(
        header: _buildHeader(expanded: false),
        headerExpanded: _buildHeader(expanded: true),
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 15, bottom: 15),
            child: Text(
              "SwiftUI is one of the most important developments within Apple's ecosystem since the arrival of the Swift programming language. Even though the nascent framework isn’t without several shortcomings, it pays to take it seriously from the outset if you want to gain a better insight into the direction Apple is taking us. The challenge? Almost everything is new. We no longer construct interfaces with an imperative approach - it’s now declarative. This means we now describe all the states our interface can be in, and let SwiftUI handle all of the rest. Further, it relies heavily on another new Apple framework, Combine. Using Combine, SwiftUI opens up a whole new world of reactive programming paradigms, where state is no longer as much of an issue as it used to be. The syntax is also different from anything we’ve seen from Swift. That’s because Swift 5.1 leverages new language capabilities such as property wrappers and function builders to allow for SwiftUI to express itself in a natural way. Lastly, SwiftUI is cross platform to Apple’s ecosystem. That doesn’t mean we can write once and run anywhere, it means we can learn once and apply everywhere. We’ll take a look at what that really means in practice. If SwiftUI has piqued your curiosity, join me to get the high level view in this talk which answers what it is, the technology that makes it possible and how it works across each of Apple’s operating systems.",
              style: TextStyle(fontSize: 14, height: 1.6),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildHeader({bool expanded}) {
    return Expanded(
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                '8:00AM-9:00AM',
                style: TextStyle(fontSize: 16),
              ),
              FlatButton(
                color: AppColors.accent,
                child: Text(
                  'Session Feedback',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {},
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Swift UI',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Row(
                children: <Widget>[
                  Text(
                    expanded ? 'Less' : 'More',
                    style: TextStyle(
                      color: AppColors.accent,
                      fontSize: 16,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  Icon(expanded ? Icons.expand_less : Icons.expand_more),
                ],
              )
            ],
          ),
          _buildSpeaker(),
        ],
      ),
    );
  }

  Widget _buildSpeaker() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        InkWell(
          onTap: () {},
          child: Row(
            children: <Widget>[
              ClipOval(
                child: Image.network(
                  'https://picsum.photos/250?image=9',
                  height: 50,
                  width: 50,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Jordan Morgan',
                    style: TextStyle(
                      color: AppColors.accent,
                      fontSize: 16,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  Text(
                    'iOS engineer at Buffer',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
