// หน้าเมนูขอเบิก
import 'package:flutter/material.dart';
import 'package:quikguardtrue/pages/withdraw/requestion.dart';
// import 'package:quikguardtrue/pages/status/historyPPE.dart';
import '../jobTitle.dart';

class Withdraw extends StatefulWidget {
  final String employeeId;
  const Withdraw({super.key, required this.employeeId});

  @override
  _WithdrawState createState() => _WithdrawState();
}

class _WithdrawState extends State<Withdraw> {
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

            _buildMenuButton('ขอเบิก PPE', () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      Requestion(employeeId: widget.employeeId),
                ),
              );
            }),

            const SizedBox(height: 15),

            _buildMenuButton('ประวัติการขอเบิก', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RequestHistoryPage()),
              );
            }),

            const SizedBox(height: 15),

            _buildMenuButton('พัสดุ', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PackagePage()),
              );
            }),

            const SizedBox(height: 15),

            _buildMenuButton('คืน PPE', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PPEReturnPage()),
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
            icon: const Icon(Icons.home, color: Colors.white, size: 30),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => JobTitleScreen(employeeId: widget.employeeId)),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton(String text, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFD3D3D3),
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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

// ตัวอย่างหน้าอื่น ๆ (สร้างไฟล์ใหม่ตามชื่อนี้)
class RequestHistoryPage extends StatelessWidget {
  const RequestHistoryPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ประวัติการขอเบิก')),
      body: const Center(child: Text('หน้านี้สำหรับประวัติการขอเบิก')),
    );
  }
}

class PackagePage extends StatelessWidget {
  const PackagePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('พัสดุ')),
      body: const Center(child: Text('หน้านี้สำหรับพัสดุ')),
    );
  }
}

class PPEReturnPage extends StatelessWidget {
  const PPEReturnPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('คืน PPE')),
      body: const Center(child: Text('หน้านี้สำหรับคืน PPE')),
    );
  }
}
