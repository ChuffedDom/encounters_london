import 'dart:js';

import 'package:encounters_london/models.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';

class TypeSelector extends StatelessWidget {
  const TypeSelector({Key? key}) : super(key: key);

  void threeRandomWords(BuildContext context) {
    Map<int, String> size = {
      1: "tiny",
      2: "small",
      3: "mini",
      4: "little",
      5: "compact",
      6: "big",
      7: "great",
      8: "huge",
      9: "massive",
      0: "sizeable",
    };

    Map<int, String> colour = {
      1: "red",
      2: "orange",
      3: "yellow",
      4: "green",
      5: "blue",
      6: "indigo",
      7: "violet",
      8: "white",
      9: "black",
      0: "purple",
    };

    Map<int, String> object = {
      1: "ballon",
      2: "car",
      3: "cup",
      4: "chair",
      5: "box",
      6: "coat",
      7: "ball",
      8: "bottle",
      9: "pen",
      0: "bag",
    };
    var rng = Random();

    String sizeWord = size[rng.nextInt(10)].toString();
    String colourWord = colour[rng.nextInt(10)].toString();
    String objectWord = object[rng.nextInt(10)].toString();

    var phrase = "$sizeWord $colourWord $objectWord";
    Provider.of<VerificationData>(context, listen: false)
        .updateVerificationPhrase = phrase;
  }

  @override
  Widget build(BuildContext context) {
    threeRandomWords(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Encounters London"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(45.0),
        child: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width > 400
                ? 400
                : MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height > 500
                ? 500
                : MediaQuery.of(context).size.height,
            child: Column(
              children: [
                // Top space to center
                Expanded(
                  flex: 1,
                  child: Container(),
                ),
                // Middle area for buttons
                Expanded(
                  flex: 6,
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/photo-select');
                          },
                          child: const Text("Verify with Photo"),
                        ),
                        const SizedBox(height: 30.0),
                        const Align(child: Text("or")),
                        const SizedBox(height: 30.0),
                        Consumer<VerificationData>(
                          builder: (context, verificationData, child) =>
                              Container(
                            child: Column(
                              children: [
                                ElevatedButton(
                                  onPressed: null,
                                  child: const Text("Verify with Voice"),
                                ),
                                Text(
                                  "coming soon",
                                  style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Bottom Navigation area
                Expanded(
                  flex: 1,
                  child: Container(
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("back"),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
