import 'package:flutter/material.dart';
// import 'package:quikguard/pages/login.dart';
import 'package:quikguardtrue/pages/login.dart';
// import 'package:quikguard/pages/parcel_department/HeadProtectionPage.dart';
import 'HeadProtectionPage.dart';
import 'FaceEyeProtectionPage.dart';
import 'HandArmProtectionPage.dart';
import 'LegFootProtectionPage.dart';
import 'BodyProtectionPage.dart';

// ignore: camel_case_types
class parcel_department extends StatelessWidget {
  const parcel_department({super.key});

  final List<String> categories = const [
    'อุปกรณ์ป้องกันศีรษะ',
    'อุปกรณ์ป้องกันใบหน้าและดวงตา',
    'อุปกรณ์ป้องกันมือและแขน',
    'อุปกรณ์ป้องกันขาและเท้า',
    'อุปกรณ์ป้องกันลำตัว',
    'อุปกรณืป้อวกันระบบหายใจ',
    'อุปกรณ์ป้องกันเสียงดัง',
    'อุปกรณ์ป้องกันการตกจากที่สูง',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('แผนกพัสดุ'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final title = categories[index];
          return ListTile(
            title: Text(title),
            trailing: const Icon(Icons.arrow_forward_ios),
            tileColor: Colors.blue.shade50,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            onTap: () {
              // เลือกหน้าไปตาม index หรือ title
              switch (index) {
                case 0:
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => HeadProtectionPage()),
                  );
                  break;
                case 1:
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => FaceEyeProtectionPage()),
                  );
                  break;
                case 2:
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => HandArmProtectionPage()),
                  );
                  break;
                case 3:
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => LegFootProtectionPage()),
                  );
                  break;
                case 4:
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => BodyProtectionPage()),
                  );
                  break;
              }
              
            },
          );
        },
      ),
    );
  }
}
