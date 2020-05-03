import 'dart:io';

import 'package:chat_flutter/views/chat_message/chat_message_view.dart';
import 'package:chat_flutter/views/text_composer/text_composer_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import model
import 'package:chat_flutter/models/chat_screen/chat_screen_model.dart';
// import controller
import 'package:chat_flutter/controllers/chat_screen/chat_screen_controller.dart';

class ChatScreenView extends StatefulWidget {

  @override
  ChatScreenViewState createState() => ChatScreenViewState();
}

class ChatScreenViewState extends State<ChatScreenView> {
  ChatScreenController viewController = ChatScreenController();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  

  bool _isloading = false;

  @override
  void initState(){
    super.initState();

    FirebaseAuth.instance.onAuthStateChanged.listen((user){ //escuta a stream e se tiver alguma mudanca, muda a variavel local
      setState(() {
        viewController.setFirebaseUser(user);
      });
    });
    
  }

  void _sendMsgFirebase({String text, File imageFile}) async { //envia msg/img ao firebase/firestore

    final FirebaseUser user = await viewController.getUser(currentUser: viewController.getFirebaseUser()); // recupera o usuario logado ou novo login

    if(user == null){
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text("Login failed, please try again!"),
          backgroundColor: Colors.red,
        )
      );
      return;
    }

    setState(() {
      _isloading = true;
    });

    Map<String, dynamic> msgData = {
      "uid": user.uid,
      "senderName": user.displayName,
      "senderPhotoUrl": user.photoUrl,
      "time": Timestamp.now()
    };

    if(text != null) msgData["text"] = text; //se recebeu texto, popula
    
    if(imageFile != null) { //se recebeu imagem. upload, e popula
      StorageUploadTask task = FirebaseStorage.instance.ref().child("imgs").child( //up da imagem, com nome e na pasta "imgs"
        user.uid + DateTime.now().millisecondsSinceEpoch.toString()
      ).putFile(imageFile);

      StorageTaskSnapshot taskSnapshot = await task.onComplete; // executa
      String url = await taskSnapshot.ref.getDownloadURL(); //recupera a url do arquivo no storage
      msgData["url"] = url; //popula

    }

    Firestore.instance.collection("chat_messages").add(msgData); //registra no bd

    setState(() {
      _isloading = false;
    });

  }

  @override
  Widget build(BuildContext context) {
    
    return ChangeNotifierProvider<ChatScreenModel>(
      create: (context) => ChatScreenModel.instance(),
      child: Consumer<ChatScreenModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              title: viewController.getFirebaseUser() != null 
                ? 
                  Text("Hi ${viewController.getFirebaseUser().displayName}")
                :
                  Text("Chat App")
                ,
              elevation: 0,
              actions: <Widget>[
                viewController.getFirebaseUser() != null
                  ?
                  IconButton(
                    icon: Icon(Icons.exit_to_app),
                    onPressed: () async {
                      await viewController.getGoogleSignIn().signOut().then((r){
                        print(r);
                        print("terminou o logout");
                      });
                      print(viewController.getGoogleSignIn().currentUser?.displayName);
                      await FirebaseAuth.instance.signOut();
                      
                      _scaffoldKey.currentState.showSnackBar(
                        SnackBar(
                          content: Text("You successfully logged out"),
                        )
                      );
                    },
                  )
                  :
                  Container()
                  ,
              ],
            ),
            body: Column(
              children: <Widget>[
                Expanded(
                  child: StreamBuilder(
                     stream: Firestore.instance.collection("chat_messages").orderBy("time").snapshots(),
                     builder: (context, snapshot){
                       switch(snapshot.connectionState){
                         case ConnectionState.none:
                         case ConnectionState.waiting:
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                         default:
                          List<DocumentSnapshot> documents = snapshot.data.documents.reversed.toList();

                          return ListView.builder( //vai montando a lista conforme rola a tela
                            itemCount: documents.length,
                            reverse: true,
                            itemBuilder: (context, index){ //monta um widget para cada item do snapshot
                              return ChatMessageView(
                                documents[index].data,
                                documents[index].data["uid"] == viewController.getFirebaseUser()?.uid
                              );
                            }
                          );
                       }
                     },
                  ),
                ),
                _isloading
                  ?
                  LinearProgressIndicator()
                  :
                  TextComposerView(
                    sendMsgFirebase: _sendMsgFirebase
                  )
                  ,
              ],
            ),
          );
        },
      ),
    );
  }
}