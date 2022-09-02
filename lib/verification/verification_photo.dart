import 'dart:typed_data';

import 'package:encounters_london/models.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class PhotoSelect extends StatelessWidget {
  const PhotoSelect({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ImagePicker picker = ImagePicker();
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
            height: MediaQuery.of(context).size.height > 500
                ? 500
                : MediaQuery.of(context).size.height,
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(),
                ),
                Expanded(
                  flex: 6,
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 2,
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Provide an image that:",
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    " • has your face included \n"
                                    " • is fully clothed \n"
                                    " • handwritten note saying:",
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Text(
                          Provider.of<VerificationData>(context)
                              .verification_phrase,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                            fontSize: 20.0,
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Consumer<VerificationData>(
                          builder: (context, verificationData, child) => Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                  onPressed: () async {
                                    final XFile? image = await picker.pickImage(
                                        source: ImageSource.gallery);
                                    if (image != null) {
                                      var f = await image.readAsBytes();
                                      verificationData.updateWebImage = f;
                                      Navigator.pushNamed(
                                          context, "/photo-upload");
                                    } else {
                                      print("No image picked");
                                    }
                                  },
                                  child: Text("Upload")),
                              SizedBox(
                                width: 20.0,
                              ),
                              ElevatedButton(
                                  onPressed: () async {
                                    final XFile? image = await picker.pickImage(
                                        source: ImageSource.camera);
                                    if (image != null) {
                                      var f = await image.readAsBytes();
                                      verificationData.updateWebImage = f;
                                      Navigator.pushNamed(
                                          context, "/photo-upload");
                                    } else {
                                      print("No image picked");
                                    }
                                  },
                                  child: Text("Take Photo")),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("back"),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PhotoUpload extends StatefulWidget {
  const PhotoUpload({Key? key}) : super(key: key);

  @override
  State<PhotoUpload> createState() => _PhotoUploadState();
}

class _PhotoUploadState extends State<PhotoUpload> {
  // Upload file on screen opening
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => uploadFile());
  }

  // Will upload the file in state to firebase
  Future<void> uploadFile() async {
    final verficationSchedule =
        Provider.of<VerificationData>(context, listen: false);
    try {
      var f = await FirebaseStorage.instance
          .ref("reddit-verification/")
          .child("${verficationSchedule.redditUsername}.png");
      f.putData(verficationSchedule.webImage).snapshotEvents.listen(
        (taskSnapshot) {
          switch (taskSnapshot.state) {
            case TaskState.running:
              verficationSchedule.updateImageUploadStatus = "uploading";
              break;
            case TaskState.paused:
              verficationSchedule.updateImageUploadStatus = "paused";
              break;
            case TaskState.success:
              verficationSchedule.updateImageUploaded = true;
              verficationSchedule.updateImageUploadStatus = "uploaded";
              break;
            case TaskState.canceled:
              verficationSchedule.updateImageUploadStatus = "cancelled";
              break;
            case TaskState.error:
              verficationSchedule.updateImageUploadStatus =
                  "something went wrong";
              break;
          }
        },
      );
    } catch (e) {
      print("did not upload");
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
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
            child: Consumer<VerificationData>(
              builder: (context, verificationData, child) => Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(),
                  ),
                  // Middle action area
                  Expanded(
                    flex: 6,
                    child: Container(
                      child: Column(
                        children: [
                          Expanded(
                            flex: 7,
                            child: Container(
                              child: Center(
                                child: verificationData.imageUploaded
                                    ? SizedBox.shrink()
                                    : CircularProgressIndicator(),
                              ),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.fitHeight,
                                  colorFilter: ColorFilter.mode(
                                    Colors.black.withOpacity(
                                        verificationData.imageUploaded
                                            ? 1
                                            : 0.5),
                                    BlendMode.dstATop,
                                  ),
                                  image: MemoryImage(verificationData.webImage),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              alignment: Alignment.center,
                              child: Text(verificationData.imageUploadStatus),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Bottom navigation area
                  Expanded(
                    flex: 1,
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              verificationData.updateWebImage = Uint8List(8);
                              verificationData.updateImageUploaded = false;
                              Navigator.pop(context);
                            },
                            child: Text("back"),
                          ),
                          ElevatedButton(
                            onPressed: verificationData.imageUploaded
                                ? () {
                                    Navigator.pushNamed(
                                        context, '/description');
                                  }
                                : null,
                            child: Text("Next"),
                          ),
                        ],
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
