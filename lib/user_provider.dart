import 'package:flutter/material.dart';

class UserData {
  final String username;
  final String email;
  final String password;

  UserData({
    required this.username,
    required this.email,
    required this.password,
  });

  UserData copyWith({
    String? username,
    String? email,
    String? password,
  }) {
    return UserData(
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }
}

class UserProvider extends InheritedWidget {
  final UserData? user;
  final void Function(UserData) registerUser;
  final void Function(String, String, String) updateUser;

  const UserProvider({
    super.key,
    required this.user,
    required this.registerUser,
    required this.updateUser,
    required super.child,
  });

  static UserProvider of(BuildContext context) {
    final provider =
    context.dependOnInheritedWidgetOfExactType<UserProvider>();
    assert(provider != null, 'No UserProvider found in widget tree');
    return provider!;
  }

  @override
  bool updateShouldNotify(UserProvider oldWidget) => user != oldWidget.user;
}

class UserStore extends StatefulWidget {
  final Widget child;
  const UserStore({super.key, required this.child});

  @override
  State<UserStore> createState() => _UserStoreState();
}

class _UserStoreState extends State<UserStore> {
  UserData? _user;

  void _register(UserData user) {
    setState(() => _user = user);
  }

  void _update(String username, String email, String password) {
    setState(() {
      _user = _user?.copyWith(
        username: username,
        email: email,
        password: password,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return UserProvider(
      user: _user,
      registerUser: _register,
      updateUser: _update,
      child: widget.child,
    );
  }
}