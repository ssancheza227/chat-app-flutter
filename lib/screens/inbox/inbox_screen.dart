import 'package:chat_app/screens/inbox/components/chat_tile.dart';
import 'package:chat_app/screens/inbox/components/logout_button.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../chat/chat_screen.dart';

class InboxScreen extends StatefulWidget {
  final String email;
  const InboxScreen(this.email, {Key? key}) : super(key: key);

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inbox'),
        actions: const [LogoutButton()],
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('users').where('sender', isNotEqualTo: widget.email).snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return ListView.separated(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final String userEmail = snapshot.data!.docs[index]['sender'];
                  return ChatTile(
                    userEmail,
                    onTap: () {
                      Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChatScreen(userEmail, widget.email)),
                      );
                    },
                  );
                },
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 10),
                padding: const EdgeInsets.all(8.0),
              );
            }
          }),
    );
  }
}
