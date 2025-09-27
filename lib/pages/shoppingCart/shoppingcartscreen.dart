import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../sefty/record.dart';

class Shoppingcartscreen extends StatefulWidget {
  final String employeeId;
  const Shoppingcartscreen({Key? key, required this.employeeId}) : super(key: key);

  @override
  State<Shoppingcartscreen> createState() => _ShoppingCartScreenState();
}

class _ShoppingCartScreenState extends State<Shoppingcartscreen> {
  bool isSelectAll = false;

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
          'รถเข็น',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Select All Section
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Checkbox(
                  value: isSelectAll,
                  onChanged: (value) {
                    setState(() {
                      isSelectAll = value ?? false;
                    });
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const Text(
                  'เลือกรายการทั้งหมด',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Product List
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('shopping_cart').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('เกิดข้อผิดพลาด: ${snapshot.error}'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data!.docs;
                if (docs.isEmpty) {
                  return const Center(child: Text('ไม่มีสินค้าในรถเข็น'));
                }

                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final item = docs[index];
                    final data = item.data() as Map<String, dynamic>;

                    final title = data['title'] ?? 'ไม่ระบุชื่อสินค้า';
                    final image = data['image'] ?? '';
                    int quantity = data['quantity'] ?? 1;
                    final username = data['username'] ?? '';
                    final status = data['status'] ?? '';
                    final tabType = data['tabType'] ?? '';
                    final reason = data['reason'] ?? '';

                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Image
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.grey[100],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: image.startsWith('http')
                                  ? Image.network(image, fit: BoxFit.cover)
                                  : Image.asset('assets/images/safety_helmet.png', fit: BoxFit.cover),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'ผู้สั่งซื้อ: $username',
                                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'ประเภท: $tabType',
                                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    // Quantity controls
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey[300]!),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          // ลดจำนวน
                                          InkWell(
                                            onTap: () async {
                                              if (quantity > 1) {
                                                quantity--;
                                                setState(() {}); // อัปเดต UI
                                                await FirebaseFirestore.instance
                                                    .collection('shopping_cart')
                                                    .doc(item.id)
                                                    .update({'quantity': quantity});
                                              }
                                            },
                                            child: const Padding(
                                              padding: EdgeInsets.all(8),
                                              child: Icon(Icons.remove, size: 16, color: Colors.grey),
                                            ),
                                          ),
                                          // แสดงจำนวน
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                            child: Text(
                                              '$quantity',
                                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          // เพิ่มจำนวน
                                          InkWell(
                                            onTap: () async {
                                              quantity++;
                                              setState(() {}); // อัปเดต UI
                                              await FirebaseFirestore.instance
                                                  .collection('shopping_cart')
                                                  .doc(item.id)
                                                  .update({'quantity': quantity});
                                            },
                                            child: const Padding(
                                              padding: EdgeInsets.all(8),
                                              child: Icon(Icons.add, size: 16, color: Colors.grey),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Spacer(),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          'สถานะ: $status',
                                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                if (reason.isNotEmpty)
                                  Text(
                                    'เหตุผล: $reason',
                                    style: const TextStyle(fontSize: 12, color: Colors.red),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        color: const Color(0xFF2C3E50),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      final cartSnapshot = await FirebaseFirestore.instance.collection('shopping_cart').get();

                      if (cartSnapshot.docs.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('ไม่มีสินค้าในรถเข็น')),
                        );
                        return;
                      }

                      for (var doc in cartSnapshot.docs) {
                        final data = doc.data();

                        // บันทึกไปที่ ppe_requests
                        await FirebaseFirestore.instance.collection('ppe_requests').add({
                          'title': data['title'] ?? '',
                          'image': data['image'] ?? '',
                          'quantity': data['quantity'] ?? 1,
                          'username': data['username'] ?? '',
                          'employeeId': data['employeeId'] ?? widget.employeeId,
                          'tabType': data['tabType'] ?? '',
                          'reason': data['reason'] ?? '',
                          'status': 'pending',
                          'timestamp': FieldValue.serverTimestamp(),
                        });

                        // ลบออกจาก shopping_cart
                        await doc.reference.delete();
                      }

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('ยืนยันการสั่งซื้อเรียบร้อย')),
                      );

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const Record()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2C3E50),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'ยืนยัน',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      final snapshot = await FirebaseFirestore.instance.collection('shopping_cart').get();
                      for (var doc in snapshot.docs) {
                        await doc.reference.delete();
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('ลบสินค้าเรียบร้อย')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'ลบทั้งหมด',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
