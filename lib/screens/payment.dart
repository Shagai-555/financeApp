import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance/conf.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:toastification/toastification.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String selectedPaymentType = 'Electricity';
  TextEditingController amountController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  final List<Map<String, String>> paymentTypes = [
    {
      'name': 'Electricity',
      'image': 'https://i.pinimg.com/736x/85/63/44/856344ae5dde9b28523871c46d467576.jpg',
    },
    {
      'name': 'Thermal',
      'image': 'https://i.pinimg.com/736x/cd/5f/8b/cd5f8b232afbee4b46f5391fc29fbcec.jpg',
    },
    {
      'name': 'Netflix',
      'image': 'https://i.pinimg.com/736x/1b/54/ef/1b54efef3720f6ac39647fc420d4a6f9.jpg',
    },
    {
      'name': 'Phone',
      'image': 'https://i.pinimg.com/736x/88/a9/d0/88a9d0c252977e827f7f3862e8de6714.jpg',
    },
    {
      'name': 'Water',
      'image': 'https://i.pinimg.com/736x/1f/97/79/1f977958325d439f37296fbbb40b85a5.jpg',
    },
    {
      'name': 'Internet',
      'image': 'https://i.pinimg.com/736x/78/1f/b1/781fb1662b502d7bdd6bf0887e984f7f.jpg',
    },
    {
      'name': 'Gas',
      'image': 'https://i.pinimg.com/736x/27/00/9d/27009d0cb00116757b5da240dfe260d1.jpg',
    },
    {
      'name': 'Spotify',
      'image': 'https://i.pinimg.com/736x/b9/e2/d8/b9e2d8f9e0be04f3c1a98632bab95efd.jpg',
    },
    {
      'name': 'Amazon',
      'image': 'https://i.pinimg.com/736x/fa/16/b8/fa16b892512b3df516211c68fc489134.jpg',
    },
    {
      'name': 'Apple Music',
      'image': 'https://i.pinimg.com/736x/1e/a6/33/1ea6337e0c1cfaadcd5e3935a1641e2a.jpg',
    },
  ];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        dateController.text = DateFormat.yMd().format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Container
          Container(
            height: MediaQuery.of(context).size.height,
          ),
          Container(
            height: 180,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF3E7C78), Color(0xFF4C9B91)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Back Button (Leading Button)
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Төлбөр нэмэх",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                // Notification Icon
                Container(
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(255, 255, 255, 0.06),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: IconButton(
                    icon: SvgPicture.asset('assets/notif.svg'),
                    onPressed: () {
                      // Handle notification action
                    },
                  ),
                ),
              ],
            ),
          ),

          // Main Content Section
          Positioned.fill(
            top: 140,
            bottom: 70,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    // Custom Dropdown with decoration
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 2,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: DropdownButton<Map<String, String>>(
                        value: paymentTypes.firstWhere(
                          (element) => element['name'] == selectedPaymentType,
                        ),
                        onChanged: (Map<String, String>? newValue) {
                          setState(() {
                            selectedPaymentType = newValue!['name']!;
                          });
                        },
                        items: paymentTypes.map<DropdownMenuItem<Map<String, String>>>(
                          (Map<String, String> value) {
                            return DropdownMenuItem<Map<String, String>>(
                              value: value,
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: value['name'] == selectedPaymentType
                                      ? Colors.green.shade50
                                      : Colors.transparent,
                                ),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.network(
                                        value['image']!,
                                        width: 30,
                                        height: 30,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      value['name']!,
                                      style: TextStyle(
                                        color: value['name'] == selectedPaymentType
                                            ? Colors.green
                                            : Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ).toList(),
                        isExpanded: true,
                        style: const TextStyle(color: Colors.black),
                        icon: const Icon(Icons.arrow_drop_down, color: Colors.green),
                        iconSize: 30,
                        underline: Container(),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Amount TextField
                    TextField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'ҮНИЙН ДҮН',
                        labelStyle: const TextStyle(color: Colors.black),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                              color: Color.fromRGBO(221, 221, 221, 1), width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                              color: Color.fromRGBO(67, 136, 131, 1), width: 1),
                        ),
                      ),
                      style: const TextStyle(color: Colors.black),
                    ),
                    const SizedBox(height: 20),

                    // Date TextField
                    TextField(
                      controller: dateController,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'ОГНОО',
                        labelStyle: const TextStyle(color: Colors.black),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                              color: Color.fromRGBO(221, 221, 221, 1), width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                              color: Color.fromRGBO(67, 136, 131, 1), width: 1),
                        ),
                      ),
                      style: const TextStyle(color: Colors.black),
                      onTap: () => _selectDate(context),
                    ),
                    const SizedBox(height: 30),

                    // Add Payment Button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        side: const BorderSide(
                          color: Color(0xFF3E7C78),
                          width: 2,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {
                        final amount = amountController.text;
                        final date = dateController.text;

                        DateTime? dateTime = DateFormat.yMd().parse(date);

                        Timestamp timestamp = Timestamp.fromDate(dateTime);

                        String selectedImageUrl = paymentTypes.firstWhere(
                          (element) => element['name'] == selectedPaymentType,
                        )['image']!;

                        if (amount.isNotEmpty && date.isNotEmpty) {
                          FirebaseFirestore.instance
                              .collection('users')
                              .doc(Config.user?.uid)
                              .set({
                            'payment': FieldValue.arrayUnion([{
                              'name': selectedPaymentType,
                              'image': selectedImageUrl,
                              'amount': amount,
                              'date': timestamp,
                            }])
                          }, SetOptions(merge: true)).then((value) {
                            toastification.show(
                              context: context,
                              title: const Text(
                                "Амжилттай!",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF3E7C78),
                                ),
                              ),
                              description: const Text(
                                "Төлбөр амжилттай нэмэгдлээ!",
                                style: TextStyle(
                                  color: Color(0xFF3E7C78),
                                ),
                              ),
                              type: ToastificationType.success,
                              autoCloseDuration: const Duration(seconds: 3),
                            );
                            amountController.clear();
                            dateController.clear();
                            Navigator.pop(context);
                          });
                        } else {
                          toastification.show(
                            context: context,
                            title: const Text(
                              "Амжилтгүй!",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF3E7C78),
                              ),
                            ),
                            description: const Text(
                              "Та дүн болон огноо оруулна уу!",
                              style: TextStyle(
                                color: Color(0xFF3E7C78),
                              ),
                            ),
                            type: ToastificationType.error,
                            autoCloseDuration: const Duration(seconds: 3),
                          );
                        }
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Text(
                          'ТӨЛБӨР НЭМЭХ',
                          style: TextStyle(
                            color: Color(0xFF3E7C78),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
