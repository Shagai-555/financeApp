import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance/components/bill.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class BillDetailScreen extends StatefulWidget {
  final Map<String, dynamic> transaction;

  const BillDetailScreen({super.key, required this.transaction});

  @override
  _BillDetailScreenState createState() => _BillDetailScreenState();
}

class _BillDetailScreenState extends State<BillDetailScreen> {
  String? selectedButton;

  void onSelect(String label) {
    setState(() {
      selectedButton = label;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> buttons = [
      {'label': 'Дебит карт', 'icon': 'assets/debit.svg'},
      {'label': 'PayPal', 'icon': 'assets/paypal.svg'},
    ];

    final transaction = widget.transaction;
    final name = transaction['name'] ?? 'No Name';
    final imageUrl = transaction['image'] ?? '';
    final amount = transaction['amount'] is String
        ? double.tryParse(transaction['amount'])
        : transaction['amount'];
    DateTime? date;

    try {
      date = (transaction['date'] as Timestamp).toDate();
    } catch (_) {
      date = null;
    }

    final formattedDate =
        date != null ? DateFormat('MMM dd, yyyy').format(date) : 'Unknown Date';

    double fee = (amount ?? 0) * 0.1;
    double total = (amount ?? 0) + fee;

    return Scaffold(
      body: Stack(
        children: [
          // Background Container
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
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Image container
                          Container(
                            padding: const EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(240, 246, 245, 1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: imageUrl.isNotEmpty
                                  ? Image.network(
                                      imageUrl,
                                      width: 40,
                                      height: 40,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return const Icon(
                                          Icons.image_not_supported,
                                          size: 40,
                                          color: Colors.grey,
                                        );
                                      },
                                    )
                                  : const Icon(
                                      Icons.image_not_supported,
                                      size: 40,
                                      color: Colors.grey,
                                    ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  formattedDate,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Price & Fee Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Үнэ: "),
                        Text(
                          amount != null ? amount.toStringAsFixed(2) : 'N/A',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.green[700],
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
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.red[400],
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
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.blue[700],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Төлбөрийн хэрэгслээ сонго",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    // Payment Method Buttons
                    Column(
                      children: buttons.map((button) {
                        final String label =
                            button['label'] as String; // Explicit cast
                        final String icon =
                            button['icon'] as String; // Explicit cast
                        final bool isSelected = selectedButton == label;

                        return GestureDetector(
                          onTap: () {
                            onSelect(
                                label); // No error, since `label` is a String
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            padding: const EdgeInsets.all(25),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color.fromRGBO(67, 136, 131, 0.1)
                                  : const Color.fromRGBO(250, 250, 250, 1),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: isSelected
                                    ? const Color.fromRGBO(67, 136, 131, 0.1)
                                    : const Color.fromRGBO(250, 250, 250, 1),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                      icon,
                                      color: isSelected
                                          ? const Color.fromRGBO(
                                              67, 136, 131, 1)
                                          : const Color.fromRGBO(
                                              136, 136, 136, 1),
                                      placeholderBuilder: (context) =>
                                          const Icon(
                                        Icons.image_not_supported,
                                        color: Colors.grey,
                                        size: 24,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      label,
                                      style: TextStyle(
                                          color: isSelected
                                              ? const Color.fromRGBO(
                                                  67, 136, 131, 1)
                                              : const Color.fromRGBO(
                                                  136, 136, 136, 1),
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                if (isSelected)
                                  const Icon(
                                    Icons.check_circle,
                                    color: Color.fromRGBO(67, 136, 131, 1),
                                  ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BillScreen(
                                  transaction: transaction,
                                  type: selectedButton!),
                            ),
                          );
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
                            "Төлөх",
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
