import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyCustomAppBar extends StatelessWidget implements PreferredSize {
  const MyCustomAppBar(
      {Key? key, required this.onSearchTap, required this.title})
      : super(key: key);

  final VoidCallback onSearchTap;
  final String title;


  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text(
        title,
        style: const TextStyle(fontSize: 20, color: Colors.black),
      ),
      elevation: 0,
      leading: InkWell(
        onTap: onSearchTap,
        child: const Icon(
          Icons.arrow_back,
          color: Colors.black,
          size: 35,
        ),
      ),
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFEEACF),
              Color.fromARGB(255, 248, 219, 185),
            ],
          ),
        ),
      ),
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: Color.fromARGB(255, 251, 224, 193),
      ),
    );
  }

  @override
  Widget get child => throw UnimplementedError();

  @override
  Size get preferredSize => const Size(double.infinity, 60);
}
