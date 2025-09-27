import 'package:flutter/material.dart';
import 'package:quikguardtrue/pages/Safety_rope/Safety_ropeProtectionPage.dart';
import 'package:quikguardtrue/pages/safety_vest/safety_vestProtectionPage.dart';
import 'package:quikguardtrue/pages/sefty/security_guard/security_guard.dart';
import 'package:quikguardtrue/pages/withdraw/requestion.dart';
import '../head/HeadProtectionPage.dart';
import '../glasses/GlassesProtectionPage.dart';
import '../hand/HandProtectionPage.dart';
import '../leg/LegProtectionPage.dart';
import '../mask/MaskProtectionPage.dart';
import '../sound/SoundProtectionPage.dart';


class seftyhome extends StatefulWidget {
  final String employeeId;
  const seftyhome({super.key, required this.employeeId});

  @override
  _seftyhomeState createState() => _seftyhomeState();
}

class _seftyhomeState extends State<seftyhome> {
  int selectedTab = 0; // 0 = เบิกขาด, 1 = เบิกคืน

  final List<String> categoriesBorrow = const [
    'อุปกรณ์ป้องกันศีรษะ',
    'อุปกรณ์ป้องกันใบหน้าและดวงตา',
    'อุปกรณ์ป้องกันมือและแขน',
    'อุปกรณ์ป้องกันขาและเท้า',
    'อุปกรณ์ป้องกันระบบหายใจ',
    'อุปกรณ์ป้องกันเสียงดัง',
  ];

  final List<String> categoriesReturn = const [
    'อุปกรณ์ป้องกันลำตัว',
    // 'อุปกรณ์ป้องกันเสียงดัง',
    'อุปกรณ์ป้องกันการตกจากที่สูง',
  ];

  @override
  Widget build(BuildContext context) {
    // เลือก categories ตาม tab
    final categories =
        selectedTab == 0 ? categoriesBorrow : categoriesReturn;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          // Tab selector
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => selectedTab = 0),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: selectedTab == 0
                            ? Color(0xFF2C3E50)
                            : Colors.grey[400],
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Center(
                        child: Text(
                          'เบิกขาด',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => selectedTab = 1),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: selectedTab == 1
                            ? Color(0xFF2C3E50)
                            : Colors.grey[400],
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Center(
                        child: Text(
                          'เบิกคืน',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content area
          SizedBox(height: 40),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 1.2,
                children: List.generate(categories.length, (index) {
                  return _buildCategoryCard(context, categories[index], index);
                }),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 70,
        color: Color(0xFF2C3E50),
        child: Center(
          child: IconButton(
            icon: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Color(0xFF2C3E50),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.home, color: Color.fromARGB(255, 255, 255, 255), size: 34),
            ),
            onPressed: () {
              // Navigator.popUntil(context, (route) => route.isFirst);
              Navigator.push(
                context, 
              MaterialPageRoute(
                builder: (context) => SecurityGuard(employeeId: widget.employeeId))
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, String title, int index) {
    return GestureDetector(
      onTap: () {
        _navigateToCategory(context, index);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Colors.black,
            width: 2,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Center(
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToCategory(BuildContext context, int index) {
    String tabType = selectedTab == 0 ? "เบิกขาด" : "เบิกคืน";

    if (selectedTab == 0) {
      // ✅ เบิกขาด
      switch (index) {
        case 0:
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => Headprotection(tabType: tabType, employeeId: widget.employeeId,)));
          break;
        case 1:
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => Glassesprotectionpage(tabType: tabType, employeeId: widget.employeeId)));
          break;
        case 2:
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => Handprotectionpage(tabType: tabType, employeeId: widget.employeeId)));
          break;
        case 3:
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => Legprotectionpage(tabType: tabType, employeeId: widget.employeeId)));
          break;
        case 4:
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => Maskprotectionpage(tabType: tabType, employeeId: widget.employeeId)));
          break;
        case 5:
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => Soundprotectionpage(tabType: tabType, employeeId: widget.employeeId,)));
          break;
      }
    } else {
      // ✅ เบิกคืน → เฉพาะ 3 หน้า
      switch (index) {
        case 0:
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => SafetyVestprotectionpage(tabType: tabType, employeeId: widget.employeeId,)));
          break;
        // case 1:
        //   Navigator.push(context,
        //       MaterialPageRoute(builder: (_) => Soundprotectionpage(tabType: tabType)));
        //   break;
        case 1:
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => SafetyRopeprotectionpage(tabType: tabType, employeeId: widget.employeeId)));
          break;
      }
    }
  }
}

