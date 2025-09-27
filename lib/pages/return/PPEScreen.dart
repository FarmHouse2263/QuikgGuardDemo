import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:quikguardtrue/pages/return/PPEHistoryScreen.dart';
import 'package:quikguardtrue/pages/return/PPEReturnListScreen.dart';
import 'package:quikguardtrue/pages/sefty/security_guard/security_guard.dart';
import 'package:quikguardtrue/pages/profile.dart';

class PPEScreen extends StatefulWidget {
  final String employeeId; // รับ employeeId
  const PPEScreen({Key? key, required this.employeeId}) : super(key: key);

  @override
  State<PPEScreen> createState() => _PPEScreenState();
}

class _PPEScreenState extends State<PPEScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2C3E50),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'คืน PPE',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildMenuCard(
              icon: Icons.refresh,
              text: "คืน PPE",
              onTap: () {
                log("คืน PPE tapped");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PPEReturnListScreen(employeeId: widget.employeeId),
                  ),
                );
              },
            ),
            const SizedBox(height: 30),
            _buildMenuCard(
              icon: Icons.format_list_bulleted,
              text: "ประวัติการคืน PPE",
              onTap: () {
                log("ประวัติการคืน PPE tapped");
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PPEHistoryScreen(employeeId: widget.employeeId)),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 80,
        color: const Color(0xFF2C3E50),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildBottomIcon(
              Icons.home,
              "Home",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        SecurityGuard(employeeId: widget.employeeId),
                  ),
                );
              },
            ),
            _buildBottomIcon(
              Icons.person_outline,
              "Profile",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProfilePage(employeeId: widget.employeeId),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Center(
        child: Container(
          width: 200,
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.grey[400]!, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.15),
                spreadRadius: 2,
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 50, color: const Color(0xFF2C3E50)),
              const SizedBox(height: 12),
              Text(
                text,
                style: const TextStyle(
                  fontSize: 18,
                  color: Color(0xFF2C3E50),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomIcon(
    IconData icon,
    String label, {
    required VoidCallback onTap,
  }) {
    return Container(
      width: 50,
      height: 50,
      decoration: const BoxDecoration(
        color: Color(0xFF2C3E50),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white, size: 34),
        onPressed: onTap,
      ),
    );
  }
}
