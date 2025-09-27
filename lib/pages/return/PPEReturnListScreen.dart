import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:quikguardtrue/pages/profile.dart';
import 'package:quikguardtrue/pages/return/PPEReturnFormScreen.dart';
import 'package:quikguardtrue/pages/sefty/security_guard/UnapprovedPPEList.dart';
import 'package:quikguardtrue/pages/sefty/security_guard/security_guard.dart'; // import หน้า Form

class PPEReturnListScreen extends StatefulWidget {
  final String employeeId;
  const PPEReturnListScreen({Key? key, required this.employeeId}) : super(key: key);

  @override
  State<PPEReturnListScreen> createState() => _PPEReturnListScreenState();
}

class _PPEReturnListScreenState extends State<PPEReturnListScreen> {
  String employeeId = '';

  @override
  void initState() {
    super.initState();
    _loadEmployeeId();
  }

  Future<void> _loadEmployeeId() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    setState(() {
      employeeId = userDoc.data()?['employeeId'] ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    if (employeeId.isEmpty) {
      return const Scaffold(
        backgroundColor: Color(0xFF2C3E50),
        body: Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    final requestsQuery = FirebaseFirestore.instance
        .collection('ppe_requests')
        .where('employeeId', isEqualTo: employeeId)
        .where('tabType', isEqualTo: 'เบิกคืน')
        .orderBy('returnDate', descending: false);

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
      body: StreamBuilder<QuerySnapshot>(
        stream: requestsQuery.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('เกิดข้อผิดพลาด: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;
          if (docs.isEmpty) {
            return const Center(child: Text('ยังไม่มีรายการคืน PPE'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;

              // แปลง returnDate
              final returnTimestamp = data['returnDate'] as Timestamp?;
              final returnDateStr = returnTimestamp != null
                  ? DateFormat('dd/MM/yyyy').format(returnTimestamp.toDate())
                  : 'ไม่ระบุวันที่คืน';

              // แปลง timestamp ของวันที่ขอเบิก
              final requestTimestamp = data['timestamp'] as Timestamp?;
              final requestDateStr = requestTimestamp != null
                  ? DateFormat('dd/MM/yyyy').format(requestTimestamp.toDate())
                  : 'ไม่ระบุวันที่ขอเบิก';

              return GestureDetector(
                onTap: () {
                  // กดแล้วไปหน้า Form พร้อมส่งข้อมูล
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          PPEReturnFormScreen(ppeData: data, employeeId: widget.employeeId),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ชื่อพนักงาน: ${data['username'] ?? 'ไม่ระบุ'}',
                        style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF2C3E50),
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'วันที่ขอเบิก: $requestDateStr',
                        style: const TextStyle(
                            fontSize: 12, color: Color(0xFF666666)),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'ครบกำหนดคืน: $returnDateStr',
                        style: const TextStyle(
                            fontSize: 14,
                            color: Colors.red,
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'PPE: ${data['title'] ?? ''} x${data['quantity'] ?? 0}',
                        style: const TextStyle(
                            fontSize: 14, color: Color(0xFF666666)),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'เหตุผล: ${data['reason'] ?? '-'}',
                        style: const TextStyle(
                            fontSize: 14, color: Color(0xFF666666)),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      // Bottom navigation with notification badge
      bottomNavigationBar: Container(
        height: 80,
        decoration: const BoxDecoration(
          color: Color(0xFF2C3E50),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildBottomNavItem(
              Icons.home,
              false,
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        SecurityGuard(employeeId: widget.employeeId),
                  ),
                );
              },
            ),

            // Notification icon with badge
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('ppe_requests')
                  .where('status', isEqualTo: 'ไม่อนุมัติ')
                  .snapshots(),
              builder: (context, snapshot) {
                int count = 0;
                if (snapshot.hasData) count = snapshot.data!.docs.length;

                return Stack(
                  children: [
                    _buildBottomNavItem(
                      Icons.notifications_outlined,
                      false,
                      onTap: () {
                        if (count > 0) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UnapprovedPPEList(),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("ไม่มีคำขอไม่อนุมัติ"),
                            ),
                          );
                        }
                      },
                    ),
                    if (count > 0)
                      Positioned(
                        right: 4,
                        top: 4,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '$count',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),

            _buildBottomNavItem(
              Icons.person_outline,
              false,
              onTap: () {
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

  Widget _buildBottomIcon(IconData icon, String label) {
    return Container(
      width: 50,
      height: 50,
      decoration:
          const BoxDecoration(color: Color(0xFF2C3E50), shape: BoxShape.circle),
      child: IconButton(
        icon: Icon(icon, color: const Color.fromARGB(255, 255, 255, 255), size: 34),
        onPressed: () => print("$label tapped"),
      ),
    );
  }
}

Widget _buildBottomNavItem(
    IconData icon,
    bool isActive, {
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: isActive ? const Color(0xFF2C3E50) : Colors.white,
          size: 34,
        ),
      ),
    );
  }
