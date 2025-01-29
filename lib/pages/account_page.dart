import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notebook/pages/edit_profile.dart';

class AccountPage extends StatelessWidget {
  final User? user = FirebaseAuth.instance.currentUser;

  AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Account'),
        backgroundColor: Colors.deepPurple,
        elevation: 5,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.deepPurple.shade200,
                child: Icon(
                  Icons.account_circle,
                  size: 80,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20),

              // User Information
              Text(
                user?.displayName ?? "User Name",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                user?.email ?? "No Email",
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
              SizedBox(height: 30),

              
              ElevatedButton.icon(
                onPressed: () {
                  MaterialPageRoute(builder: (context) => EditProfilePage());
                },
                icon: Icon(Icons.edit, color: Colors.white),
                label: Text("Edit Profile"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(76, 104, 58, 183),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  textStyle: TextStyle(fontSize: 16,color: Color.fromARGB(255, 0, 0, 0),),
                ),
              ),
              SizedBox(height: 20),

              // Logout Button
              ElevatedButton.icon(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.pushReplacementNamed(context, '/login');
                },
                icon: Icon(Icons.logout, color: Colors.white),
                label: Text("Logout"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  textStyle: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
