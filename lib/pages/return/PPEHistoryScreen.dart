import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quikguardtrue/pages/return/PPEImprovedFormScreen.dart';
import 'package:quikguardtrue/pages/sefty/security_guard/security_guard.dart';
import 'package:quikguardtrue/pages/profile.dart';

class PPEHistoryScreen extends StatelessWidget {
  final String employeeId; // รับ employeeId
  const PPEHistoryScreen({Key? key, required this.employeeId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ประวัติการยืมคืน PPE',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF2C3E50),
        iconTheme: const IconThemeData(
          color: Colors.white, // เปลี่ยนสีปุ่มกลับ
        ),
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('ppe_history')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return const Center(child: Text('เกิดข้อผิดพลาด'));
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          final docs = snapshot.data!.docs;
          if (docs.isEmpty) return const Center(child: Text('ยังไม่มีรายการ'));

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final item = doc.data() as Map<String, dynamic>;

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PPEImprovedFormScreen(ppeData: item),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item['employee'] ?? '-', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 4),
                        Text('เหตุผล: ${item['reason'] ?? '-'}', style: const TextStyle(fontSize: 14, color: Colors.grey)),
                        const SizedBox(height: 4),
                        Text(
                          'PPE: ${item['title'] ?? '-'} x${item['returnQuantity'] ?? 0} (สภาพ: ${item['condition'] ?? '-'}, ชำรุด: ${item['damagedQuantity'] ?? 0})',
                          style: const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'ครบกำหนดคืน: ${item['returnDate'] ?? '-'}',
                          style: const TextStyle(fontSize: 14, color: Colors.red, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE8F5E8),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: const Color(0xFF28A745), width: 1),
                              ),
                              child: Text(
                                'สถานะ: ${item['status'] ?? '-'}',
                                style: const TextStyle(fontSize: 12, color: Color(0xFF28A745), fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
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
                  MaterialPageRoute(builder: (_) => SecurityGuard(employeeId: employeeId)),
                );
              },
            ),
            _buildBottomIcon(
              Icons.person_outline,
              "Profile",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ProfilePage(employeeId: employeeId)),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomIcon(IconData icon, String label, {required VoidCallback onTap}) {
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
