import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EmergencyRequest extends StatelessWidget {
  const EmergencyRequest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> emergencyStream = FirebaseFirestore.instance
        .collection('ppe_emergency')
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
          'คำขอเบิกฉุกเฉิน',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: emergencyStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('ยังไม่มีคำขอเบิกฉุกเฉิน'),
            );
          }

          final emergencies = snapshot.data!.docs;

          // อัปเดต status เป็น "อนุมัติ" อัตโนมัติ
          for (var doc in emergencies) {
            final data = doc.data() as Map<String, dynamic>;
            if (data['status'] != 'อนุมัติ') {
              FirebaseFirestore.instance
                  .collection('ppe_emergency')
                  .doc(doc.id)
                  .update({'status': 'อนุมัติ'});
            }
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: emergencies.length,
            itemBuilder: (context, index) {
              final data = emergencies[index].data() as Map<String, dynamic>;
              final requestId = emergencies[index].id;
              final title = data['title'] ?? '-';
              final employeeName = data['username'] ?? '-';
              final department = data['department'] ?? '';
              final reason = data['reason'] ?? '-';
              final items = data['items'] ?? '';
              final quantity = data['quantity'] ?? 0;
              final status = data['status'] ?? 'รอดำเนินการ';
              final timestamp = (data['timestamp'] as Timestamp).toDate();
              final imageUrl = data['image'] ?? '';

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
                      '[$requestId] | วันที่ขอเบิก ${timestamp.day}/${timestamp.month}/${timestamp.year}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('บุคคล: $employeeName ($department)', style: const TextStyle(fontSize: 14)),
                    const SizedBox(height: 4),
                    Text('เหตุผล: $reason', style: const TextStyle(fontSize: 14)),
                    const SizedBox(height: 4),
                    Text('รายการ: $items x$quantity', style: const TextStyle(fontSize: 14)),
                    const SizedBox(height: 8),
                    if (imageUrl.isNotEmpty)
                      Center(
                        child: Image.network(imageUrl, height: 80, fit: BoxFit.contain),
                      ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Text('สถานะ: ', style: TextStyle(fontSize: 14)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: status == 'รอดำเนินการ' ? Colors.orange[100] : Colors.green[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            status,
                            style: TextStyle(
                              fontSize: 12,
                              color: status == 'รอดำเนินการ' ? Colors.orange[800] : Colors.green[800],
                              fontWeight: FontWeight.w500,
                            ),
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
      bottomNavigationBar: Container(
        height: 70,
        decoration: const BoxDecoration(
          color: Color(0xFF2C3E50),
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildBottomNavItem(Icons.home, true),
            _buildBottomNavItem(Icons.notifications_outlined, false),
            _buildBottomNavItem(Icons.person_outline, false),
          ],
        ),
      ),
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

