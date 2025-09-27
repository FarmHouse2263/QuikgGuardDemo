import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'register.dart';
import 'jobTitle.dart'; // import JobTitleScreen
import 'package:get_storage/get_storage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final employeeIdController = TextEditingController();  // เปลี่ยนจาก email
  final passwordController = TextEditingController();
  bool isLoading = false;

  final auth = FirebaseAuth.instance;
  final usersCollection = FirebaseFirestore.instance.collection('users');

  Future<void> signIn() async {
    final employeeId = employeeIdController.text.trim();
    final password = passwordController.text.trim();

    if (employeeId.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('กรุณากรอก Employee ID และ Password'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // หา user ใน Firestore ด้วย employeeId
      final query = await usersCollection
          .where('employeeId', isEqualTo: employeeId)
          .limit(1)
          .get();

      if (query.docs.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('ไม่พบผู้ใช้'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final userDoc = query.docs.first;
      final email = userDoc.data()['email']; // ดึง email สำหรับล็อกอิน
      final uid = userDoc.id;

      // ล็อกอินด้วย FirebaseAuth
      final userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);

      // บันทึก employeeId ลง GetStorage
      final box = GetStorage();
      box.write('employeeId', employeeId);

      // ส่ง employeeId ไป JobTitleScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => JobTitleScreen(employeeId: employeeId),
        ),
      );
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'user-not-found') {
        message = 'ไม่พบผู้ใช้';
      } else if (e.code == 'wrong-password') {
        message = 'รหัสผ่านไม่ถูกต้อง';
      } else {
        message = e.message ?? 'เกิดข้อผิดพลาดไม่ทราบสาเหตุ';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    employeeIdController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                const SizedBox(height: 30),
                Image.network(
                  'https://raw.githubusercontent.com/FarmHouse2263/imageQuikgGuard/refs/heads/main/Mask%20group.png',
                  height: 100,
                  width: 400,
                ),
                const SizedBox(height: 20),
                const Text('Login',
                    style:
                        TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                TextField(
                  controller: employeeIdController,
                  decoration: const InputDecoration(
                      hintText: 'Employee ID',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)))),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                      hintText: 'Password',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)))),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 150,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : signIn,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 17, 17, 17),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Sign In', style: TextStyle(fontSize: 18)),
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const RegisterPage()));
                  },
                  child: const Text('Create new account',
                      style: TextStyle(color: Colors.black87)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
