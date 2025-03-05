import 'package:flutter/material.dart';
import 'package:portal/model/categoriesList.dart';

import 'package:portal/pages/authpage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CategoriesList(),
      builder: (context, child) => const MaterialApp(
        home: Authpage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
