import 'package:chat_app/screens/chat/components/message_box.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MessageStream extends StatefulWidget {
  final String sender;
  final String destination;
  const MessageStream(this.sender, this.destination, {Key? key})
      : super(key: key);

  @override
  State<MessageStream> createState() => _MessageStreamState();
}

class _MessageStreamState extends State<MessageStream> {
  final _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('messages')
          .where('sender', isEqualTo: widget.sender)
          .where('destination', isEqualTo: widget.destination)
          .orderBy('dateTime')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final messages = snapshot.data!.docs.reversed;

        List<MessageBox> messageBoxes = [];
        for (var message in messages) {
          final msg = message.data() as Map<String, dynamic>;
          final sender = msg['sender'];
          final destination = msg['destination'];
          final text = msg['text'];
          final originalSender = msg['originalSender'];

          print('sender');
          print(sender);
          print('destination');
          print(destination);
          print('originalSender');
          print(originalSender);

          final messageBox = MessageBox(
            sender: originalSender,
            destination: destination,
            text: text,
            isMe: widget.sender == originalSender,
          );
          messageBoxes.add(messageBox);
        }
        return ListView(
          reverse: true,
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
          children: messageBoxes,
        );
      },
    );
  }
}
