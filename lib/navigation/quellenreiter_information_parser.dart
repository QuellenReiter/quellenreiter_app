import 'package:flutter/material.dart';
import 'package:quellenreiter_app/constants/constants.dart';
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
      return QuellenreiterRoutePath(Routes.login);
    }

    // Handle '/user/:id'
    if (uri.pathSegments.length == 2) {
      if (uri.pathSegments[0] != 'user') {
        return QuellenreiterRoutePath(Routes.home);
      }
      var remaining = uri.pathSegments[1];
      // check if logged in
      return QuellenreiterRoutePath(Routes.friends); // add the query somehow!!
    }
    // Handle unknown routes
    return QuellenreiterRoutePath(Routes.home);
  }

  @override
  RouteInformation? restoreRouteInformation(
      QuellenreiterRoutePath configuration) {
    // if (configuration.isFriendsPage) {
    //   return const RouteInformation(location: '/user/');
    // }
    // if (configuration.isHomePage) {
    //   return const RouteInformation(location: '/');
    // }
    // if (configuration.isLoginPage) {
    //   return const RouteInformation(location: '/login/');
    // }
    // if (configuration.isSignUpPage) {
    //   return const RouteInformation(location: '/signup/');
    // }
    // if (configuration.isArchivePage) {
    //   return const RouteInformation(location: '/archive/');
    // }
    return RouteInformation(
        location:
            '/${configuration.route.toString().replaceAll('Routes.', '')}');

    // return null;
  }
}
