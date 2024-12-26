import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'chat_interface_screen.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

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
        children: const [
          FriendsTab(),
          GroupChatsTab(),
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
  String _generateChatId(String currentUserEmail, String friendEmail){
    List<String> emails = [currentUserEmail, friendEmail]..sort();
    return '${emails[0]}-${emails[1]}';
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
                final String currentUserEmail =
                    prefs.getString('currentUserEmail') ?? "";

                // Generate chat ID in sorted order
                String chatId = _generateChatId(currentUserEmail, friendEmail);

                // Check if friend exists
                var userSnapshot = await FirebaseFirestore.instance
                    .collection('users')
                    .where('email', isEqualTo: friendEmail)
                    .get();

                if (userSnapshot.docs.isNotEmpty) {
                  // Check if the chat already exists
                  var chatDoc = await FirebaseFirestore.instance
                      .collection('chats')
                      .doc(chatId)
                      .get();

                  if (!chatDoc.exists) {
                    // Create new chat
                    await FirebaseFirestore.instance
                        .collection('chats')
                        .doc(chatId)
                        .set({
                      'users': [currentUserEmail, friendEmail],
                      'messages': [],
                      'lastMessage': null,
                      'timestamp': FieldValue.serverTimestamp(),
                    });
                  }

                  Navigator.pop(context);

                  // Navigate to chat interface
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatInterfaceScreen(chatId: chatId),
                    ),
                  );
                } else {
                  // Show error if the email does not exist
                  Navigator.pop(context);
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
              String groupName = groupController.text.trim();

              if (groupName.isEmpty) {
                // Show error if the group name is empty
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Group name cannot be empty.')),
                );
                return;
              }

              try {
                // Retrieve current user email
                final prefs = await SharedPreferences.getInstance();
                final String currentUserEmail =
                    prefs.getString('currentUserEmail') ?? "";

                if (currentUserEmail.isEmpty) {
                  throw Exception('Failed to fetch current user email.');
                }

                // Generate unique group ID
                DocumentReference groupRef =
                FirebaseFirestore.instance.collection('groups').doc();

                // Create group entry
                await groupRef.set({
                  'id': groupRef.id,
                  'groupName': groupName,
                  'isGroup': true,
                  'users': [currentUserEmail], // Members list
                  'timestamp': FieldValue.serverTimestamp(),
                });

                Navigator.pop(context); // Close the dialog

                // Navigate to group chat interface
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatInterfaceScreen(
                      chatId: groupRef.id, // Pass the group ID
                      isGroup: true,
                    ),
                  ),
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Group created successfully!')),
                );
              } catch (e) {
                Navigator.pop(context); // Ensure the dialog closes even on error
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to create group: $e')),
                );
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}

class FriendsTab extends StatefulWidget {
  const FriendsTab({Key? key}) : super(key: key);

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
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatInterfaceScreen(chatId: chat.id),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class GroupChatsTab extends StatefulWidget {
  const GroupChatsTab({Key? key}) : super(key: key);

  @override
  State<GroupChatsTab> createState() => _GroupChatsTabState();
}

class _GroupChatsTabState extends State<GroupChatsTab> {
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

  @override
  Widget build(BuildContext context) {
    return currentUserEmail.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('groups')
          .where('users', arrayContains: currentUserEmail)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final chats = snapshot.data!.docs;

        if (chats.isEmpty) {
          return const Center(
            child: Text('No group chats available. Start by creating one!'),
          );
        }

        return ListView.builder(
          itemCount: chats.length,
          itemBuilder: (context, index) {
            final chat = chats[index];

            return ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.green,
                child: Icon(Icons.group),
              ),
              title: Text(chat['groupName'] ?? 'Unnamed Group'),
              subtitle: const Text('Last message preview...'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatInterfaceScreen(
                    chatId: chat.id,
                    isGroup: true,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
