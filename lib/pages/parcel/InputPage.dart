import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class Inputpage extends StatefulWidget {
  final String employeeId;
  const Inputpage({super.key, required this.employeeId});

  @override
  _InputpageState createState() => _InputpageState();
}

class _InputpageState extends State<Inputpage> {
  String selectedPPEId = 'PPE001';
  final TextEditingController unitPriceController = TextEditingController(text: '0');
  final TextEditingController quantityController = TextEditingController(text: '0');
  final TextEditingController purchaseUnitController = TextEditingController();
  final TextEditingController wholesalePriceController = TextEditingController();
  final TextEditingController totalPriceController = TextEditingController(text: '0');
  
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 80,
      );
      
      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("ไม่สามารถเลือกรูปภาพได้: $e")),
      );
    }
  }

  void _calculateTotal() {
    double unitPrice = double.tryParse(unitPriceController.text) ?? 0;
    int quantity = int.tryParse(quantityController.text) ?? 0;
    double total = unitPrice * quantity;
    totalPriceController.text = total.toStringAsFixed(2);
  }

  Future<void> _saveOrUpdatePPE() async {
    final collectionRef = FirebaseFirestore.instance.collection('ppe');

    try {
      final querySnapshot = await collectionRef.where('ppeid', isEqualTo: selectedPPEId).get();

      int newQuantity = int.tryParse(quantityController.text) ?? 0;
      double unitPrice = double.tryParse(unitPriceController.text) ?? 0;
      double wholesalePrice = double.tryParse(wholesalePriceController.text) ?? 0;
      double totalPrice = double.tryParse(totalPriceController.text) ?? 0;

      Map<String, dynamic> data = {
        'ppeid': selectedPPEId,
        'จำนวน': newQuantity,
        'ราคาต่อหน่วย': unitPrice,
        'หน่วยซื้อ': purchaseUnitController.text,
        'ราคาซื้อโดยส่ง': wholesalePrice,
        'ราคารวม': totalPrice,
        'employeeId': widget.employeeId,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (querySnapshot.docs.isNotEmpty) {
        final docRef = querySnapshot.docs.first.reference;
        
        int currentQuantity = 0;
        final existingData = querySnapshot.docs.first.data();
        if (existingData.containsKey('จำนวน')) {
          currentQuantity = (existingData['จำนวน'] is int)
              ? existingData['จำนวน']
              : int.tryParse(existingData['จำนวน'].toString()) ?? 0;
        }

        data['จำนวน'] = currentQuantity + newQuantity;
        data['ราคารวม'] = (currentQuantity + newQuantity) * unitPrice;
        
        await docRef.update(data);
      } else {
        data['createdAt'] = FieldValue.serverTimestamp();
        await collectionRef.add(data);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("บันทึกข้อมูลเรียบร้อย ✅")),
      );

      // ล้างฟอร์ม
      quantityController.text = '0';
      unitPriceController.text = '0';
      purchaseUnitController.clear();
      wholesalePriceController.clear();
      totalPriceController.text = '0';
      setState(() {
        _selectedImage = null;
      });
      
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("เกิดข้อผิดพลาด ❌ $e")),
      );
      print("Firestore Error: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    // เพิ่ม listener เพื่อคำนวณราคารวมอัตโนมัติ
    unitPriceController.addListener(_calculateTotal);
    quantityController.addListener(_calculateTotal);
  }

  @override
  void dispose() {
    unitPriceController.removeListener(_calculateTotal);
    quantityController.removeListener(_calculateTotal);
    unitPriceController.dispose();
    quantityController.dispose();
    purchaseUnitController.dispose();
    wholesalePriceController.dispose();
    totalPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: const Color(0xFF2C3E50),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Input', style: TextStyle(color: Colors.white, fontSize: 18)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_forward, color: Colors.white),
            onPressed: _saveOrUpdatePPE,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // วัน/เวลา
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('วัน/เดือน/ปี และเวลาที่บันทึก',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Apr 1, 2025',
                          style: const TextStyle(fontSize: 14, color: Colors.black87),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '9:41 AM',
                          style: const TextStyle(fontSize: 14, color: Colors.black87),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Dropdown เลือก PPE
            _buildDropdownField('รหัสสินค้า', selectedPPEId,
                ['PPE001','PPE002','PPE003','PPE004','PPE005','PPE006','PPE007','PPE008','PPE009'], (value) {
              setState(() {
                selectedPPEId = value!;
              });
            }),

            // ราคาต่อหน่วย
            _buildTextField('ราคาต่อหน่วย', unitPriceController),

            // รูปภาพสินค้า
            _buildPhotoUploadField('รูปภาพสินค้า'),

            // จำนวนรับเข้า
            _buildTextField('จำนวนรับเข้า', quantityController),

            // หน่วยซื้อ
            _buildTextField('หน่วยซื้อ', purchaseUnitController),

            // ราคาซื้อโดยส่ง
            _buildTextField('ราคาซื้อโดยส่ง (บาท)', wholesalePriceController),

            // ราคารวม
            _buildTextField('ราคารวม (บาท)', totalPriceController, readOnly: true),

            const SizedBox(height: 20), // Space for bottom navigation
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 80,
        decoration: BoxDecoration(
          color: const Color(0xFF2C3E50),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.home, color: Colors.white, size: 28),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.notifications, color: Colors.white, size: 28),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.person, color: Colors.white, size: 28),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownField(
      String label, String value, List<String> items, Function(String?) onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              underline: Container(),
              onChanged: onChanged,
              items: items
                  .map((item) => DropdownMenuItem<String>(value: item, child: Text(item)))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool readOnly = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
          const SizedBox(height: 4),
          Container(
            height: 48,
            child: TextField(
              controller: controller,
              keyboardType: label.contains('หน่วยซื้อ') ? TextInputType.text : TextInputType.numberWithOptions(decimal: true),
              readOnly: readOnly,
              decoration: InputDecoration(
                filled: true,
                fillColor: readOnly ? Colors.grey[100] : Colors.white,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide(color: Colors.grey[300]!)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide(color: Colors.grey[300]!)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: const BorderSide(color: Colors.blue)),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoUploadField(String label) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
          const SizedBox(height: 4),
          Container(
            height: 80,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: InkWell(
              onTap: _pickImage,
              child: _selectedImage != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Image.file(
                        _selectedImage!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 80,
                      ),
                    )
                  : const Center(
                      child: Icon(
                        Icons.image,
                        size: 32,
                        color: Colors.grey,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}