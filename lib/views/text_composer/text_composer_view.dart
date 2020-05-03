import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class TextComposerView extends StatefulWidget {

  final Function({String text, File imageFile}) sendMsgFirebase;
  
  TextComposerView({this.sendMsgFirebase});

  @override
  _TextComposerViewState createState() => _TextComposerViewState();
}

class _TextComposerViewState extends State<TextComposerView> {

  bool _isComposing = false;
  TextEditingController msgController = TextEditingController();

  void  _send({String text, File imageFile}){
    if(text != null){
      widget.sendMsgFirebase(text: text);
      msgController.clear();
      setState(() {
        _isComposing = msgController.text.isNotEmpty;
      });
    }else if(imageFile != null){
      widget.sendMsgFirebase(imageFile: imageFile);
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.photo_camera),
            onPressed: () async {
              final File imageFile = await ImagePicker.pickImage(source: ImageSource.camera);
              if(imageFile == null) return;
              _send(imageFile: imageFile);
            },
          ),
          Expanded(
            child: TextField(
              controller: msgController,
              decoration: InputDecoration.collapsed( //collapsed, achata o textfield
                hintText: "Type your message",
              ),
              onChanged: (text){
                setState(() {
                  _isComposing = text.isNotEmpty;
                });
              },
              onSubmitted: (text){
                _send(text: msgController.text);
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: _isComposing ? (){
              _send(text: msgController.text);
            } : null,
          ),
        ],
      ),
    );
  }
}