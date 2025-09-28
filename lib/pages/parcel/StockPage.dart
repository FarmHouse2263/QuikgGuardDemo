import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Stockpage extends StatefulWidget {
  final String employeeId;
  const Stockpage({super.key, required this.employeeId});

  @override
  State<Stockpage> createState() => _StockpageState();
}

class _StockpageState extends State<Stockpage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  // ข้อมูล PPE พร้อมชื่อภาษาไทย
  final Map<String, String> ppeNames = {
    'PPE001': 'หมวกนิรภัย',
    'PPE002': 'รองเท้าเซฟตี้',
    'PPE003': 'แว่นตานิรภัยใส',
    'PPE004': 'ถุงมือกันบาด',
    'PPE005': 'หน้ากากป้องกันฝุ่น',
    'PPE006': 'ear plug ซิลิโคน',
    'PPE007': 'Ear muffs',
    'PPE008': 'เสื้อกันฝน',
    'PPE009': 'อื่นๆ',
  };

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchText = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Stream<QuerySnapshot> _getPPEStream() {
    return FirebaseFirestore.instance.collection('ppe').snapshots();
  }

  List<DocumentSnapshot> _filterDocuments(List<DocumentSnapshot> docs) {
    if (_searchText.isEmpty) {
      return docs;
    }

    return docs.where((doc) {
      final data = doc.data() as Map<String, dynamic>;
      final ppeId = data['ppeid']?.toString().toLowerCase() ?? '';
      final ppeName = ppeNames[data['ppeid']]?.toLowerCase() ?? '';

      return ppeId.contains(_searchText) || ppeName.contains(_searchText);
    }).toList();
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
        title: const Text(
          'Stock',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'ค้นหา',
                hintStyle: TextStyle(color: Colors.grey[600]),
                prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.blue),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),

          // Header Row
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF2C3E50),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    'รหัสสินค้า',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    'รายการ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'จำนวนคงคลัง',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),

          // Stock List
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _getPPEStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'เกิดข้อผิดพลาด: ${snapshot.error}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text(
                      'ไม่มีข้อมูลสินค้า',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  );
                }

                final filteredDocs = _filterDocuments(snapshot.data!.docs);

                if (filteredDocs.isEmpty) {
                  return const Center(
                    child: Text(
                      'ไม่พบข้อมูลที่ค้นหา',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filteredDocs.length,
                  itemBuilder: (context, index) {
                    final doc = filteredDocs[index];
                    final data = doc.data() as Map<String, dynamic>;

                    final ppeId = data['ppeid'] ?? 'Unknown';
                    final quantity = data['จำนวน'] ?? 0;
                    final ppeName = ppeNames[ppeId] ?? 'ไม่ระบุชื่อ';

                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 3,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // PPE ID
                          Expanded(
                            flex: 2,
                            child: Text(
                              ppeId, // แสดงรหัสสินค้าแทน dots
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                                letterSpacing: 1,
                              ),
                            ),
                          ),

                          // PPE Name
                          Expanded(
                            flex: 3,
                            child: Text(
                              ppeName,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                          ),

                          // Quantity
                          Expanded(
                            flex: 2,
                            child: Text(
                              '$quantity / 100',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                              textAlign: TextAlign.center,
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
        height: 80,
        decoration: const BoxDecoration(color: Color(0xFF2C3E50)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.home, color: Colors.white, size: 28),
                  onPressed: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.notifications,
                    color: Colors.white,
                    size: 28,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.person, color: Colors.white, size: 28),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
