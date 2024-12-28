import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trip_swift/login_screen.dart';
import 'firebaseServices/users.dart';
import 'sharedPreferences/userid.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic> userData = {
    'name': '',
    'email': '',
    'phoneNo': '',
    'age': '',
    'imageUrl': '',
    'gender': '',
    'userId': '',
    'status': '',
    'likedLocations': [],
  };
  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    String? userId = await getUserId();
    if (userId != null) {
      DocumentSnapshot<Object?> profileData = await getProfile(userId);
      setState(() {
        var data = profileData.data() as Map<String, dynamic>;
        userData = {
          'name': data['name'] ?? '',
          'email': data['email'] ?? '',
          'phoneNo': data['phoneNo'] ?? '',
          'age': data['age'] ?? '',
          'gender': data['gender'] ?? 'Other', // Default to 'Other' if null
          'imageUrl': data['imageUrl'] ?? '',
          'userId': data['userId'] ?? '',
          'status': data['status'] ?? '',
          'likedLocations': data['likedLocations'] ?? [],
        };
      });
    }
  }

  void _editProfile() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController nameController =
            TextEditingController(text: userData['name']);
        TextEditingController emailController =
            TextEditingController(text: userData['email']);
        TextEditingController phoneController =
            TextEditingController(text: userData['phoneNo']);
        TextEditingController ageController =
            TextEditingController(text: userData['age'].toString());
        String gender = ['Male', 'Female', 'Other'].contains(userData['gender'])
            ? userData['gender']
            : 'Other'; // Default to 'Other'

        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Wrap(
                children: [
                  Text(
                    'Edit Profile',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                  SizedBox(height: 24),
                  _buildTextField(nameController, 'Name'),
                  _buildTextField(emailController, 'Email'),
                  _buildTextField(phoneController, 'Phone Number'),
                  _buildTextField(ageController, 'Age', isNumber: true),
                  DropdownButtonFormField<String>(
                    value: gender,
                    decoration: InputDecoration(
                      labelText: 'Gender',
                      border: OutlineInputBorder(),
                    ),
                    items: ['Male', 'Female', 'Other']
                        .map((gender) => DropdownMenuItem(
                              value: gender,
                              child: Text(gender),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        userData['gender'] = value!;
                      });
                    },
                  ),
                  SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text('Cancel'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.redAccent,
                          side: BorderSide(color: Colors.redAccent),
                        ),
                      ),
                      ElevatedButton(
                        // onPressed: () {
                        //   Navigator.of(context).pop();
                        // },
                        onPressed: () async {
                          String? userId = await getUserId();
                          await updateProfile(
                            userId!,
                            nameController.text,
                            emailController.text,
                            int.tryParse(ageController.text) ?? 0,
                            phoneController.text,
                            gender,
                          );
                          setState(() {
                            userData['name'] = nameController.text;
                            userData['email'] = emailController.text;
                            userData['phoneNo'] = phoneController.text;
                            userData['age'] =
                                int.tryParse(ageController.text) ?? 0;
                            userData['gender'] = gender;
                          });
                          Navigator.of(context).pop();
                        },
                        child: Text('Save'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          padding: EdgeInsets.symmetric(horizontal: 24),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText,
      {bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(),
        ),
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      ),
    );
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async{
                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool('isLoggedIn', false);
                await prefs.remove('userId');
                await prefs.remove('currentUserEmail');
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              child: Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Profile'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        leading: IconButton(onPressed: () =>Navigator.of(context).pop(), icon: Icon(Icons.arrow_back)),
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: Colors.white),
            tooltip: 'Edit Profile',
            onPressed: _editProfile,
          ),
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            tooltip: 'Logout',
            onPressed: _logout,
          ),

        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(userData['imageUrl']),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  ProfileField(label: 'Name', value: userData['name']),
                  ProfileField(label: 'Email', value: userData['email']),
                  ProfileField(label: 'Phone No', value: userData['phoneNo']),
                  ProfileField(label: 'Status', value: userData['status']),
                  ProfileField(label: 'Age', value: userData['age'].toString()),
                  ProfileField(label: 'Gender', value: userData['gender']),
                  ProfileField(
                    label: 'Liked Locations',
                    value: (userData['likedLocations'] as List).join(', '),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileField extends StatelessWidget {
  final String label;
  final String value;

  const ProfileField({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.blueAccent,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
