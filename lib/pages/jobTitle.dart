import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quikguardtrue/pages/sefty/security_guard/security_guard.dart';
import 'dart:developer';

class JobTitleScreen extends StatefulWidget {
  final String employeeId;

  const JobTitleScreen({super.key, required this.employeeId});

  @override
  State<JobTitleScreen> createState() => _JobTitleScreenState();
}

class _JobTitleScreenState extends State<JobTitleScreen> {
  String userPosition = '';
  bool isLoading = true;

  // 🟢 Map ตำแหน่ง Firestore → ชื่อเต็มที่ใช้ในปุ่ม
  final Map<String, String> positionMapping = {
    'จป': 'จป.วิชาชีพ',
    'จปวิชาชีพ': 'จป.วิชาชีพ',
    'จป.วิชาชีพ': 'จป.วิชาชีพ',
    'หน.ฝ่ายผลิต': 'หน.ฝ่ายผลิต',
    'หน.ฝ่ายควบคุมคุณภาพ': 'หน.ฝ่ายควบคุมคุณภาพ',
    'หน.ฝ่ายวิศวกรรม': 'หน.ฝ่ายวิศวกรรม',
    'หน.ฝ่ายคลังสินค้า': 'หน.ฝ่ายคลังสินค้า',
    'หน.ฝ่ายก่อสร้าง': 'หน.ฝ่ายก่อสร้าง',
    'หน.ฝ่ายซ่อมบำรุง': 'หน.ฝ่ายซ่อมบำรุง',
    'หน.ฝ่ายพัสดุ': 'หน.ฝ่ายพัสดุ',
  };

  // 🟢 ปุ่มตำแหน่งทั้งหมด
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
      String firestorePosition = (data['position'] ?? '').trim();

      setState(() {
        // 🟢 แปลงตำแหน่งจาก Firestore ให้ตรงกับปุ่ม
        userPosition = positionMapping[firestorePosition] ?? firestorePosition;
        isLoading = false;
      });

      log('User position from Firestore: "$firestorePosition" => mapped: "$userPosition"');
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

              // Title
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

              // ปุ่มตำแหน่งงาน
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
    // normalize → ตัดช่องว่าง + lowercase
    String normalizedTitle = title.replaceAll(RegExp(r'\s+'), '').toLowerCase();
    String normalizedUserPosition =
        userPosition.replaceAll(RegExp(r'\s+'), '').toLowerCase();

    bool allowed = normalizedTitle == normalizedUserPosition;

    log('compare $normalizedTitle vs $normalizedUserPosition => allowed: $allowed');

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
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: allowed
                ? const Color.fromARGB(255, 23, 36, 62)
                : Colors.grey[400],
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
