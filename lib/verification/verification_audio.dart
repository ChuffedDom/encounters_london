import 'dart:async';
import 'dart:html';

import 'package:encounters_london/models.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:record/record.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AudioRecord extends StatefulWidget {
  final void Function(String path) onStop;
  const AudioRecord({Key? key, required this.onStop}) : super(key: key);

  @override
  State<AudioRecord> createState() => _AudioRecordState();
}

class _AudioRecordState extends State<AudioRecord> {
  bool _isRecording = false;
  final _audioRecorder = Record();

  Future<void> _start() async {
    try {
      await _audioRecorder.start();

      bool isRecording = await _audioRecorder.isRecording();
      setState(() {
        _isRecording = isRecording;
      });
    } on Exception catch (e) {
      print(e);
    }
  }

  Future<void> _stop() async {
    final path = await _audioRecorder.stop();

    widget.onStop(path!);
    Provider.of<VerificationData>(context, listen: false).updateAudioFile =
        path;
    Navigator.pushNamed(context, "/audio-upload");
    setState(() => _isRecording = false);
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
          child: Column(
            children: [
              Expanded(
                child: Container(
                  height: 20,
                  child: ElevatedButton(
                    onPressed: () async {
                      final isSupported = await _audioRecorder
                          .isEncoderSupported(AudioEncoder.pcm16bit);
                      print(
                          '${AudioEncoder.pcm16bit.name} supported: $isSupported');
                    },
                    child: Text("Print stats"),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Text("Record your voice saying:"),
                      const Text("BIG PURPLE BALLON"),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: IconButton(
                  icon: _isRecording ? Icon(Icons.stop) : Icon(Icons.mic),
                  onPressed: () {
                    _isRecording ? _stop() : _start();
                  },
                ),
              ),
              Expanded(
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AudioUpload extends StatefulWidget {
  const AudioUpload({Key? key}) : super(key: key);

  @override
  State<AudioUpload> createState() => _AudioUploadState();
}

class _AudioUploadState extends State<AudioUpload> {
  bool _uploaded = false;
  late AssetsAudioPlayer _assetsAudioPlayer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => uploadFile());
    _assetsAudioPlayer = AssetsAudioPlayer.newPlayer();
    openPlayer();
  }

  void openPlayer() async {
    var audioBlob =
        Provider.of<VerificationData>(context, listen: false).audio_file;
    await _assetsAudioPlayer.open(
      Audio.network(audioBlob),
      autoStart: true,
    );
  }

  // Will upload the file in state to firebase
  Future<void> uploadFile() async {
    final verficationSchedule =
        Provider.of<VerificationData>(context, listen: false);
    try {
      var f = await FirebaseStorage.instance
          .ref("reddit-verification/")
          .child("${verficationSchedule.redditUsername}.wav");
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
        title: const Text("Encounter London"),
      ),
      body: Padding(
        padding: EdgeInsets.all(45.0),
        child: Center(
          child: Column(children: [
            Expanded(
              child: Column(
                children: [
                  Text("Uploaded"),
                  Switch(
                    value: _uploaded,
                    onChanged: (value) {
                      setState(() {
                        _uploaded = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(children: [
                SizedBox(height: 20.0),
                _uploaded
                    ? IconButton(
                        icon: _assetsAudioPlayer.isPlaying.value
                            ? Icon(Icons.pause)
                            : Icon(Icons.restart_alt),
                        onPressed: () {
                          if (_assetsAudioPlayer.isPlaying.value) {
                            _assetsAudioPlayer.pause();
                          } else {
                            _assetsAudioPlayer.seek(Duration(seconds: 0));
                            _assetsAudioPlayer.play();
                          }
                        },
                      )
                    : CircularProgressIndicator(),
                SizedBox(height: 20.0),
                _uploaded ? Text("Uploaded") : Text("Uploading..."),
              ]),
            ),
            Expanded(
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: Text("back"),
                    ),
                    ElevatedButton(onPressed: () {}, child: Text("Next")),
                  ],
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
