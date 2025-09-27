import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Historyppe extends StatefulWidget {
  final String employeeId; // พนักงานที่ล็อกอิน
  final String currentUserPosition; // ตำแหน่งผู้ที่ล็อกอิน

  const Historyppe({
    super.key,
    required this.employeeId,
    required this.currentUserPosition,
  });

  @override
  State<Historyppe> createState() => _HistoryppeState();
}

class _HistoryppeState extends State<Historyppe> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ประวัติการขอเบิก PPE',
          style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
        ),
        backgroundColor: Color(0xFF2C3E50),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('ppe_requests')
            .orderBy('timestamp', descending: true) // ✅ เอา where ออกก่อน
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('ยังไม่มีประวัติการเบิก'));
          }

          final requests = snapshot.data!.docs;

          // ✅ Debug log
          print('Docs length: ${requests.length}');
          for (var doc in requests) {
            print('DocID: ${doc.id}, Data: ${doc.data()}');
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final requestDoc = requests[index];
              final request = requestDoc.data() as Map<String, dynamic>;

              final title = request['title'] ?? 'ไม่มีชื่อ';
              final image =
                  request['image'] ?? 'https://via.placeholder.com/50';
              final quantity = request['quantity'] ?? 0;
              final status = request['status'] ?? 'pending';
              final employeeId = request['employeeId'] ?? '-';
              final timestamp = request['timestamp'] as Timestamp?;
              final dateTime = timestamp?.toDate() ?? DateTime.now();

              Color statusColor;
              String statusText;

              switch (status) {
                case 'approved':
                  statusColor = Colors.green;
                  statusText = 'อนุมัติ';
                  break;
                case 'rejected':
                  statusColor = Colors.red;
                  statusText = 'ปฏิเสธ';
                  break;
                default:
                  statusColor = Colors.orange;
                  statusText = 'รอดำเนินการ';
              }

              // ถ้าเป็น ParcelDepartment ให้แก้ไข status ได้
              Widget trailingWidget;
              if (widget.currentUserPosition == 'กองคลัง' || widget.currentUserPosition == 'จป') {
                trailingWidget = PopupMenuButton<String>(
                  onSelected: (value) async {
                    try {
                      await FirebaseFirestore.instance
                          .collection('ppe_requests')
                          .doc(requestDoc.id)
                          .update({'status': value});
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'เปลี่ยนสถานะของ "$title" เป็น ${value == 'approved' ? 'อนุมัติ' : 'ปฏิเสธ'} แล้ว',
                          ),
                          backgroundColor: Colors.green,
                        ),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('เกิดข้อผิดพลาด: $e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'approved',
                      child: Text('อนุมัติ'),
                    ),
                    const PopupMenuItem(
                      value: 'rejected',
                      child: Text('ปฏิเสธ'),
                    ),
                  ],
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      statusText,
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              } else {
                trailingWidget = Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    statusText,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.only(bottom: 16),
                child: ListTile(
                  leading: Image.network(
                    image,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Icon(
                      Icons.image_not_supported,
                      color: Colors.grey.shade400,
                      size: 40,
                    ),
                  ),
                  title: Text(title),
                  subtitle: Text(
                    'พนักงาน: $employeeId\n'
                    'จำนวน: $quantity\n'
                    'วันที่: ${dateTime.day}/${dateTime.month}/${dateTime.year}',
                  ),
                  trailing: trailingWidget,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
