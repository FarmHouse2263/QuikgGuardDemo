import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'login.dart';
import 'package:uuid/uuid.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final usernameController = TextEditingController();
  final telController = TextEditingController();
  final employeeIdController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final List<String> positions = [
    'เลือกแผนก',
    'จป.วิชาชีพ',
    'หน.ฝ่ายผลิต',
    'หน.ฝ่ายควบคุมคุณภาพ',
    'หน.ฝ่ายวิศวกรรม',
    'หน.ฝ่ายคลังสินค้า',
    'หน.ฝ่ายก่อสร้าง',
    'หน.ฝายซ่อมบำรุง',
    'หน.ฝ่ายพัสดุ',
  ];
  String? selectedPosition;

  bool isLoading = false;

  final usersCollection = FirebaseFirestore.instance.collection('users');
  final auth = FirebaseAuth.instance;
  final storage = FirebaseStorage.instance;

  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    selectedPosition = positions.first;
  }

  // เลือกรูปจาก Gallery
  Future<void> _pickImage() async {
    try {
      final XFile? picked = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
      );
      if (picked != null) {
        setState(() {
          _profileImage = File(picked.path);
        });
        print('Picked image path: ${_profileImage!.path}');
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  // อัปโหลดรูปไป Firebase Storage โดยสร้างชื่อไฟล์ใหม่ทุกครั้ง
  Future<String?> _uploadProfileImage(File imageFile) async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final fileName = '${Uuid().v4()}.jpg';
      final ref = storage.ref().child('profile_images/$uid/$fileName');

      await ref.putFile(imageFile);
      final url = await ref.getDownloadURL();
      return url;
    } catch (e) {
      print('❌ Upload error: $e');
      return null;
    }
  }

  Future<void> register() async {
    final username = usernameController.text.trim();
    final tel = telController.text.trim();
    final employeeId = employeeIdController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final position = selectedPosition;

    if (username.isEmpty ||
        tel.isEmpty ||
        employeeId.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        position == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('กรุณากรอกข้อมูลให้ครบถ้วนและเลือกตำแหน่ง'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      // สร้างบัญชี Firebase Auth
      final userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final uid = userCredential.user!.uid;

      // อัปโหลดรูปโปรไฟล์ (ถ้ามี)
      String? profileImageUrl;
      if (_profileImage != null) {
        profileImageUrl = await _uploadProfileImage(_profileImage!);
      }

      await usersCollection.doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'username': username,
        'tel': tel,
        'employeeId': employeeId,
        'email': email,
        'password': password,
        'position': position,
        'profileImage': profileImageUrl ?? '', // ใส่ URL ที่ได้
        'createdAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('สมัครสมาชิกเรียบร้อย!'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'email-already-in-use') {
        message = 'อีเมลนี้มีผู้ใช้แล้ว';
      } else if (e.code == 'weak-password') {
        message = 'รหัสผ่านต้องมีความยาวอย่างน้อย 6 ตัวอักษร';
      } else {
        message = e.message ?? 'เกิดข้อผิดพลาดไม่ทราบสาเหตุ';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('เกิดข้อผิดพลาด: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              const SizedBox(height: 20),
              GestureDetector(
                onTap: _pickImage,
                behavior: HitTestBehavior.translucent,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey.shade300,
                  backgroundImage: _profileImage != null
                      ? FileImage(_profileImage!)
                      : null,
                  child: _profileImage == null
                      ? const Icon(
                          Icons.camera_alt,
                          size: 40,
                          color: Colors.white70,
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Create Account',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w300,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 40),
              _buildTextField(usernameController, 'Username'),
              const SizedBox(height: 16),
              _buildTextField(
                telController,
                'Tel.',
                keyboard: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              _buildTextField(employeeIdController, 'Employee ID'),
              const SizedBox(height: 16),
              _buildTextField(
                emailController,
                'Email',
                keyboard: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                passwordController,
                'Password',
                obscureText: true,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedPosition,
                items: positions
                    .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                    .toList(),
                onChanged: (value) => setState(() => selectedPosition = value),
                decoration: InputDecoration(
                  hintText: 'เลือกตำแหน่ง',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 18,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: isLoading ? null : register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(31, 65, 187, 100),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Register',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'เป็นสมาชิกอยู่แล้ว? ',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Text(
                      'เข้าสู่ระบบ',
                      style: TextStyle(
                        color: Color.fromRGBO(31, 65, 187, 100),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hint, {
    bool obscureText = false,
    TextInputType keyboard = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboard,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: const Color.fromRGBO(31, 65, 187, 100)),
        ),
      ),
    );
  }
}
