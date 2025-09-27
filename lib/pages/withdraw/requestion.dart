// หน้าเมนูหลัก (Requestion updated UI)
import 'package:flutter/material.dart';
import 'package:quikguardtrue/pages/sefty/seftyhome.dart';
import '../jobTitle.dart';
import '../sefty/record.dart';

class Requestion extends StatefulWidget {
  final String employeeId;
  const Requestion({super.key, required this.employeeId});

  @override
  _RequestionState createState() => _RequestionState();
}

class _RequestionState extends State<Requestion> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'เบิกขาด/เบิกคืน',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.normal,
          ),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 100.0, vertical: 40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // เมนู ขอเบิก PPE
            _buildMenuCard(
              icon: Icons.refresh,
              title: 'ขอเบิก PPE',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => seftyhome(employeeId: widget.employeeId,), // หน้าเบิกขาด
                  ),
                );
              },
            ),

            const SizedBox(height: 50),

            // _buildMenuCard(
            //   icon: Icons.refresh,
            //   title: 'ขอเบิกยืม PPE',
            //   onTap: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => seftyhome(), // หน้าเบิกยืม
            //       ),
            //     );
            //   },
            // ),

            // const SizedBox(height: 50),

            // เมนู ประวัติการขอเบิก PPE
            _buildMenuCard(
              icon: Icons.description_outlined,
              title: 'ประวัติการขอเบิก PPE',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        Record()
                  ),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 70,
        color: const Color(0xFF2C3E50),
        child: Center(
          child: IconButton(
            icon: const Icon(Icons.home, color: Colors.white, size: 30),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      JobTitleScreen(employeeId: widget.employeeId),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildMenuCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey[500]!, // เพิ่มความเข้ม
            width: 2, // ขอบหนาขึ้น
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.black87),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
