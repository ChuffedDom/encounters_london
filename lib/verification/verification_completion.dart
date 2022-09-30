import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encounters_london/models.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart';

class Description extends StatefulWidget {
  const Description({Key? key}) : super(key: key);

  @override
  State<Description> createState() => _DescriptionState();
}

class _DescriptionState extends State<Description> {
  late TextEditingController _descriptionController = TextEditingController();

  FirebaseFirestore db = FirebaseFirestore.instance;

  double heightUnit = 0.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final verificationData =
          Provider.of<VerificationData>(context, listen: false);

      _descriptionController =
          TextEditingController(text: verificationData.description);
    });
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(
      title: const Text("Encounters London"),
    );
    db = FirebaseFirestore.instance;

    double heightUnit = MediaQuery.of(context).size.height / 12;

    return Scaffold(
      appBar: appBar,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(45.0, 0, 45.0, 0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width > 400
                ? 400
                : MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height > 500
                ? 500
                : MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Spacing at the top
                  Flexible(
                    flex: 2,
                    child: Container(
                        //height: heightUnit * 2,
                        ),
                  ),
                  // Text to instruct
                  Flexible(
                    flex: 1,
                    child: Container(
                      //height: heightUnit * 1,
                      child: const Text(
                        "Write a short description of yourself",
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ),
                  // Textarea box
                  Flexible(
                    flex: 4,
                    child: Container(
                      //height: heightUnit * 4,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                        child: TextField(
                          controller: _descriptionController,
                          maxLines: 8,
                          decoration: InputDecoration(
                            hintText: "e.g.\nHeight: \nBuild: \nAppearance:",
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            Provider.of<VerificationData>(context,
                                    listen: false)
                                .updateDescription = value;
                          },
                        ),
                      ),
                    ),
                  ),

                  // Finish form button
                  Flexible(
                    flex: 2,
                    child: Container(
                      //height: heightUnit * 2,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed: () async {
                            var vData = Provider.of<VerificationData>(context,
                                listen: false);
                            print(vData.verify_by_photo);
                            VerificationSubmission submission =
                                VerificationSubmission(
                              redditUsername: vData.redditUsername,
                              description: vData.description,
                              uniquePhrase: vData.verification_phrase,
                              verify_by_photo: true,
                            );
                            Future<DocumentReference<Map<String, dynamic>>>
                                newDoc = db
                                    .collection("reddit-verification")
                                    .add(submission.toMap());

                            newDoc.whenComplete(() {
                              Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  "/completed",
                                  (Route<dynamic> route) => false);
                            });
                          },
                          child: Text("Finish"),
                        ),
                      ),
                    ),
                  ),
                  // Back to image/audio
                  Flexible(
                    flex: 3,
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      //height: heightUnit * 3,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(
                              context, "/photo-select", (route) => false);
                        },
                        child: Text("retake photo"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Completed extends StatefulWidget {
  const Completed({Key? key}) : super(key: key);

  @override
  State<Completed> createState() => _CompletedState();
}

class _CompletedState extends State<Completed> {
  Future<void> sendNotification() async {
    final pushover_user = "uhpBm9iM6FNdok32ywzhJR3BWjMDuT";
    final pushover_token = "ajcnxxkcmz5qnmq6d3qncm73774f58";
    final url = Uri.parse('https://api.pushover.net/1/messages.json');
    var headers = {'Content-Type': 'application/json'};
    final data = {
      "token": "$pushover_token",
      "user": "$pushover_user",
      "message": "New Verification to check",
      "sound": "gamelan"
    };

    final json = jsonEncode(data);
    final response = await post(url, headers: headers, body: json);
  }

  @override
  void initState() {
    sendNotification();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Encounter London"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(45.0),
        child: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width > 400
                ? 400
                : MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height > 1000
                ? 1000
                : MediaQuery.of(context).size.height,
            child: Column(
              children: [
                Text(
                  "Verification Completed",
                  style: Theme.of(context).textTheme.headline5,
                ),
                const SizedBox(height: 20),
                const Text(
                    "Thanks for verifying, it really helps the community succeed."),
                const SizedBox(height: 20),
                const Text(
                    "A moderator will be in touch to confirm that your verification was successful."),
                const SizedBox(height: 30),
                const Text("We are building something new for meets in London"),
                const SizedBox(height: 20),
                const Text("Find out more"),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/');
                  },
                  child: const Text("CLICK HERE"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
