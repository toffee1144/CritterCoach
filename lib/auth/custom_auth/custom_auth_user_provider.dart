import 'package:rxdart/rxdart.dart';

import 'custom_auth_manager.dart';

class CritterCareAuthUser {
  CritterCareAuthUser({required this.loggedIn, this.uid});

  bool loggedIn;
  String? uid;
}

/// Generates a stream of the authenticated user.
BehaviorSubject<CritterCareAuthUser> critterCareAuthUserSubject =
    BehaviorSubject.seeded(CritterCareAuthUser(loggedIn: false));
Stream<CritterCareAuthUser> critterCareAuthUserStream() =>
    critterCareAuthUserSubject
        .asBroadcastStream()
        .map((user) => currentUser = user);
