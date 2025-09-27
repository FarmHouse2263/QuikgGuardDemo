import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quikguardtrue/pages/shoppingCart/shoppingcartscreen.dart';

class Headdetail extends StatefulWidget {
  final String title;
  final String imagePath;
  final String tabType;

  const Headdetail({
    super.key,
    this.title = 'หมวก', // ให้ default แบบนี้ก็พอ
    required this.imagePath,
    required this.tabType,
  });

  @override
  State<Headdetail> createState() => _GlassesdetailState();
}


class _GlassesdetailState extends State<Headdetail> {
  int quantity = 1;
  bool isLoading = false;
  String selectedReason = 'พบความไม่ปลอดภัย'; // ค่าเริ่มต้น

  final List<String> reasons = [
    'พบความไม่ปลอดภัย',
    'อุปกรณ์เสียหาย',
    'อุปกรณ์หายไป',
    'อุปกรณ์หมดอายุ',
    'เพิ่มจำนวนพนักงาน',
    'อื่นๆ'
  ];

  void _increment() {
    setState(() {
      quantity++;
    });
  }

  void _decrement() {
    if (quantity > 1) {
      setState(() {
        quantity--;
      });
    }
  }

  Future<void> _confirm() async {
  setState(() {
    isLoading = true;
  });

  try {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw 'ผู้ใช้ยังไม่ล็อกอิน';

    // ดึงข้อมูล user จาก Firestore
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    final employeeId = userDoc['employeeId'];
    final username = userDoc['username'];
    if (employeeId.isEmpty) throw 'ไม่พบ employeeId';

    // ✅ บันทึกเข้า collection "ppe_requests"
    await FirebaseFirestore.instance.collection('ppe_requests').add({
      'title': widget.title,
      'username': username,
      'image': widget.imagePath,
      'quantity': quantity,
      'reason': selectedReason,
      'status': 'pending',
      'employeeId': employeeId,
      'tabType': widget.tabType,
      'timestamp': FieldValue.serverTimestamp(),
    });

    // ✅ บันทึกเข้า collection "shopping_cart"
    await FirebaseFirestore.instance.collection('shopping_cart').add({
      'title': widget.title,
      'username': username,
      'image': widget.imagePath,
      'quantity': quantity,
      'reason': selectedReason,
      'status': 'pending',
      'employeeId': employeeId,
      'tabType': widget.tabType,
      'timestamp': FieldValue.serverTimestamp(),
    });

    setState(() {
      isLoading = false;
    });

    // ✅ เด้งไปหน้า Shoppingcartscreen พร้อมส่ง employeeId
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => Shoppingcartscreen(employeeId: employeeId),
      ),
    );

  } catch (e) {
    setState(() {
      isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('เกิดข้อผิดพลาด: $e'),
        backgroundColor: Colors.red,
      ),
    );
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'เบิกอุปกรณ์ นำบาน',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: const Color(0xFF2C3E50),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // แถบ "อุปกรณ์นิรภัยที่ขอ" 
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'อุปกรณ์นิรภัยที่ขอ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // รูป PPE - ทำให้เป็นวงกลมเหมือนในภาพ
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Image.network(
                      widget.imagePath, 
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.construction,
                          size: 80,
                          color: Colors.orange,
                        );
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // ชื่อ PPE
              Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 30),

              // ปรับจำนวน
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'จำนวน',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(width: 30),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        onPressed: _decrement,
                        icon: const Icon(Icons.remove, size: 20),
                        constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        quantity.toString(),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        onPressed: _increment,
                        icon: const Icon(Icons.add, size: 20),
                        constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'ใบ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // เหตุผลการเบิก
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'เหตุผลการเบิก',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey[50],
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedReason,
                          isExpanded: true,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                          items: reasons.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedReason = newValue!;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // ปุ่มยืนยัน
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _confirm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2C3E50),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 2,
                  ),
                  child: isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'ยืนยัน',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}