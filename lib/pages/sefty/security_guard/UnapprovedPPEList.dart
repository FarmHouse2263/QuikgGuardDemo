import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class UnapprovedPPEList extends StatelessWidget {
  const UnapprovedPPEList({super.key});

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> requestsStream = FirebaseFirestore.instance
        .collection('ppe_requests')
        .where('status', isEqualTo: 'ไม่อนุมัติ')
        .orderBy('timestamp', descending: true)
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'คำขอ PPE ไม่อนุมัติ',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF2C3E50),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Colors.grey[200],
      body: StreamBuilder<QuerySnapshot>(
        stream: requestsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'ไม่มีคำขอ PPE ไม่อนุมัติ',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          final requests = snapshot.data!.docs;
          final totalUnapproved = requests.length;

          return Column(
            children: [
              // แจ้งเตือนจำนวนคำขอ
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                color: Colors.redAccent,
                child: Text(
                  'มีคำขอ PPE ไม่อนุมัติ $totalUnapproved รายการ',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // รายการ PPE
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: requests.length,
                  itemBuilder: (context, index) {
                    final data = requests[index].data() as Map<String, dynamic>;

                    // แปลง timestamp เป็น String
                    String formattedDate = '';
                    if (data['timestamp'] != null && data['timestamp'] is Timestamp) {
                      DateTime date = (data['timestamp'] as Timestamp).toDate();
                      formattedDate = DateFormat('dd/MM/yyyy HH:mm').format(date);
                    }

                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                data['title'] ?? '-',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                formattedDate,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text('ผู้สั่ง: ${data['username'] ?? '-'}'),
                          const SizedBox(height: 4),
                          Text('จำนวน: ${data['quantity'] ?? 0} ชิ้น'),
                          const SizedBox(height: 4),
                          Text('ประเภท: ${data['tabType'] ?? '-'}'),
                          const SizedBox(height: 4),
                          if (data['reason'] != null && data['reason'].toString().isNotEmpty)
                            Text('เหตุผล: ${data['reason']}'),
                          const SizedBox(height: 8),
                          if (data['image'] != null && data['image'] != '')
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                data['image'],
                                height: 120,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    height: 120,
                                    color: Colors.grey[300],
                                    child: const Center(
                                      child: Icon(Icons.broken_image, color: Colors.grey),
                                    ),
                                  );
                                },
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
