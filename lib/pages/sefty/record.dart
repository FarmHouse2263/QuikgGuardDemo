import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quikguardtrue/pages/sefty/security_guard/security_guard.dart';
import 'package:quikguardtrue/pages/profile.dart';

class Record extends StatefulWidget {
  const Record({super.key});

  @override
  State<Record> createState() => _RecordState();
}

class _RecordState extends State<Record> {
  String employeeId = '';
  String position = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadEmployeeData();
  }

  Future<void> _loadEmployeeData() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) throw "ยังไม่ได้ล็อกอิน";

      final userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (!userDoc.exists) throw "ไม่พบผู้ใช้";

      setState(() {
        employeeId = userDoc.data()?['employeeId'] ?? '';
        position = userDoc.data()?['position'] ?? '';
        isLoading = false;
      });

      print("✅ Employee ID: $employeeId | Position: $position");
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error loading employeeId: $e");
    }
  }

  String _getStatusText(String? status) {
    switch (status?.toLowerCase()) {
      case 'pending':
        return 'รออนุมัติ';
      case 'approved':
        return 'อนุมัติแล้ว';
      case 'rejected':
        return 'ไม่อนุมัติ';
      default:
        return 'ไม่ระบุ';
    }
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Future<void> _updateStatus(String docId, String newStatus) async {
    try {
      await FirebaseFirestore.instance
          .collection('ppe_requests')
          .doc(docId)
          .update({'status': newStatus});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("อัปเดตสถานะเป็น $newStatus สำเร็จ")),
      );
    } catch (e) {
      print("Error updating status: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFF2C3E50),
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    if (employeeId.isEmpty) {
      return const Scaffold(
        backgroundColor: Color(0xFF2C3E50),
        body: Center(
          child: Text(
            'ไม่พบ Employee ID ของคุณ',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      );
    }

    final requestsQuery = FirebaseFirestore.instance
        .collection('ppe_requests')
        .orderBy('timestamp', descending: true);

    return Scaffold(
      backgroundColor: const Color(0xFF2C3E50),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2C3E50),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'ประวัติการขอเบิก',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(top: 20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: StreamBuilder<QuerySnapshot>(
                stream: requestsQuery.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('เกิดข้อผิดพลาด: ${snapshot.error}'),
                    );
                  }

                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final docs = snapshot.data!.docs;

                  if (docs.isEmpty) {
                    return const Center(
                      child: Text(
                        'คุณยังไม่มีประวัติการขอเบิก',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final data = docs[index].data() as Map<String, dynamic>;
                      final docId = docs[index].id;

                      final timestamp = data['timestamp'] as Timestamp?;
                      final dateString = timestamp != null
                          ? "${timestamp.toDate().day}/${timestamp.toDate().month}/${timestamp.toDate().year}"
                          : 'ไม่ระบุวันที่';

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  '[${docId.substring(0, 8).toUpperCase()}]',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  'วันที่ขอเบิก: $dateString',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'ชื่อพนักงาน: ${data['username'] ?? 'ไม่ระบุชื่อ'}',
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'อุปกรณ์: ${data['title'] ?? 'ไม่ระบุ'} จำนวน ${data['quantity'] ?? 0} ชิ้น',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[800],
                                height: 1.3,
                              ),
                            ),
                            if (data['reason'] != null &&
                                data['reason'].toString().isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(
                                'เหตุผล: ${data['reason']}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[800],
                                  height: 1.3,
                                ),
                              ),
                            ],
                            const SizedBox(height: 8),
                            if (data['returnDate'] != null) ...[
                              Text(
                                'วันที่คืน: ${(data['returnDate'] as Timestamp).toDate().day}/${(data['returnDate'] as Timestamp).toDate().month}/${(data['returnDate'] as Timestamp).toDate().year}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 8),
                            ],
                            Row(
                              children: [
                                Text(
                                  'สถานะ: ',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                Text(
                                  _getStatusText(data['status']),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: _getStatusColor(data['status']),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            // ✅ ปุ่มอนุมัติ/ปฏิเสธ เฉพาะ จป.วิชาชีพ
                            if (position == "จป.วิชาชีพ" &&
                                (data['status'] == 'pending')) ...[
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  ElevatedButton(
                                    onPressed: () =>
                                        _updateStatus(docId, "approved"),
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green),
                                    child: const Text("อนุมัติ"),
                                  ),
                                  const SizedBox(width: 10),
                                  ElevatedButton(
                                    onPressed: () =>
                                        _updateStatus(docId, "rejected"),
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red),
                                    child: const Text("ไม่อนุมัติ"),
                                  ),
                                ],
                              ),
                            ]
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
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
                    builder: (_) => SecurityGuard(employeeId: employeeId),
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
                    builder: (_) => ProfilePage(employeeId: employeeId),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomIcon(IconData icon, String label,
      {required VoidCallback onTap}) {
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
