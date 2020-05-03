import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
// import model
import 'package:chat_flutter/models/chat_screen/chat_screen_model.dart';

class ChatScreenController {
  GoogleSignIn _googleSignIn = GoogleSignIn();
  FirebaseUser _currentUser;
  
  void getter(BuildContext context) {
    ChatScreenModel viewModel = Provider.of<ChatScreenModel>(context, listen: false);
    //TODO Add code here for getter
    viewModel.getter();
  }

  void setter(BuildContext context) {
    ChatScreenModel viewModel = Provider.of<ChatScreenModel>(context, listen: false);
    //TODO Add code here for setter
    viewModel.setter();
  }

  void update(BuildContext context) {
    ChatScreenModel viewModel = Provider.of<ChatScreenModel>(context, listen: false);
    //TODO Add code here for update
    viewModel.update();
  }

  void remove(BuildContext context) {
    ChatScreenModel viewModel = Provider.of<ChatScreenModel>(context, listen: false);
    //TODO Add code here for remove
    viewModel.remove();
  }

  GoogleSignIn getGoogleSignIn(){
    return _googleSignIn;
  }

  FirebaseUser getFirebaseUser(){
    return _currentUser;
  }

  FirebaseUser setFirebaseUser(FirebaseUser firebaseUser){
    return _currentUser = firebaseUser;
  }

  Future<FirebaseUser> getUser({currentUser}) async { 
  
    if(currentUser != null) return currentUser; //se já esta logado, retorna. se nao, loga

    try {
      final GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn(); //realiza o login e retorna a conta que foi utilizada

      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication; //recupera os tokens de autenticacao google do usuario, para que possa fazer a conexao com o firebase

      final AuthCredential credential = GoogleAuthProvider.getCredential( //cria a credencial necessaria para login com firebase
        idToken: googleSignInAuthentication.idToken, 
        accessToken: googleSignInAuthentication.accessToken
      ); //aqui foi usado o provider do google. mas poderia ser do face, linkedin, etc etc 

      final AuthResult authresult = await FirebaseAuth.instance.signInWithCredential(credential); //login no firebase com credencial externa. mas veja após o instance. as outras opcoes

      final FirebaseUser user = authresult.user; //recupera o usuario lá do no firebase

      return user;

    } catch (e) {
      print(e);
      return null;
    }
  }

}