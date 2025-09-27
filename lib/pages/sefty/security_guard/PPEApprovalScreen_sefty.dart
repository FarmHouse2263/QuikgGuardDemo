import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PpeApprovalScreenSefty extends StatefulWidget {
  const PpeApprovalScreenSefty({Key? key}) : super(key: key);

  @override
  State<PpeApprovalScreenSefty> createState() => _PpeApprovalScreenSeftyState();
}

class _PpeApprovalScreenSeftyState extends State<PpeApprovalScreenSefty> {
  // กำหนด tab list ตาม status
  final List<String> tabs = ['อนุมัติแล้ว', 'รอดำเนินการ', 'ไม่อนุมัติ'];
  String selectedTab = 'อนุมัติแล้ว';

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> requestStream = FirebaseFirestore.instance
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
          'รายการอนุมัติ\nคำขอเบิก PPE',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            height: 1.2,
          ),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Tab buttons
          Container(
            color: Colors.grey[200],
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: tabs.map((tab) {
                return Expanded(
                  child: _buildTabButton(tab),
                );
              }).toList(),
            ),
          ),
          // Content
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: requestStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('ยังไม่มีคำขอ PPE'));
                }

                // Filter ตาม selectedTab
                final requests = snapshot.data!.docs.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  final status = (data['status'] ?? '').toString().trim();
                  return status == selectedTab;
                }).toList();

                if (requests.isEmpty) {
                  return const Center(child: Text('ไม่มีข้อมูลตรงตามเงื่อนไข'));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: requests.length,
                  itemBuilder: (context, index) {
                    final data = requests[index].data() as Map<String, dynamic>;
                    final requestId = requests[index].id;
                    final username = data['username'] ?? '-';
                    final employeeId = data['employeeId'] ?? '-';
                    final title = data['title'] ?? '-';
                    final reason = data['reason'] ?? '-';
                    final items = data['title'] ?? '-';
                    final quantity = data['quantity'] ?? 0;
                    final status = (data['status'] ?? '-').toString().trim();
                    final tabType = data['tabType'] ?? '-';
                    final returnDate = data['returnDate'] as Timestamp?;
                    final timestamp = (data['timestamp'] as Timestamp).toDate();
                    final image = data['image'] ?? '';

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12.0),
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
                            '[$requestId] | วันที่: ${timestamp.day}/${timestamp.month}/${timestamp.year}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text('ผู้ขอ: $username (ID: $employeeId)', style: const TextStyle(fontSize: 14)),
                          const SizedBox(height: 4),
                          Text('หัวข้อ: $title', style: const TextStyle(fontSize: 14)),
                          const SizedBox(height: 4),
                          Text('เหตุผล: $reason', style: const TextStyle(fontSize: 14)),
                          const SizedBox(height: 4),
                          Text('ประเภท: $tabType', style: const TextStyle(fontSize: 14)),
                          const SizedBox(height: 4),
                          Text('จำนวน: $quantity', style: const TextStyle(fontSize: 14)),
                          if (returnDate != null)
                            Text(
                              'วันที่คืน: ${returnDate.toDate().day}/${returnDate.toDate().month}/${returnDate.toDate().year}',
                              style: const TextStyle(fontSize: 14),
                            ),
                          const SizedBox(height: 8),
                          if (image.isNotEmpty)
                            Center(
                              child: Image.network(
                                image,
                                height: 80,
                                fit: BoxFit.contain,
                              ),
                            ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Text('Status: ', style: TextStyle(fontSize: 12)),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: status.contains('อนุมัติ') ? Colors.green[100] : Colors.orange[100],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  status,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                    color: status.contains('อนุมัติ') ? Colors.green : Colors.orange[800],
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
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String title) {
    bool isSelected = selectedTab == title;
    return GestureDetector(
      onTap: () => setState(() => selectedTab = title),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.grey[300],
          borderRadius: BorderRadius.circular(25),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isSelected ? Colors.black87 : Colors.grey[600],
            ),
          ),
        ),
      ),
    );
  }
}
