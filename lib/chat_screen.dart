import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:trip_swift/chat_interface_screen.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _generateChatId(String email1, String email2) {
    final emails = [email1, email2]..sort(); // Sort emails to ensure consistent hash
    return sha256.convert(utf8.encode(emails.join('_'))).toString();
  }

  void _addFriend() {
    TextEditingController friendController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Friend'),
        content: TextField(
          controller: friendController,
          decoration: const InputDecoration(hintText: 'Enter friend\'s email'),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              if (friendController.text.isNotEmpty) {
                String friendEmail = friendController.text.trim();
                final prefs = await SharedPreferences.getInstance();
                final String currentUserEmail = prefs.getString('currentUserEmail')??""; // Replace with the actual user's email

                // Check if the friend email exists in Firestore
                var userSnapshot = await FirebaseFirestore.instance
                    .collection('users').where('email', isEqualTo: friendEmail) // Filter by email field
                    .get();

                if (userSnapshot != Null) {
                  print('friend exists ! trying to create chat');
                  String chatId = _generateChatId(currentUserEmail, friendEmail);

                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(currentUserEmail)
                      .update({
                    'friends': FieldValue.arrayUnion([friendEmail])
                  });

                  final chatDocRef = FirebaseFirestore.instance.collection('chats').doc(chatId);
                  final chatDocSnapshot = await chatDocRef.get();

                  if (!chatDocSnapshot.exists) {
                    await chatDocRef.set({
                      'users': [currentUserEmail, friendEmail],
                      'messages': [],
                      'lastMessage': null,
                      'timestamp': FieldValue.serverTimestamp(),
                    });
                  }
                  print('Created chat successfully');

                  Navigator.pop(context);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatInterfaceScreen(chatId: chatId),
                    ),
                  );
                } else {
                  print('cant create  chat successfully');
                  Navigator.pop(context); // Close the dialog
                  // Show an error if the email does not exist
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Email does not exist!')),
                  );
                }
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _createGroup() {
    TextEditingController groupController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Group'),
        content: TextField(
          controller: groupController,
          decoration: const InputDecoration(hintText: 'Enter group name'),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              if (groupController.text.isNotEmpty) {
                String groupName = groupController.text.trim();

                await FirebaseFirestore.instance.collection('groups').add({
                  'name': groupName,
                  'members': ['CURRENT_USER_ID'], // Replace with actual user ID
                });

                Navigator.pop(context);
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Friends'),
            Tab(text: 'Group Chats'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          const FriendsTab(),
          const GroupChatsTab(),
        ],
      ),
      floatingActionButton: PopupMenuButton<String>(
        onSelected: (value) {
          if (value == 'Add Friend') {
            _addFriend();
          } else if (value == 'Create Group') {
            _createGroup();
          }
        },
        itemBuilder: (context) => [
          const PopupMenuItem(
            value: 'Add Friend',
            child: Text('Add Friend'),
          ),
          const PopupMenuItem(
            value: 'Create Group',
            child: Text('Create Group'),
          ),
        ],
        child: const Icon(Icons.add),
      ),
    );
  }
}

class FriendsTab extends StatefulWidget {
  const FriendsTab({super.key});

  @override
  State<FriendsTab> createState() => _FriendsTabState();
}

class _FriendsTabState extends State<FriendsTab> {
  late String currentUserEmail;

  @override
  void initState() {
    super.initState();
    _fetchCurrentUserEmail();
  }

  void _fetchCurrentUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      currentUserEmail = prefs.getString('currentUserEmail') ?? "";
    });
  }

  String _generateChatId(String email1, String email2) {
    final emails = [email1, email2]..sort();
    return '${emails[0]}_${emails[1]}';
  }

  Future<void> _startChat(String friendEmail) async {
    if (friendEmail.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Friend email cannot be empty.')),
      );
      return;
    }

    // Check if the friend email exists
    var friendSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(friendEmail)
        .get();

    if (!friendSnapshot.exists) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Friend email does not exist.')),
      );
      return;
    }

    // Generate chat ID
    String chatId = _generateChatId(currentUserEmail, friendEmail);

    // Check if chat already exists
    var chatSnapshot = await FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .get();

    if (!chatSnapshot.exists) {
      // If chat does not exist, create a new one
      await FirebaseFirestore.instance.collection('chats').doc(chatId).set({
        'users': [currentUserEmail, friendEmail],
        'messages': [],
        'lastMessage': null,
        'timestamp': FieldValue.serverTimestamp(),
      });
    }

    // Navigate to the chat interface
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatInterfaceScreen(chatId: chatId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return currentUserEmail.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('chats')
          .where('users', arrayContains: currentUserEmail)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final chats = snapshot.data!.docs;

        if (chats.isEmpty) {
          return const Center(
            child: Text('No chats available. Start by adding a friend!'),
          );
        }

        return ListView.builder(
          itemCount: chats.length,
          itemBuilder: (context, index) {
            final chat = chats[index];
            final users = chat['users'] as List;
            String friendEmail = users.firstWhere(
                  (user) => user != currentUserEmail,
            );

            return ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.blue,
                child: Icon(Icons.person),
              ),
              title: Text(friendEmail),
              subtitle: const Text('Last message preview...'),
              onTap: () => _startChat(friendEmail),
            );
          },
        );
      },
    );
  }
}



class GroupChatsTab extends StatelessWidget {
  const GroupChatsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance.collection('groups').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final groups = snapshot.data!.docs;

        return ListView.builder(
          itemCount: groups.length,
          itemBuilder: (context, index) {
            final group = groups[index];
            return ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.green,
                child: Icon(Icons.group),
              ),
              title: Text(group.get('name')),
              subtitle: const Text('Last group message preview...'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatInterfaceScreen(chatId: group.id),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
