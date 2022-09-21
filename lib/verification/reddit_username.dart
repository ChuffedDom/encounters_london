import 'package:flutter/material.dart';
import 'package:encounters_london/models.dart';
import 'package:provider/provider.dart';

class EnterUsername extends StatefulWidget {
  const EnterUsername({Key? key}) : super(key: key);

  @override
  State<EnterUsername> createState() => _EnterUsernameState();
}

class _EnterUsernameState extends State<EnterUsername> {
  late TextEditingController _usernameController;
  String _versionNumber = "";

  @override
  void initState() {
    final verificationData =
        Provider.of<VerificationData>(context, listen: false);
    super.initState();
    _usernameController =
        TextEditingController(text: verificationData.redditUsername);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Encounters London"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(45.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width > 400
                ? 400
                : MediaQuery.of(context).size.width,
            child: Consumer<VerificationData>(
              builder: (context, verificationData, child) =>
                  SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.transparent,
                            shadowColor: Colors.transparent,
                          ),
                          onPressed: () => setState(() {
                            _versionNumber = "v0.11";
                          }),
                          child: Text(""),
                        ),
                        Text(_versionNumber),
                      ],
                    ),
                    Text(
                      "Verification for LR4R",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(
                      height: 50.0,
                    ),
                    TextFormField(
                      onFieldSubmitted: (value) {
                        Navigator.pushNamed(context, '/verification-type');
                      },
                      controller: _usernameController,
                      onChanged: (value) {
                        verificationData.updateRedditUsername = value;
                      },

                      // autofocus: true,
                      decoration: const InputDecoration(
                        prefixText: "u/",
                        labelText: "Reddit username",
                        helperText: "enter username exactly",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(
                      height: 50.0,
                    ),
                    Align(
                      child: ElevatedButton(
                        onPressed: verificationData.redditUsername != ""
                            ? () {
                                Navigator.pushNamed(
                                    context, '/verification-type');
                              }
                            : null,
                        child: const Text("Next"),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
