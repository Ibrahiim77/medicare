import 'package:flutter/material.dart';

PreferredSizeWidget myAppBar() {
  return AppBar(
    title: Text("MediCare",
    style: TextStyle(fontWeight: .bold),),
    backgroundColor: Colors.blue,
    automaticallyImplyLeading: false,
    centerTitle: true,
  );
}