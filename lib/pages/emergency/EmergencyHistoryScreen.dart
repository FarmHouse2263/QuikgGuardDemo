import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EmergencyHistoryScreen extends StatelessWidget {
  const EmergencyHistoryScreen({Key? key}) : super(key: key);

  Future<String?> _getEmployeeId() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    // 🔥 ดึง employeeId จาก collection users โดยใช้ uid
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (userDoc.exists) {
      return userDoc.data()?['employeeId'] as String?;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _getEmployeeId(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return const Scaffold(
            body: Center(child: Text("ไม่พบ employeeId ของผู้ใช้")),
          );
        }

        final employeeId = snapshot.data!;

        final Stream<QuerySnapshot> emergencyStream = FirebaseFirestore.instance
            .collection('ppe_emergency')
            .where('employeeId', isEqualTo: employeeId)
            .orderBy('timestamp', descending: true)
            .snapshots();

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
              'ประวัติการขอเบิก',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          body: StreamBuilder<QuerySnapshot>(
            stream: emergencyStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text('ยังไม่มีประวัติการขอเบิก'),
                );
              }

              final emergencies = snapshot.data!.docs;

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: emergencies.length,
                itemBuilder: (context, index) {
                  final data =
                      emergencies[index].data() as Map<String, dynamic>;
                  final requestId = emergencies[index].id;
                  final date = (data['timestamp'] as Timestamp).toDate();
                  final username = data['username'] ?? 'ไม่ระบุชื่อ';
                  final reason = data['reason'] ?? '';
                  final title = data['title'] ?? '';
                  final quantity = data['quantity']?.toString() ?? '0';
                  final status = data['status'] ?? 'pending';

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 3,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header row
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    requestId,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Text('|',
                                    style: TextStyle(color: Colors.grey)),
                                const SizedBox(width: 8),
                                Text(
                                  'วันที่ขอเบิก ${date.day}/${date.month}/${date.year}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              username,
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'เหตุผล : $reason',
                              style: const TextStyle(
                                  fontSize: 13, color: Colors.black87),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'รายการ: $title x$quantity',
                              style: const TextStyle(
                                  fontSize: 13, color: Colors.black87),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: status == 'pending'
                                        ? Colors.orange[100]
                                        : Colors.green[100],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    'สถานะ : $status',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: status == 'pending'
                                          ? Colors.orange[800]
                                          : Colors.green[800],
                                      fontWeight: FontWeight.w500,
                                    ),
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
        );
      },
    );
  }
}
