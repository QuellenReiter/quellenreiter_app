import 'package:flutter/material.dart';
import 'package:quellenreiter_app/constants/constants.dart';
import 'package:quellenreiter_app/models/quellenreiter_app_state.dart';
import 'package:quellenreiter_app/navigation/quellenreiter_routes.dart';

/// Class to parse given links and direct users to the correct page.
///
/// In the app only used to find friends using links.
class QuellenreiterRouteInformationParser
    extends RouteInformationParser<QuellenreiterRoutePath> {
  @override
  Future<QuellenreiterRoutePath> parseRouteInformation(
      RouteInformation routeInformation) async {
    // Url to be parsed
    final uri = Uri.parse(routeInformation.location!);
    // Handle '/'
    if (uri.pathSegments.isEmpty) {
      // check if logged in somehow.
      return QuellenreiterRoutePath(
          QuellenreiterAppState()..route = Routes.login);
    }

    // Handle '/user/:id'
    if (uri.pathSegments.length == 2) {
      if (uri.pathSegments[0] != 'user') {
        return QuellenreiterRoutePath(
            QuellenreiterAppState()..route = Routes.home);
      }
      var remaining = uri.pathSegments[1];
      // check if logged in
      // try to login, if usccess return edit page
      return QuellenreiterRoutePath(QuellenreiterAppState()
        ..route = Routes.friends
        ..friendsQuery = remaining);
    }
    // Handle unknown routes
    return QuellenreiterRoutePath(QuellenreiterAppState()..route = Routes.home);
  }

  @override
  RouteInformation? restoreRouteInformation(
      QuellenreiterRoutePath configuration) {
    if (configuration.isFriendsPage) {
      return const RouteInformation(location: '/user/');
    }
    if (configuration.isHomePage) {
      return const RouteInformation(location: '/');
    }
    return null;
  }
}
