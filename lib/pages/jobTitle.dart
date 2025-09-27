import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quikguardtrue/pages/sefty/security_guard/security_guard.dart';

class JobTitleScreen extends StatefulWidget {
  final String employeeId;

  const JobTitleScreen({super.key, required this.employeeId});

  @override
  State<JobTitleScreen> createState() => _JobTitleScreenState();
}

class _JobTitleScreenState extends State<JobTitleScreen> {
  String userPosition = '';
  bool isLoading = true;

  final List<String> jobTitles = [
    'จป.วิชาชีพ',
    'หน.ฝ่ายผลิต',
    'หน.ฝ่ายควบคุมคุณภาพ',
    'หน.ฝ่ายวิศวกรรม',
    'หน.ฝ่ายคลังสินค้า',
    'หน.ฝ่ายก่อสร้าง',
    'หน.ฝ่ายซ่อมบำรุง',
    'หน.ฝ่ายพัสดุ',
  ];

  @override
  void initState() {
    super.initState();
    _loadUserPosition();
  }

  Future<void> _loadUserPosition() async {
    final usersCollection = FirebaseFirestore.instance.collection('users');
    final query = await usersCollection
        .where('employeeId', isEqualTo: widget.employeeId)
        .limit(1)
        .get();

    if (query.docs.isNotEmpty) {
      final data = query.docs.first.data();
      setState(() {
        userPosition = (data['position'] ?? '').trim();
        isLoading = false;
      });
      // เช็คค่าที่ดึงมาจาก Firestore
      print('User position from Firestore: "$userPosition"');
    } else {
      setState(() {
        userPosition = '';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(60.0),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo
              Center(
                child: Image.network(
                  'https://raw.githubusercontent.com/FarmHouse2263/imageQuikgGuard/refs/heads/main/Mask%20group.png',
                ),
              ),
              const SizedBox(height: 30),

              // Job Title
              const Center(
                child: Text(
                  'Job Title',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Job buttons
              ...jobTitles.map((title) => Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: _buildJobButton(title),
                  )),

              const SizedBox(height: 30),

              // ปุ่ม Back
              Center(
                child: SizedBox(
                  width: 120,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 23, 36, 62),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 2,
                    ),
                    child: const Text(
                      'Back',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildJobButton(String title) {
    // ตัดช่องว่างทั้งหมดและแปลงเป็นตัวพิมพ์เล็ก
    String normalizedTitle = title.replaceAll(RegExp(r'\s+'), '').toLowerCase();
    String normalizedUserPosition =
        userPosition.replaceAll(RegExp(r'\s+'), '').toLowerCase();

    bool allowed = normalizedTitle == normalizedUserPosition;

    return Center(
      child: SizedBox(
        width: 225,
        height: 50,
        child: ElevatedButton(
          onPressed: allowed
              ? () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SecurityGuard(
                        employeeId: widget.employeeId,
                      ),
                    ),
                  );
                }
              : null, // ปิดปุ่มถ้าไม่ใช่ตำแหน่งตัวเอง
          style: ElevatedButton.styleFrom(
            backgroundColor: allowed
                ? const Color.fromARGB(255, 23, 36, 62)
                : Colors.grey[400], // ปุ่ม disable สีเทา
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            elevation: 2,
          ),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
