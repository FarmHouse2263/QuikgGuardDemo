import 'package:flutter/material.dart';

class PPEImprovedFormScreen extends StatelessWidget {
  final Map<String, dynamic> ppeData;

  const PPEImprovedFormScreen({Key? key, required this.ppeData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ประวัติการยืมคืน PPE',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF2C3E50),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
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
              mainAxisSize: MainAxisSize.min,
              children: [
                // หัวข้อแรก - ID และวันที่
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'R021-021',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'วันที่ยืม ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                
                // ชื่อพนักงาน
                Text(
                  'นาย${ppeData['employee'] ?? 'ไม่ระบุ'} (${ppeData['reason'] ?? 'ไม่ระบุเหตุผล'})',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                
                // เหตุผล
                Text(
                  'เหตุผล : ${ppeData['reason'] ?? 'งานอาคาร'}',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 8),
                
                // ข้อมูล PPE
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[700],
                    ),
                    children: [
                      const TextSpan(text: 'PPE : '),
                      TextSpan(
                        text: '${ppeData['title'] ?? 'อุปกรณ์นิรภัย'} x${ppeData['returnQuantity'] ?? '0'}, ',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      TextSpan(
                        text: '${ppeData['condition'] ?? 'อุปกรณ์นิรภัยดีทั้งหมด'} x${ppeData['damagedQuantity'] ?? '0'}',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                
                // วันที่คืน
                Text(
                  'ครบกำหนดคืน : ${_formatReturnDate()}',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 12),
                
                // สถานะ
                Row(
                  children: [
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'สถานะ : ${ppeData['status'] ?? 'รอดำเนินการ'}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.orange[800],
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
      ),
    );
  }

  String _formatReturnDate() {
    final now = DateTime.now();
    final returnDate = now.add(const Duration(days: 30)); // สมมติว่าครบกำหนดคืนใน 30 วัน
    return '${returnDate.day}/${returnDate.month}/${returnDate.year}';
  }
}