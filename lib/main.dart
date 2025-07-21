import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mdm/MDM-Admin/enhanced_send_command_screen.dart';
import 'package:mdm/MDM-Admin/refactored_send_command_screen.dart';
import 'package:mdm/home.dart';
import 'package:mdm/screens/home_screen.dart';

void main() async {
   WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        //colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        fontFamily: 'Cairo',
      ),
      title: 'MDM Admin',
     // home: HomeScreen(),
     // home:RefactoredSendCommandScreen()
     home: EnhancedDeviceManagementScreen()
    );
  }
}





