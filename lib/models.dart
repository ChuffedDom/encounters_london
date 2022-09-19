import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/cupertino.dart';

class VerificationData extends ChangeNotifier {
  String _verification_phrase = "";
  bool _verify_by_photo = true;
  Uint8List _webImage = Uint8List(8);
  bool _imageUploaded = false;
  String _imageUploadStatus = "something went wrong please try again";
  String _audio_file = "";
  String _redditUsername = "";
  String _description = "";

  String get verification_phrase => _verification_phrase;
  bool get verify_by_photo => _verify_by_photo;
  Uint8List get webImage => _webImage;
  bool get imageUploaded => _imageUploaded;
  String get imageUploadStatus => _imageUploadStatus;
  String get audio_file => _audio_file;
  String get redditUsername => _redditUsername;
  String get description => _description;

  set updateVerificationPhrase(String value) {
    _verification_phrase = value;
    notifyListeners();
  }

  set verify_by_photo(bool value) {
    _verify_by_photo = value;
    notifyListeners();
  }

  set updateWebImage(Uint8List value) {
    _webImage = value;
    notifyListeners();
  }

  set updateImageUploaded(bool value) {
    _imageUploaded = value;
    notifyListeners();
  }

  set updateImageUploadStatus(String value) {
    _imageUploadStatus = value;
    notifyListeners();
  }

  set updateAudioFile(String value) {
    _audio_file = value;
    notifyListeners();
  }

  set updateRedditUsername(String value) {
    _redditUsername = value;
    notifyListeners();
  }

  set updateDescription(String value) {
    _description = value;
    notifyListeners();
  }
}

class VerificationSubmission {
  final String redditUsername;
  final String uniquePhrase;
  final String description;
  bool verified;
  bool checked;
  bool verify_by_photo;

  VerificationSubmission({
    required this.redditUsername,
    required this.uniquePhrase,
    required this.description,
    this.verified = false,
    this.checked = false,
    this.verify_by_photo = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'redditUsername': redditUsername,
      'uniquePhrase': uniquePhrase,
      'description': description,
      'verified': verified,
      'checked': checked,
      'verify_by_photo': verify_by_photo,
    };
  }

  // TODO: create the from document, really
  VerificationSubmission.fromMap(Map<String, dynamic> verificationSubmissionMap)
      : redditUsername = verificationSubmissionMap["redditUsername"],
        uniquePhrase = verificationSubmissionMap["buildingName"],
        description = verificationSubmissionMap["cityName"],
        verified = verificationSubmissionMap["verified"],
        checked = verificationSubmissionMap["checked"],
        verify_by_photo = verificationSubmissionMap["verify_by_photo"];
}
