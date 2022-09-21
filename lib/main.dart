import 'package:encounters_london/verification/verification_audio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'models.dart';
import 'verification/reddit_username.dart';
import 'verification/verification_type.dart';
import 'verification/verification_photo.dart';
import 'verification/verification_completion.dart';
import 'homepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<VerificationData>(
      create: (context) => VerificationData(),
      child: MaterialApp(
        title: 'Encounters London',
        theme: ThemeData(
          fontFamily: '--apple-system',
          primarySwatch: Colors.red,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => Homepage(),
          '/reddit-username': (context) => const EnterUsername(),
          '/verification-type': (context) => TypeSelector(),
          '/photo-select': (context) => PhotoSelect(),
          '/photo-upload': (context) => PhotoUpload(),
          '/audio-record': (context) => AudioRecord(
                onStop: (path) {
                  if (kDebugMode) print('Recorded file path: $path');
                },
              ),
          '/audio-upload': (context) => AudioUpload(),
          '/description': (context) => Description(),
          '/completed': (context) => Completed(),
        },
      ),
    );
  }
}
