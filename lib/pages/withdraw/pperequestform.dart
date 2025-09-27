// หน้าฟอร์มขออุปกรณ์ PPE
import 'package:flutter/material.dart';

class PPERequestForm extends StatefulWidget {
  @override
  _PPERequestFormState createState() => _PPERequestFormState();
}

class _PPERequestFormState extends State<PPERequestForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _employeeIdController = TextEditingController();
  final _departmentController = TextEditingController();
  final _reasonController = TextEditingController();
  
  String? selectedPPEType;
  String? selectedSize;
  int quantity = 1;
  DateTime? requestDate;
  
  List<String> ppeTypes = [
    'หน้ากากอนามัย',
    'ถุงมือยาง',
    'แว่นตานิรภัย',
    'เสื้อกันฝน',
    'รองเท้าบูท',
    'หมวกนิรภัย',
    'เสื้อกั๊กสะท้อนแสง',
  ];
  
  List<String> sizes = ['S', 'M', 'L', 'XL', 'XXL', 'Free Size'];

  @override
  void initState() {
    super.initState();
    requestDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'ขออุปกรณ์ PPE',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.normal,
          ),
        ),
        centerTitle: false,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              
              // ชื่อ-นามสกุล
              _buildTextFormField(
                controller: _nameController,
                label: 'ชื่อ-นามสกุล',
                hint: 'กรอกชื่อ-นามสกุล',
                isRequired: true,
              ),
              SizedBox(height: 15),
              
              // รหัสพนักงาน
              _buildTextFormField(
                controller: _employeeIdController,
                label: 'รหัสพนักงาน',
                hint: 'กรอกรหัสพนักงาน',
                isRequired: true,
              ),
              SizedBox(height: 15),
              
              // แผนก/หน่วยงาน
              _buildTextFormField(
                controller: _departmentController,
                label: 'แผนก/หน่วยงาน',
                hint: 'กรอกแผนก/หน่วยงาน',
                isRequired: true,
              ),
              SizedBox(height: 15),
              
              // ประเภทอุปกรณ์ PPE
              _buildDropdownField(
                label: 'ประเภทอุปกรณ์ PPE',
                value: selectedPPEType,
                items: ppeTypes,
                onChanged: (value) {
                  setState(() {
                    selectedPPEType = value;
                  });
                },
                isRequired: true,
              ),
              SizedBox(height: 15),
              
              // ขนาด
              _buildDropdownField(
                label: 'ขนาด',
                value: selectedSize,
                items: sizes,
                onChanged: (value) {
                  setState(() {
                    selectedSize = value;
                  });
                },
                isRequired: true,
              ),
              SizedBox(height: 15),
              
              // จำนวน
              _buildQuantityField(),
              SizedBox(height: 15),
              
              // วันที่ต้องการใช้
              _buildDateField(),
              SizedBox(height: 15),
              
              // เหตุผลในการขอเบิก
              _buildTextAreaField(
                controller: _reasonController,
                label: 'เหตุผลในการขอเบิก',
                hint: 'กรอกเหตุผลในการขอเบิก',
                isRequired: true,
              ),
              SizedBox(height: 30),
              
              // ปุ่มส่งคำขอ
              _buildSubmitButton(),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 70,
        color: Color(0xFF2C3E50),
        child: Center(
          child: IconButton(
            icon: Icon(
              Icons.home,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () {
              Navigator.popUntil(context, (route) => route.isFirst);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required String hint,
    bool isRequired = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label + (isRequired ? ' *' : ''),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey),
            filled: true,
            fillColor: Color(0xFFF5F5F5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.blue, width: 2),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          ),
          validator: isRequired
              ? (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณากรอก$label';
                  }
                  return null;
                }
              : null,
        ),
      ],
    );
  }

  Widget _buildTextAreaField({
    required TextEditingController controller,
    required String label,
    required String hint,
    bool isRequired = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label + (isRequired ? ' *' : ''),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey),
            filled: true,
            fillColor: Color(0xFFF5F5F5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.blue, width: 2),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          ),
          validator: isRequired
              ? (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณากรอก$label';
                  }
                  return null;
                }
              : null,
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
    bool isRequired = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label + (isRequired ? ' *' : ''),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 8),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: DropdownButtonFormField<String>(
            value: value,
            hint: Text('เลือก$label', style: TextStyle(color: Colors.grey)),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            ),
            items: items.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              );
            }).toList(),
            onChanged: onChanged,
            validator: isRequired
                ? (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณาเลือก$label';
                    }
                    return null;
                  }
                : null,
          ),
        ),
      ],
    );
  }

  Widget _buildQuantityField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'จำนวน *',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            children: [
              IconButton(
                onPressed: quantity > 1
                    ? () {
                        setState(() {
                          quantity--;
                        });
                      }
                    : null,
                icon: Icon(Icons.remove, color: quantity > 1 ? Colors.black : Colors.grey),
              ),
              Expanded(
                child: Text(
                  quantity.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    quantity++;
                  });
                },
                icon: Icon(Icons.add, color: Colors.black),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'วันที่ต้องการใช้ *',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 8),
        InkWell(
          onTap: () async {
            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: requestDate ?? DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(Duration(days: 365)),
            );
            if (picked != null && picked != requestDate) {
              setState(() {
                requestDate = picked;
              });
            }
          },
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            decoration: BoxDecoration(
              color: Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today, color: Colors.grey),
                SizedBox(width: 10),
                Text(
                  requestDate != null
                      ? '${requestDate!.day}/${requestDate!.month}/${requestDate!.year}'
                      : 'เลือกวันที่',
                  style: TextStyle(
                    fontSize: 16,
                    color: requestDate != null ? Colors.black87 : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _submitForm,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          'ส่งคำขอ',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (selectedPPEType == null) {
        _showErrorSnackBar('กรุณาเลือกประเภทอุปกรณ์ PPE');
        return;
      }
      if (selectedSize == null) {
        _showErrorSnackBar('กรุณาเลือกขนาด');
        return;
      }
      if (requestDate == null) {
        _showErrorSnackBar('กรุณาเลือกวันที่ต้องการใช้');
        return;
      }

      // แสดงข้อมูลที่กรอก
      _showSuccessDialog();
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('ส่งคำขอสำเร็จ'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('ข้อมูลคำขอ:'),
              SizedBox(height: 10),
              Text('ชื่อ: ${_nameController.text}'),
              Text('รหัสพนักงาน: ${_employeeIdController.text}'),
              Text('แผนก: ${_departmentController.text}'),
              Text('อุปกรณ์: $selectedPPEType'),
              Text('ขนาด: $selectedSize'),
              Text('จำนวน: $quantity ชิ้น'),
              Text('วันที่ใช้: ${requestDate!.day}/${requestDate!.month}/${requestDate!.year}'),
              Text('เหตุผล: ${_reasonController.text}'),
            ],
          ),
          actions: [
            TextButton(
              child: Text('ตกลง'),
              onPressed: () {
                Navigator.of(context).pop();
                _clearForm();
              },
            ),
          ],
        );
      },
    );
  }

  void _clearForm() {
    _nameController.clear();
    _employeeIdController.clear();
    _departmentController.clear();
    _reasonController.clear();
    setState(() {
      selectedPPEType = null;
      selectedSize = null;
      quantity = 1;
      requestDate = DateTime.now();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _employeeIdController.dispose();
    _departmentController.dispose();
    _reasonController.dispose();
    super.dispose();
  }
}