import 'package:flutter/material.dart';
import 'package:quellenreiter_app/navigation/quellenreiter_routes.dart';

/// Class to parse given links and direct users to the correct page.
class QuellenreiterRouteInformationParser
    extends RouteInformationParser<QuellenreiterRoutePath> {
  @override
  Future<QuellenreiterRoutePath> parseRouteInformation(
      RouteInformation routeInformation) async {
    // Url to be parsed
    final uri = Uri.parse(routeInformation.location!);
    // Handle '/'
    if (uri.pathSegments.isEmpty) {
      return QuellenreiterRoutePath.home();
    }

    // Handle '/book/:id'
    if (uri.pathSegments.length == 2) {
      if (uri.pathSegments[0] != 'statement') {
        return QuellenreiterRoutePath.unknown();
      }
      var remaining = uri.pathSegments[1];
      // check if logged in
      // try to login, if usccess return edit page
      return QuellenreiterRoutePath.details(remaining);
    }
    // Handle unknown routes
    return QuellenreiterRoutePath.unknown();
  }

  @override
  RouteInformation? restoreRouteInformation(
      QuellenreiterRoutePath configuration) {
    if (configuration.isUnknown) {
      return const RouteInformation(location: '/');
    }
    if (configuration.isHomePage) {
      return const RouteInformation(location: '/');
    }
    if (configuration.isDetailsPage) {
      return RouteInformation(
          location: '/statement/${configuration.statementID}');
    }
    return null;
  }
}
