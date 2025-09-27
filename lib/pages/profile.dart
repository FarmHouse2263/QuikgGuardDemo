import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quikguardtrue/pages/welcome.dart'; // หน้า welcome หรือ login

class ProfilePage extends StatelessWidget {
  final String employeeId;

  const ProfilePage({super.key, required this.employeeId});

  @override
  Widget build(BuildContext context) {
    final usersCollection = FirebaseFirestore.instance.collection('users');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              // กลับไปหน้า WelcomeScreen
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => WelcomeScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: usersCollection
            .where('employeeId', isEqualTo: employeeId) // ใช้ employeeId
            .limit(1)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('ไม่พบข้อมูลผู้ใช้'));
          }

          final userData =
              snapshot.data!.docs.first.data() as Map<String, dynamic>;

          return _buildProfile(userData, context);
        },
      ),
    );
  }

  Widget _buildProfile(Map<String, dynamic> userData, BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProfileField('Username', userData['username']),
          const SizedBox(height: 16),
          _buildProfileField('Tel.', userData['tel']),
          const SizedBox(height: 16),
          _buildProfileField('Employee ID', userData['employeeId']),
          const SizedBox(height: 16),
          _buildProfileField('Email', userData['email']),
          const SizedBox(height: 16),
          _buildProfileField('Position', userData['position']),
          const SizedBox(height: 16),
          _buildProfileField(
            'Created At',
            userData['createdAt'] != null
                ? (userData['createdAt'] as Timestamp).toDate().toString()
                : 'N/A',
          ),
        ],
      ),
    );
  }

  Widget _buildProfileField(String label, String? value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 16, color: Colors.grey)),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding:
              const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(value ?? '-',
              style: const TextStyle(fontSize: 18, color: Colors.black87)),
        ),
      ],
    );
  }
}
