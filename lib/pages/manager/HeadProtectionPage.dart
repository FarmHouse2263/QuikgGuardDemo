import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quikguardtrue/pages/login.dart';

class HeadProtectionPage extends StatefulWidget {
  const HeadProtectionPage({super.key});

  @override
  State<HeadProtectionPage> createState() => _HeadProtectionPageState();
}

class _HeadProtectionPageState extends State<HeadProtectionPage> {
  List<bool> selected = [];
  List<Map<String, dynamic>> ppeList = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPPEData();
  }

  Future<void> _fetchPPEData() async {
  try {
    final doc = await FirebaseFirestore.instance
        .collection('ppe')
        .doc('head')
        .get();

    if (doc.exists) {
      setState(() {
        ppeList = [
          {
            'title': doc['title'],
            'image': doc['image'],
          }
        ];
        selected = [false];
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('ไม่พบข้อมูล PPE'),
          backgroundColor: Colors.red,
        ),
      );
    }
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


  void _toggleSelected(int index) {
    setState(() {
      selected[index] = !selected[index];
    });
  }

  void _submitSelection() {
    if (selected.contains(false)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('กรุณาเลือกอุปกรณ์ PPE ทุกชิ้น'),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('เลือกอุปกรณ์ครบทุกชิ้นแล้ว ขอบคุณครับ!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('เลือกอุปกรณ์'),
        backgroundColor: Colors.blue.shade700,
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
      backgroundColor: Colors.grey.shade100,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Expanded(
                    child: GridView.builder(
                      itemCount: ppeList.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.9,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemBuilder: (context, index) {
                        final item = ppeList[index];
                        return PPECard(
                          title: item['title'],
                          imagePath: item['image'],
                          isSelected: selected[index],
                          onTap: () => _toggleSelected(index),
                        );
                      },
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _submitSelection,
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 14, horizontal: 32),
                      child: Text('ยืนยันการเลือก',
                          style: TextStyle(fontSize: 18)),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class PPECard extends StatelessWidget {
  final String title;
  final String imagePath;
  final bool isSelected;
  final VoidCallback onTap;

  const PPECard({
    super.key,
    required this.title,
    required this.imagePath,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected ? Colors.blue.shade100 : Colors.white,
      borderRadius: BorderRadius.circular(12),
      elevation: 3,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                Image.network(
                  imagePath,
                  width: 80,
                  height: 80,
                  fit: BoxFit.contain,
                ),
                if (isSelected)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Icon(
                      Icons.check_circle,
                      color: Colors.green.shade700,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: isSelected ? Colors.blue.shade700 : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
