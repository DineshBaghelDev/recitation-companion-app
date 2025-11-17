import 'package:flutter_riverpod/flutter_riverpod.dart';

/// User data state
class UserData {
  final String? name;
  final String? language;
  final String? goal;

  const UserData({
    this.name,
    this.language,
    this.goal,
  });

  UserData copyWith({
    String? name,
    String? language,
    String? goal,
  }) {
    return UserData(
      name: name ?? this.name,
      language: language ?? this.language,
      goal: goal ?? this.goal,
    );
  }
}

/// User data notifier
class UserDataNotifier extends Notifier<UserData> {
  @override
  UserData build() {
    // TODO: Load from shared preferences or secure storage
    return const UserData();
  }

  void setUserInfo({
    required String name,
    required String language,
    required String goal,
  }) {
    state = UserData(
      name: name,
      language: language,
      goal: goal,
    );
    // TODO: Persist to shared preferences or secure storage
  }

  void clearUserData() {
    state = const UserData();
    // TODO: Clear from storage
  }
}

/// Provider for user data
final userDataProvider = NotifierProvider<UserDataNotifier, UserData>(() {
  return UserDataNotifier();
});
