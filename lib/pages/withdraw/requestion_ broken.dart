// หน้าเมนูหลัก (Requestion broken)
import 'package:flutter/material.dart';
import 'package:quikguardtrue/pages/sefty/seftyhome.dart';

class Requestion_broken extends StatefulWidget {
  final String employeeId;
  const Requestion_broken({super.key, required this.employeeId});

  @override
  _RequestionState createState() => _RequestionState();
}

class _RequestionState extends State<Requestion_broken> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'ขอเบิก',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.normal,
          ),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // เมนู เบิกขาด
            _buildMenuButton('เบิกขาด', onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => seftyhome(employeeId: widget.employeeId), // หน้าเบิกขาด
                ),
              );
            }),
            const SizedBox(height: 15),

            // เมนู เบิกคืน
            _buildMenuButton('เบิกคืน', onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PPEReturnPage(), // สร้างหน้า PPEReturnPage
                ),
              );
            }),
            const Spacer(),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 70,
        color: const Color(0xFF2C3E50),
        child: Center(
          child: IconButton(
            icon: const Icon(
              Icons.home,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () {
              Navigator.popUntil(context, (route) => route.isFirst);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton(String text, {required VoidCallback onPressed}) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFD3D3D3),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          shadowColor: Colors.black26,
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

// ตัวอย่างหน้าเบิกคืน (สร้างเป็นไฟล์ PPEReturnPage.dart)
class PPEReturnPage extends StatelessWidget {
  const PPEReturnPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('เบิกคืน'),
        backgroundColor: Colors.blue.shade700,
      ),
      body: const Center(
        child: Text('หน้านี้สำหรับเบิกคืน PPE'),
      ),
    );
  }
}
