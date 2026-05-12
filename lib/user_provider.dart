import 'package:flutter/material.dart';
import 'Models/user_model.dart';

class UserProvider extends InheritedWidget {
  final UserModel? user;
  final void Function(UserModel) setUser;
  final VoidCallback logout;

  const UserProvider({
    super.key,
    required this.user,
    required this.setUser,
    required this.logout,
    required super.child,
  });

  // This allows any widget to access the user by calling UserProvider.of(context).user
  static UserProvider of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<UserProvider>();
    assert(provider != null, "UserProvider not found in widget tree. Make sure to wrap MaterialApp in UserStore.");
    return provider!;
  }

  @override
  bool updateShouldNotify(UserProvider oldWidget) {
    // Only notify listeners if the user data actually changes
    return oldWidget.user != user;
  }
}

class UserStore extends StatefulWidget {
  final Widget child;
  const UserStore({super.key, required this.child});

  @override
  State<UserStore> createState() => _UserStoreState();
}

class _UserStoreState extends State<UserStore> {
  UserModel? user;

  void setUser(UserModel newUser) {
    setState(() {
      user = newUser;
    });
  }

  void logout() {
    setState(() {
      user = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return UserProvider(
      user: user,
      setUser: setUser,
      logout: logout,
      child: widget.child,
    );
  }
}