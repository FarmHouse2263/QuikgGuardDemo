import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PPERequestScreen extends StatelessWidget {
  const PPERequestScreen({Key? key}) : super(key: key);

  Future<void> updateStatus(String docId, String newStatus) async {
    await FirebaseFirestore.instance
        .collection('ppe_requests')
        .doc(docId)
        .update({'status': newStatus});
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> requestStream = FirebaseFirestore.instance
        .collection('ppe_requests')
        .orderBy('timestamp', descending: true)
        .snapshots();

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: const Color(0xFF2C3E50),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'คำขอเบิก PPE',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: requestStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('ยังไม่มีคำขอเบิก PPE'));
          }

          final requests = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final doc = requests[index];
              final data = doc.data() as Map<String, dynamic>;
              final requestId = doc.id;
              final date = (data['timestamp'] as Timestamp).toDate();
              final username = data['username'] ?? 'ไม่ระบุชื่อ';
              final department = data['department'] ?? '';
              final reason = data['reason'] ?? '-';
              final items = data['items'] ?? '';
              final status = data['status'] ?? 'รออนุมัติ';

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '[$requestId] | วันที่ขอเบิก ${date.day}/${date.month}/${date.year}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'บุคคล: $username ($department)',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'เหตุผล : $reason',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'รายการ: $items',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Text(
                          'สถานะ: ',
                          style: TextStyle(fontSize: 14, color: Colors.black87),
                        ),
                        GestureDetector(
                          onTap: () async {
                            // เปิด Dialog เลือกสถานะใหม่
                            final newStatus = await showDialog<String>(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('เลือกสถานะใหม่'),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ListTile(
                                        title: const Text("รออนุมัติ"),
                                        onTap: () =>
                                            Navigator.pop(context, "รออนุมัติ"),
                                      ),
                                      ListTile(
                                        title: const Text("อนุมัติแล้ว"),
                                        onTap: () => Navigator.pop(
                                          context,
                                          "อนุมัติแล้ว",
                                        ),
                                      ),
                                      ListTile(
                                        title: const Text("ไม่อนุมัติ"),
                                        onTap: () => Navigator.pop(
                                          context,
                                          "ไม่อนุมัติ",
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );

                            if (newStatus != null && newStatus != status) {
                              try {
                                await FirebaseFirestore.instance
                                    .collection('ppe_requests')
                                    .doc(requestId)
                                    .update({'status': newStatus});

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      '✅ อัปเดตสถานะเป็น "$newStatus"',
                                    ),
                                  ),
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('❌ อัปเดตไม่สำเร็จ: $e'),
                                  ),
                                );
                              }
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: status == 'รออนุมัติ'
                                  ? Colors.orange[100]
                                  : status == 'อนุมัติแล้ว'
                                  ? Colors.green[100]
                                  : Colors.red[100],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              status,
                              style: TextStyle(
                                fontSize: 12,
                                color: status == 'รออนุมัติ'
                                    ? Colors.orange
                                    : status == 'อนุมัติแล้ว'
                                    ? Colors.green[800]
                                    : Colors.red[800],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),
                    // ปุ่มเปลี่ยนสถานะ
                    if (status == 'รออนุมัติ')
                      Row(
                        children: [
                          ElevatedButton.icon(
                            onPressed: () =>
                                updateStatus(requestId, 'อนุมัติแล้ว'),
                            icon: const Icon(Icons.check, size: 18),
                            label: const Text("อนุมัติ"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton.icon(
                            onPressed: () =>
                                updateStatus(requestId, 'ไม่อนุมัติ'),
                            icon: const Icon(Icons.close, size: 18),
                            label: const Text("ไม่อนุมัติ"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              );
            },
          );
        },
      ),
      // bottomNavigationBar: Container(
      //   decoration: BoxDecoration(
      //     color: const Color(0xFF2C3E50),
      //     boxShadow: [
      //       BoxShadow(
      //         color: Colors.black.withOpacity(0.1),
      //         spreadRadius: 0,
      //         blurRadius: 10,
      //         offset: const Offset(0, -2),
      //       ),
      //     ],
      //   ),
      //   child: SafeArea(
      //     child: Padding(
      //       padding: const EdgeInsets.symmetric(vertical: 8.0),
      //       child: Row(
      //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //         children: [
      //           _buildBottomNavItem(Icons.home, true),
      //           _buildBottomNavItem(Icons.notifications_outlined, false),
      //           _buildBottomNavItem(Icons.person_outline, false),
      //         ],
      //       ),
      //     ),
      //   ),
      // ),
    );
  }

  Widget _buildBottomNavItem(IconData icon, bool isActive) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isActive ? Colors.white.withOpacity(0.2) : Colors.transparent,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white, size: 24),
    );
  }
}
