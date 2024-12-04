import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:toastification/toastification.dart';

class RecieptScreen extends StatefulWidget {
  final Map<String, dynamic> transaction;
  final String type;

  const RecieptScreen({super.key, required this.transaction, required this.type});

  @override
  _RecieptScreenState createState() => _RecieptScreenState();
}

class _RecieptScreenState extends State<RecieptScreen> {
  String generateRandomNumber() {
    final random = Random();
    int firstPart = random.nextInt(900000000) + 100000000;
    int secondPart = random.nextInt(100000000); 

    return '$firstPart$secondPart';
  }

  @override
  Widget build(BuildContext context) {
    final randomNumber = generateRandomNumber();
    final transaction = widget.transaction;
    final name = transaction['name'] ?? 'No Name';
    final amount = transaction['amount'] is String
        ? double.tryParse(transaction['amount'])
        : transaction['amount'];
    DateTime date = DateTime.now();

    double fee = (amount ?? 0) * 0.1;
    double total = (amount ?? 0) + fee;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            color: Colors.blue[50],
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
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                const Text(
                  "Төлбөр нэмэх",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(255, 255, 255, 0.06),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: IconButton(
                    icon: SvgPicture.asset('assets/notif.svg'),
                    onPressed: () {
                    },
                  ),
                ),
              ],
            ),
          ),
          Positioned.fill(
            top: 140,
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
                    const SizedBox(height: 10),
                    const Text(
                      'Амжилттай төлөгдлөө',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: Color(0xFF3E7C78),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                        color: Color.fromRGBO(102, 102, 102, 1),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Төлбөрийн хэрэгсэл "),
                        Text(
                          widget.type,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Төлөв"),
                        Text(
                          "Хийгдсэн",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Color(0xFF3E7C78),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Цаг"),
                        Text(
                          DateFormat('HH:mm')
                              .format(date),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Огноо"),
                        Text(
                          DateFormat('MMM dd,yyyy').format(date),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Гүйлгээний дугаар"),
                        Text(
                          randomNumber,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                        InkWell(
                          child: const Icon(
                            Icons.copy,
                            color: Color(0xFF3E7C78),
                            size: 20,
                          ),
                          onTap: () {
                            Clipboard.setData(ClipboardData(text: randomNumber))
                                .then((_) {
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
                                'Гүйлгээний дугаар амжилттай хуулагдлаа!',
                                style: TextStyle(
                                  color: Color(0xFF3E7C78),
                                ),
                              ),
                              type: ToastificationType.success,
                              autoCloseDuration: const Duration(seconds: 3),
                            );
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Divider(),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Үнэ: "),
                        Text(
                          amount != null ? amount.toStringAsFixed(2) : 'N/A',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Хураамж: "),
                        Text(
                          fee.toStringAsFixed(2),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Divider(),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Нийт: "),
                        Text(
                          total.toStringAsFixed(2),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SvgPicture.asset(
                      "assets/code.svg",
                      color: const Color.fromRGBO(67, 136, 131, 1),
                      placeholderBuilder: (context) => const Icon(
                        Icons.image_not_supported,
                        color: Colors.grey,
                        size: 102,
                      ),
                    ),
                    InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: 200,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(236, 249, 248, 1),
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(
                                color: const Color.fromRGBO(64, 135, 130, 1)),
                          ),
                          child: const Text(
                            textAlign: TextAlign.center,
                            "Болсон",
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF3E7C78),
                            ),
                          ),
                        ))
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
