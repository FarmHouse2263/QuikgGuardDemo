import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:quikguardtrue/pages/profile.dart';
import 'package:quikguardtrue/pages/return/PPEScreen.dart';
import 'package:quikguardtrue/pages/sefty/security_guard/security_guard.dart';
import 'package:quikguardtrue/pages/sefty/seftyhome.dart';
import '../sefty/record.dart';
import 'package:quikguardtrue/pages/withdraw/requestion.dart';

class MenuPage extends StatefulWidget {
  final String employeeId;
  const MenuPage({super.key, required this.employeeId});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Menu',
          style: TextStyle(
            color: const Color.fromARGB(255, 0, 0, 0),
            fontSize: 18,
            fontWeight: FontWeight.normal,
          ),
        ),
        centerTitle: false,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: const Color.fromARGB(255, 0, 0, 0),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 100, vertical: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 30),
            _buildMenuCard(
              icon: Icons.refresh,
              text: 'ขอเบิก PPE',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => seftyhome(employeeId: widget.employeeId)),
                );
              },
            ),

            SizedBox(height: 50),
            _buildMenuCard(
              icon: Icons.sync,
              text: 'คืน PPE',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PPEScreen(employeeId: widget.employeeId)),
                );
              },
            ),
            SizedBox(height: 50),
            _buildMenuCard(
              icon: Icons.wb_sunny_outlined,
              text: 'ประวัติขอเบิก',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Record()),
                );
              },
            ),
            Spacer(),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 70,
        color: Color(0xFF2C3E50),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Home
            IconButton(
              icon: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xFF2C3E50),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.home,
                  color: Color.fromARGB(255, 243, 243, 243),
                  size: 34,
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        SecurityGuard(employeeId: widget.employeeId),
                  ),
                );
              },
            ),
            // Profile
            IconButton(
              icon: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xFF2C3E50),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.person_outline,
                  color: Color.fromARGB(255, 243, 243, 243),
                  size: 34,
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ProfilePage(employeeId: widget.employeeId),
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
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey[500]!, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 3,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.black87),
            SizedBox(height: 15),
            Text(
              text,
              style: TextStyle(
                color: Colors.black87,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
