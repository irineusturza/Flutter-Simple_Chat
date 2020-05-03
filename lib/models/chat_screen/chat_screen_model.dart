import 'package:flutter/material.dart';

enum ChatScreenModelStatus {
  Ended,
  Loading,
  Error,
}

class ChatScreenModel extends ChangeNotifier {
  ChatScreenModelStatus _status;
  String _errorCode;
  String _errorMessage;

  String get errorCode => _errorCode;
  String get errorMessage => _errorMessage;
  ChatScreenModelStatus get status => _status;

  ChatScreenModel();

  ChatScreenModel.instance() {
    //TODO Add code here
  }
  
  void getter() {
    _status = ChatScreenModelStatus.Loading;
    notifyListeners();

    //TODO Add code here

    _status = ChatScreenModelStatus.Ended;
    notifyListeners();
  }

  void setter() {
    _status = ChatScreenModelStatus.Loading;
    notifyListeners();

    //TODO Add code here
    
    _status = ChatScreenModelStatus.Ended;
    notifyListeners();
  }

  void update() {
    _status = ChatScreenModelStatus.Loading;
    notifyListeners();

    //TODO Add code here
    
    _status = ChatScreenModelStatus.Ended;
    notifyListeners();
  }

  void remove() {
    _status = ChatScreenModelStatus.Loading;
    notifyListeners();

    //TODO Add code here
    
    _status = ChatScreenModelStatus.Ended;
    notifyListeners();
  }
}