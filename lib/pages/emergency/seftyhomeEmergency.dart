import 'package:flutter/material.dart';
import 'Safety_rope_emergency/Safety_ropeProtectionPage.dart';
import 'glasses_emergency/GlassesProtectionPage.dart';
import 'head_emergency/HeadProtectionPage.dart';
import 'leg_emergency/LegProtectionPage.dart';
import 'hand_emergency/HandProtectionPage.dart';
import 'mask_emergency/MaskProtectionPage.dart';
import 'sound_emergency/SoundProtectionPage.dart';
import 'safety_vest_emergency/safety_vestProtectionPage.dart';

class SeftyHomeEmergency extends StatefulWidget {
  final String employeeId; // ✅ เพิ่ม employeeId
  const SeftyHomeEmergency({super.key, required this.employeeId});

  @override
  State<SeftyHomeEmergency> createState() => _SeftyHomeEmergencyState();
}

class _SeftyHomeEmergencyState extends State<SeftyHomeEmergency> {
  final List<String> allCategories = const [
    'อุปกรณ์ป้องกันศีรษะ',
    'อุปกรณ์ป้องกันใบหน้าและดวงตา',
    'อุปกรณ์ป้องกันมือและแขน',
    'อุปกรณ์ป้องกันขาและเท้า',
    'อุปกรณ์ป้องกันระบบหายใจ',
    'อุปกรณ์ป้องกันเสียงดัง',
    'อุปกรณ์ป้องกันลำตัว',
    'อุปกรณ์ป้องกันการตกจากที่สูง',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("เบิกฉุกเฉิน", style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          childAspectRatio: 1.2,
          children: List.generate(allCategories.length, (index) {
            return _buildCategoryCard(context, allCategories[index], index);
          }),
        ),
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, String title, int index) {
    return GestureDetector(
      onTap: () {
        _navigateToEmergency(context, index);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.black, width: 2),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToEmergency(BuildContext context, int index) {
    String tabType = "เบิกฉุกเฉิน";

    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => Headprotection(
              tabType: tabType,
              employeeId: widget.employeeId, // ✅ ส่ง employeeId
            ),
          ),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => Glassesprotectionpage(
              tabType: tabType,
              employeeId: widget.employeeId,
            ),
          ),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => Handprotectionpage(
              tabType: tabType,
              employeeId: widget.employeeId,
            ),
          ),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => Legprotectionpage(
              tabType: tabType,
              employeeId: widget.employeeId,
            ),
          ),
        );
        break;
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => Maskprotectionpage(
              tabType: tabType,
              employeeId: widget.employeeId,
            ),
          ),
        );
        break;
      case 5:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => Soundprotectionpage(
              tabType: tabType,
              employeeId: widget.employeeId,
            ),
          ),
        );
        break;
      case 6:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SafetyVestprotectionpage(
              tabType: tabType,
              employeeId: widget.employeeId,
            ),
          ),
        );
        break;
      case 7:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SafetyRopeprotectionpage(
              tabType: tabType,
              employeeId: widget.employeeId,
            ),
          ),
        );
        break;
    }
  }
}
