import 'package:flutter/material.dart';
import 'package:quikguardtrue/pages/parcel/InputPage.dart';
import 'package:quikguardtrue/pages/parcel/StockPage.dart';
import 'package:quikguardtrue/pages/profile.dart';
import 'package:quikguardtrue/pages/sefty/security_guard/security_guard.dart';

class Parcel extends StatefulWidget {
  final String employeeId;
  const Parcel({Key? key, required this.employeeId}) : super(key: key);

  @override
  State<Parcel> createState() => _ParcelState();
}

class _ParcelState extends State<Parcel> {
  @override
  Widget build(BuildContext context) {
    // รายชื่อเมนูทั้งหมด
    final List<Map<String, dynamic>> menuItems = [
      {'icon': Icons.inventory_2_outlined, 'title': 'Stock'},
      {'icon': Icons.file_download_outlined, 'title': 'Input'},
      {'icon': Icons.hourglass_empty, 'title': 'คำขอเบิก PPE'},
      {'icon': Icons.refresh, 'title': 'คำขอคืน PPE'},
      {'icon': Icons.check, 'title': 'รายการอนุมัติคำขอเบิก PPE'},
      {'icon': Icons.send_outlined, 'title': 'รายการอนุมัติคำขอคืน PPE'},
    ];

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: const Color(0xFF334155), // slate-700
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'พัสดุ',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: menuItems.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 ปุ่มต่อแถว
            mainAxisSpacing: 16, // เว้นแนวตั้ง
            crossAxisSpacing: 16, // เว้นแนวนอน
            childAspectRatio: 1.2, // ปรับความสูง/กว้างของปุ่ม
          ),
          itemBuilder: (context, index) {
            final item = menuItems[index];

            // กำหนดหน้าที่แต่ละปุ่มจะไป
            VoidCallback onTap;
            switch (item['title']) {
              case 'Stock':
                onTap = () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          Stockpage(employeeId: widget.employeeId),
                    ),
                  );
                };
                break;
              case 'Input':
                onTap = () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          Inputpage(employeeId: widget.employeeId),
                    ),
                  );
                };
                break;
              case 'คำขอเบิก PPE':
                onTap = () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) =>
                  //         PPERequestPage(employeeId: widget.employeeId),
                  //   ),
                  // );
                };
                break;
              case 'คำขอคืน PPE':
                onTap = () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) =>
                  //         PPEReturnPage(employeeId: widget.employeeId),
                  //   ),
                  // );
                };
                break;
              case 'รายการอนุมัติคำขอเบิก PPE':
                onTap = () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) =>
                  //         ApproveRequestPage(employeeId: widget.employeeId),
                  //   ),
                  // );
                };
                break;
              case 'รายการอนุมัติคำขอคืน PPE':
                onTap = () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) =>
                  //         // ApproveReturnPage(employeeId: widget.employeeId),
                  //   ),
                  // );
                };
                break;
              default:
                onTap = () {};
            }

            return _buildMenuCard(
              icon: item['icon'],
              title: item['title'],
              onTap: onTap,
            );
          },
        ),
      ),
      bottomNavigationBar: Container(
        height: 80,
        decoration: const BoxDecoration(
          color: Color(0xFF334155),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.home, color: Colors.white, size: 34),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        SecurityGuard(employeeId: widget.employeeId),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(
                Icons.person_outline,
                color: Colors.white,
                size: 34,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ProfilePage(employeeId: widget.employeeId),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.black, width: 2), // กรอบสีดำ
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 36, color: Colors.grey[700]),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[800],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
