import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:quikguardtrue/pages/profile.dart';
import 'package:quikguardtrue/pages/sefty/security_guard/security_guard.dart';
import 'package:quikguardtrue/pages/sefty/security_guard/return_request_list.dart';
import 'PPERequestScreen.dart';
import 'request_return.dart';
import 'emergency_request.dart';
import 'PPEApprovalScreen_sefty.dart';

class ManagementControlScreen extends StatelessWidget {
  final String employeeId;
  ManagementControlScreen({super.key, required this.employeeId});

  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
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
          'สถานะคำขอ',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.1,
                children: [
                  _buildMenuCard(
                    icon: Icons.refresh,

                    title: 'คำขอเบิก PPE',

                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PPERequestScreen(),
                        ),
                      );
                    },
                  ),
                  _buildMenuCard(
                    icon: Icons.check,
                    title: 'รายการอนุมัติคำขอเบิก PPE',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PpeApprovalScreenSefty(),
                        ),
                      );
                    },
                  ),
                  _buildMenuCard(
                    icon: Icons.sync,
                    title: 'คำขอคืน PPE',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RequestReturn(),
                        ),
                      );
                    },
                  ),
                  _buildMenuCard(
                    icon: Icons.send,
                    title: 'รายการอนุมัติคำขอคืน PPE',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReturnRequestList(),
                        ),
                      );
                    },
                  ),
                  _buildMenuCard(
                    icon: Icons.warning,
                    title: 'คำขอฉุกเฉิน',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EmergencyRequest(),
                        ),
                      );
                    },
                    isWide: true,
                  ),
                ],
              ),
            ),
          ),

          // Bottom Navigation
          // Bottom Navigation
          Container(
            height: 70,
            decoration: const BoxDecoration(
              color: Color(0xFF2C3E50),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Home icon
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            SecurityGuard(employeeId: employeeId),
                      ),
                    );
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      color: Color(0xFF2C3E50),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.home,
                      color: Colors.white,
                      size: 34,
                    ),
                  ),
                ),

                // Profile icon
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProfilePage(employeeId: employeeId),
                      ),
                    );
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      color: Color(0xFF2C3E50),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person_outline,
                      color: Colors.white,
                      size: 34,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isWide = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 32, color: Colors.black87),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
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
