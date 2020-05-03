import 'dart:ui' as prefix0;

import 'package:chat_flutter/views/chat_screen/chat_screen_view.dart';
import 'package:flutter/material.dart';

class ChatMessageView extends StatelessWidget {

  ChatMessageView(this.data, this.mine);

  final Map<String, dynamic> data;
  final bool mine;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Row(
        children: <Widget>[
          !mine 
            ?
            Padding(
              padding: EdgeInsets.only(right: 16),
              child: CircleAvatar(
                backgroundImage: NetworkImage(data['senderPhotoUrl']),
              ),
            )
          :
            Container(),
          Expanded(
            child: Column(
              crossAxisAlignment: mine ? CrossAxisAlignment.end :  CrossAxisAlignment.start,
              children: <Widget>[
                data['url'] != null 
                ?
                  Image.network(data["url"], width: 250,)
                :
                  Text(
                    data['text'],
                    textAlign: mine ? TextAlign.end :  TextAlign.start,
                    style: TextStyle(
                      fontSize: 16
                    ),
                  )
                ,
                Text(
                  data['senderName'],
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey
                  ),
                )
              ],
            ),
          ),
          mine 
            ?
            Padding(
              padding: EdgeInsets.only(left: 16),
              child: CircleAvatar(
                backgroundImage: NetworkImage(data['senderPhotoUrl']),
              ),
            )
          :
            Container(),
        ],
      ),
    );
        
  }
}