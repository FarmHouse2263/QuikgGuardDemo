import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quikguardtrue/pages/return/PPEHistoryScreen.dart';

class PPEReturnFormScreen extends StatefulWidget {
  final String employeeId;
  final Map<String, dynamic> ppeData; // รับข้อมูล PPE

  const PPEReturnFormScreen({Key? key, required this.ppeData, required this.employeeId}) : super(key: key);

  @override
  State<PPEReturnFormScreen> createState() => _PPEReturnFormScreenState();
}

class _PPEReturnFormScreenState extends State<PPEReturnFormScreen> {
  late int totalQuantity;
  int returnQuantity = 0;
  int damagedQuantity = 0;
  String conditionStatus = 'ดี'; // default

  @override
  void initState() {
    super.initState();
    totalQuantity = widget.ppeData['quantity'] ?? 0;
  }

  DateTime? parseReturnDate(dynamic dateData) {
    if (dateData == null) return null;
    try {
      if (dateData is String) {
        return DateFormat('d/M/yyyy').parse(dateData);
      } else if (dateData is DateTime) {
        return dateData;
      } else {
        return dateData.toDate();
      }
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    String ppeName = widget.ppeData['title'] ?? 'ไม่ระบุ PPE';
    String username = widget.ppeData['username'] ?? 'ไม่ระบุชื่อ';
    String reason = widget.ppeData['reason'] ?? '-';
    DateTime? returnDate = parseReturnDate(widget.ppeData['returnDate']);
    String returnDateStr = returnDate != null
        ? DateFormat('dd/MM/yyyy').format(returnDate)
        : "-";

    String imageUrl = widget.ppeData['image'] ?? '';

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ข้อมูลผู้ใช้และวันที่
            Container(
              width: double.infinity,
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
                  Text('ชื่อพนักงาน: $username',
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 4),
                  Text('เหตุผล: $reason',
                      style: const TextStyle(fontSize: 14, color: Colors.grey)),
                  const SizedBox(height: 4),
                  Text('ครบกำหนดคืน: $returnDateStr',
                      style: const TextStyle(
                          fontSize: 14, color: Colors.red, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 16),
                  const Text('รายการ PPE ที่ต้องคืน',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  _buildTableHeader(),
                  const SizedBox(height: 8),
                  _buildPPERow(ppeName),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: SizedBox(
                width: 150,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    Map<String, dynamic> returnedPPE = {
                      'employee': username,
                      'reason': reason,
                      'returnDate': returnDateStr,
                      'title': ppeName,
                      'totalQuantity': totalQuantity,
                      'returnQuantity': returnQuantity,
                      'damagedQuantity': damagedQuantity,
                      'condition': conditionStatus,
                      'image': imageUrl,
                      'status': 'ดำเนินการ',
                      'timestamp': FieldValue.serverTimestamp(),
                    };

                    try {
                      // บันทึกลง Firestore
                      await FirebaseFirestore.instance
                          .collection('ppe_history')
                          .add(returnedPPE);

                      // ไปหน้า PPEHistoryScreen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PPEHistoryScreen(employeeId: widget.employeeId),
                        ),
                      );
                    } catch (e) {
                      print('Error saving PPE: $e');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('เกิดข้อผิดพลาดในการบันทึก PPE')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2C3E50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 3,
                  ),
                  child: const Text(
                    'ยืนยัน',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTableHeader() {
    return Row(
      children: const [
        Expanded(flex: 3, child: Center(child: Text('PPE', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)))),
        Expanded(flex: 2, child: Center(child: Text('ยืม', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)))),
        Expanded(flex: 2, child: Center(child: Text('สภาพ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)))),
        Expanded(flex: 2, child: Center(child: Text('คืน', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)))),
        Expanded(flex: 2, child: Center(child: Text('ชำรุด', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)))),
        Expanded(flex: 1, child: Center(child: Text('รูป', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)))),
      ],
    );
  }

  Widget _buildPPERow(String ppeName) {
    return StatefulBuilder(
      builder: (context, setStateRow) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!, width: 1),
          ),
          child: Row(
            children: [
              Expanded(flex: 3, child: Center(child: Text(ppeName, style: const TextStyle(fontSize: 12)))),
              Expanded(flex: 2, child: Center(child: Text(totalQuantity.toString(), style: const TextStyle(fontSize: 12)))),
              Expanded(
                flex: 2,
                child: Center(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: conditionStatus,
                    items: ['ดี', 'ชำรุด', 'สูญหาย'].map((status) => DropdownMenuItem(
                      value: status,
                      child: Text(status, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12)),
                    )).toList(),
                    onChanged: (val) => setStateRow(() => conditionStatus = val!),
                    underline: const SizedBox(),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Center(
                  child: DropdownButton<int>(
                    value: returnQuantity,
                    items: List.generate(totalQuantity + 1, (index) => DropdownMenuItem(
                      value: index,
                      child: Text(index.toString(), style: const TextStyle(fontSize: 12)),
                    )),
                    onChanged: (val) => setStateRow(() => returnQuantity = val ?? 0),
                    underline: const SizedBox(),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Center(
                  child: DropdownButton<int>(
                    value: damagedQuantity,
                    items: List.generate(totalQuantity + 1, (index) => DropdownMenuItem(
                      value: index,
                      child: Text(index.toString(), style: const TextStyle(fontSize: 12)),
                    )),
                    onChanged: (val) => setStateRow(() => damagedQuantity = val ?? 0),
                    underline: const SizedBox(),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Center(
                  child: InkWell(
                    onTap: () => print('Upload photo for $ppeName'),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(6)),
                      child: const Icon(Icons.camera_alt, size: 16, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
