import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:email_validator/email_validator.dart';
import 'package:http/http.dart' as http;

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final _emailController = TextEditingController();
  var _buttonIndicator = Text("SUBSCRIBE");

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        textTheme: GoogleFonts.latoTextTheme(Theme.of(context).textTheme),
        fontFamily: '--apple-system',
        primarySwatch: Colors.red,
      ),
      child: Scaffold(
        body: ListView(
          children: [
            Container(
              height: MediaQuery.of(context).size.height - 20,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  colorFilter: ColorFilter.mode(
                      const Color.fromARGB(255, 13, 11, 11).withOpacity(0.6),
                      BlendMode.darken),
                  image: const NetworkImage(
                      "https://images.unsplash.com/photo-1542338347-4fff3276af78?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Encounters London",
                          style: GoogleFonts.abrilFatface(
                            fontSize: 40.0,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        const SizedBox(
                          width: 140.0,
                          child: Divider(
                            color: Colors.red,
                            thickness: 10.0,
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        const Text(
                          "A place for meeting other like-minded people in London for mutual and consensual encounters.",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        Text(
                          "Add your email to be updated on progress and launch. Everyone signing up today will be allocated a Founders account for perks and privileges when we go live.",
                          style: GoogleFonts.lato(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w300),
                        ),
                        const SizedBox(height: 20.0),
                        Container(
                          color: Colors.white,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: TextField(
                                  controller: _emailController,
                                  decoration: const InputDecoration(
                                    label: Text("email"),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: ElevatedButton(
                                  onPressed: () async {
                                    print("start request");
                                    var url = Uri.https(
                                        'chuffeddom:mindthegapHgotn44B\$newton@marketing.chuffed.app',
                                        'api/contacts/new');
                                    print("url set: $url");
                                    Map<String, String> headers = {
                                      "Content-Type": "application/json"
                                    };
                                    print("headers set");
                                    var response = await http.post(url,
                                        body: jsonEncode({
                                          "email": "dev01@test.com",
                                          "tags": "el-landing",
                                        }),
                                        headers: headers);
                                    print("post request made");
                                    print(
                                        'Response status: ${response.statusCode}');
                                    print('Response body: ${response.body}');
                                  },
                                  child: _buttonIndicator,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            MediaQuery.of(context).size.width > 700
                ? Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Expanded(
                          child: BenefitElement(
                        title: 'Confidence',
                        benefitIcon: Icons.handshake_outlined,
                        body:
                            'A community that only accepts those looking to meet',
                      )),
                      Expanded(
                          child: BenefitElement(
                        title: 'Anonymity',
                        benefitIcon: Icons.theater_comedy_outlined,
                        body:
                            'Keeping your identity safe by always using pseudonyms and minimal unshared personal information',
                      )),
                      Expanded(
                          child: BenefitElement(
                        title: 'Validity',
                        benefitIcon: Icons.thumb_up_alt_outlined,
                        body:
                            'Verification first approach to ensure the people you talk to are who they say they are',
                      )),
                    ],
                  )
                : Column(
                    children: const [
                      BenefitElement(
                        title: 'Confidence',
                        benefitIcon: Icons.handshake_outlined,
                        body:
                            'A community that only accepts those looking to meet',
                      ),
                      BenefitElement(
                        title: 'Anonymity',
                        benefitIcon: Icons.theater_comedy_outlined,
                        body:
                            'Keeping your identity safe by always using pseudonyms and minimal unshared personal information',
                      ),
                      BenefitElement(
                        title: 'Validity',
                        benefitIcon: Icons.thumb_up_alt_outlined,
                        body:
                            'Verification first approach to ensure the people you talk to are who they say they are',
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}

class BenefitElement extends StatelessWidget {
  final String title;
  final String body;
  final IconData benefitIcon;
  const BenefitElement(
      {Key? key,
      required this.title,
      required this.body,
      required this.benefitIcon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(45.0),
      child: Column(
        children: [
          Icon(
            benefitIcon,
            size: 60.0,
            color: Colors.red,
          ),
          const SizedBox(
            height: 20.0,
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 30.0,
              color: Colors.red,
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          Text(
            body,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16.0,
              color: Color.fromARGB(255, 49, 49, 49),
            ),
          )
        ],
      ),
    );
  }
}
