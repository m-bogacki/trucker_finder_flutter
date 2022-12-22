import 'package:trucker_finder/providers/user_provider.dart';

class LoggedUser extends User {
  LoggedUser(String id, String firstName, String lastName, int profile)
      : super(
            id: id, firstName: firstName, lastName: lastName, profile: profile);

  Future<void> updateLoggedUser(userData) async {
    try {
      updateUser(userData);
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }
}
