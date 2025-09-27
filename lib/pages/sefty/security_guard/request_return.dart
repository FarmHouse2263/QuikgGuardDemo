import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RequestReturn extends StatelessWidget {
  const RequestReturn({Key? key}) : super(key: key);

  final List<String> statusOptions = const ['ดำเนินการ', 'เสร็จสิ้น'];

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> historyStream = FirebaseFirestore.instance
        .collection('ppe_history')
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
          'คำขอคืน PPE',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: historyStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('ยังไม่มีข้อมูลการคืน PPE'),
            );
          }

          final histories = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: histories.length,
            itemBuilder: (context, index) {
              final data = histories[index].data() as Map<String, dynamic>;
              final docId = histories[index].id;
              final title = data['title'] ?? '-';
              final imageUrl = data['image'] ?? '';
              final employee = data['employee'] ?? '-';
              final reason = data['reason'] ?? '-';
              final status = data['status'] ?? '-';
              final condition = data['condition'] ?? '-';
              final totalQuantity = data['totalQuantity'] ?? 0;
              final returnQuantity = data['returnQuantity'] ?? 0;
              final damagedQuantity = data['damagedQuantity'] ?? 0;
              final returnDate = data['returnDate'] ?? '-';
              final timestamp = (data['timestamp'] as Timestamp).toDate();

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
                      '[$docId] | วันที่คืน ${timestamp.day}/${timestamp.month}/${timestamp.year}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('บุคคล: $employee', style: const TextStyle(fontSize: 14, color: Colors.black87)),
                    const SizedBox(height: 4),
                    Text('เหตุผล: $reason', style: const TextStyle(fontSize: 14, color: Colors.black87)),
                    const SizedBox(height: 8),
                    if (imageUrl.isNotEmpty)
                      Center(
                        child: Image.network(imageUrl, height: 80, fit: BoxFit.contain),
                      ),
                    const SizedBox(height: 8),
                    Text('อุปกรณ์: $title', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 4),
                    Text('สภาพ: $condition', style: const TextStyle(fontSize: 14, color: Colors.black87)),
                    const SizedBox(height: 4),
                    Text(
                      'จำนวนทั้งหมด: $totalQuantity | คืนแล้ว: $returnQuantity | เสียหาย: $damagedQuantity',
                      style: const TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                    const SizedBox(height: 4),
                    Text('วันที่คืน: $returnDate', style: const TextStyle(fontSize: 14, color: Colors.black87)),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () => _changeStatus(context, docId, status),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: status == 'ดำเนินการ' ? Colors.orange[100] : Colors.green[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          status,
                          style: TextStyle(
                            fontSize: 12,
                            color: status == 'ดำเนินการ' ? Colors.orange : Colors.green[800],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _changeStatus(BuildContext context, String docId, String currentStatus) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('เปลี่ยนสถานะ'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: ['ดำเนินการ', 'เสร็จสิ้น'].map((statusOption) {
              return ListTile(
                title: Text(statusOption),
                onTap: () {
                  FirebaseFirestore.instance
                      .collection('ppe_history')
                      .doc(docId)
                      .update({'status': statusOption});
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('เปลี่ยนสถานะเป็น "$statusOption" เรียบร้อย')),
                  );
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
