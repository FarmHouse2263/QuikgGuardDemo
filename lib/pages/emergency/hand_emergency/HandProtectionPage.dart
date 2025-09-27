import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'HandDetail.dart';
import '../../sefty/seftyhome.dart';

class Handprotectionpage extends StatefulWidget {
  final String employeeId;
  final String tabType; // "เบิกขาด" หรือ "เบิกคืน"

  const Handprotectionpage({super.key, required this.tabType, required this.employeeId});

  @override
  State<Handprotectionpage> createState() => _HeadprotectionState();
}

class _HeadprotectionState extends State<Handprotectionpage> {
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
          .doc('hand')
          .get();

      if (doc.exists) {
        setState(() {
          ppeList = [
            {'title': doc['title'], 'image': doc['image']},
          ];
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('ไม่พบข้อมูล PPE'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('เกิดข้อผิดพลาด: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String getPageTitle() {
    if (widget.tabType == "เบิกขาด") return "เบิกอุปกรณ์";
    return "คืนอุปกรณ์";
  }

  String getSectionTitle() {
    if (widget.tabType == "เบิกขาด") return "อุปกรณ์นิรภัยที่ขอ";
    return "อุปกรณ์นิรภัยที่คืน";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          getPageTitle(),
          style: const TextStyle(
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
      backgroundColor: Colors.white,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // แถบหัวข้อ
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    getSectionTitle(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ),
                // PPE List
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: ppeList.length,
                    itemBuilder: (context, index) {
                      final item = ppeList[index];
                      return PPECard(
                        title: item['title'],
                        imagePath: item['image'],
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Handdetail(
                                title: item['title'],
                                imagePath: item['image'],
                                tabType: widget.tabType,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                // Bottom Navigation Bar
                Container(
                  height: 80,
                  decoration: const BoxDecoration(color: Color(0xFF2C3E50)),
                  child: Center(
                    child: IconButton(
                      icon: const Icon(
                        Icons.home,
                        color: Colors.white,
                        size: 30,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => seftyhome(employeeId: widget.employeeId)),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class PPECard extends StatelessWidget {
  final String title;
  final String imagePath;
  final VoidCallback onTap;

  const PPECard({
    super.key,
    required this.title,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 30),
        child: Column(
          children: [
            // รูปภาพ PPE
            Container(
              width: 200,
              height: 200,
              child: Image.network(
                imagePath,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.construction,
                    size: 80,
                    color: Colors.orange,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // ชื่อ PPE
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
