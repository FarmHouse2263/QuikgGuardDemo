// emergency.dart
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:quikguardtrue/pages/emergency/EmergencyHistoryScreen.dart';
import 'package:quikguardtrue/pages/emergency/seftyhomeEmergency.dart';
import 'package:quikguardtrue/pages/profile.dart';
import 'package:quikguardtrue/pages/sefty/security_guard/security_guard.dart';

class Emergency extends StatefulWidget {
  final String employeeId;
  const Emergency({Key? key, required this.employeeId}) : super(key: key);

  @override
  State<Emergency> createState() => _EmergencyState();
}

class _EmergencyState extends State<Emergency> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5F5),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 60),
        child: Column(
          children: [
            // ตัวเลือกที่ 1 - ของเบิกฉุกเฉิน
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        SeftyHomeEmergency(employeeId: widget.employeeId),
                  ),
                );
              },
              child: Container(
                width: double.infinity,
                height: 180,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF2C3E50), width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.wb_sunny_outlined,
                      size: 60,
                      color: Colors.black,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'ของเบิกฉุกเฉิน',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40),

            // ตัวเลือกที่ 2 - ประวัติการขอเบิกฉุกเฉิน
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EmergencyHistoryScreen(),
                  ),
                );
                log('ไปหน้าประวัติการขอเบิกฉุกเฉิน');
              },
              child: Container(
                width: double.infinity,
                height: 180,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF2C3E50), width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.description_outlined,
                      size: 60,
                      color: Colors.black,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'ประวัติการขอเบิกฉุกเฉิน',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const Spacer(),
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
