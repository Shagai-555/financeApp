import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance/components/bill_detail.dart';
import 'package:finance/conf.dart';
import 'package:finance/screens/payment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  String activeButton = 'Гүйлгээнүүд';
  String selectedAccountButton = '';

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
                      "Түрийвч",
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
                    const SizedBox(
                      height: 20,
                    ),
                    FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('users')
                          .doc(Config.user?.uid)
                          .get(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xFF3E7C78)),
                              strokeWidth: 6,
                            );
                          }
                        final data =
                            snapshot.data!.data() as Map<String, dynamic>;
                        final income = data['income'] ?? 0;
                        final expenses = data['expenses'] ?? 0;
                        final totalMoney =
                            (data['totalMoney'] ?? 0) + income - expenses;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              'Нийт үлдэгдэл',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Color.fromRGBO(102, 102, 102, 1),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              '\$${totalMoney.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const PaymentScreen()),
                                );
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(50),
                                  border: Border.all(
                                      color: const Color.fromRGBO(
                                          64, 135, 130, 1)),
                                ),
                                child: SvgPicture.asset(
                                  "assets/add.svg",
                                  color: const Color.fromRGBO(67, 136, 131, 1),
                                  placeholderBuilder: (context) => const Icon(
                                    Icons.image_not_supported,
                                    color: Colors.grey,
                                    size: 24,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 2,
                            ),
                            const Text(
                              'Нэмэх',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Color.fromRGBO(102, 102, 102, 1),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            InkWell(
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(50),
                                  border: Border.all(
                                      color: const Color.fromRGBO(
                                          64, 135, 130, 1)),
                                ),
                                child: SvgPicture.asset(
                                  "assets/qr.svg",
                                  color: const Color.fromRGBO(67, 136, 131, 1),
                                  placeholderBuilder: (context) => const Icon(
                                    Icons.image_not_supported,
                                    color: Colors.grey,
                                    size: 24,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 2,
                            ),
                            const Text(
                              'Төлөх',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Color.fromRGBO(102, 102, 102, 1),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            InkWell(
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(50),
                                  border: Border.all(
                                      color: const Color.fromRGBO(
                                          64, 135, 130, 1)),
                                ),
                                child: SvgPicture.asset(
                                  "assets/send.svg",
                                  color: const Color.fromRGBO(67, 136, 131, 1),
                                  placeholderBuilder: (context) => const Icon(
                                    Icons.image_not_supported,
                                    color: Colors.grey,
                                    size: 24,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 2,
                            ),
                            const Text(
                              'Илгээх',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Color.fromRGBO(102, 102, 102, 1),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(244, 246, 246, 1),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    activeButton = 'Гүйлгээнүүд';
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: activeButton == 'Гүйлгээнүүд'
                                        ? Colors.white
                                        : const Color.fromRGBO(
                                            244, 246, 246, 1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.transfer_within_a_station,
                                        color: activeButton == 'Гүйлгээнүүд'
                                            ? Colors.black
                                            : Colors.grey,
                                      ),
                                      const SizedBox(width: 5),
                                      const Text(
                                        "Гүйлгээнүүд",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    activeButton = 'Хүлээгдэж буй';
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: activeButton == 'Хүлээгдэж буй'
                                        ? Colors.white
                                        : const Color.fromRGBO(
                                            244, 246, 246, 1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.access_time,
                                        color: activeButton == 'Хүлээгдэж буй'
                                            ? Colors.black
                                            : Colors.grey,
                                      ),
                                      const SizedBox(width: 5),
                                      const Text(
                                        "Төлбөр",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Visibility(
                      visible: activeButton == "Гүйлгээнүүд",
                      child: FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance
                            .collection('transaction')
                            .doc(Config.user?.uid)
                            .get(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xFF3E7C78)),
                              strokeWidth: 6,
                            );
                          }

                          if (!snapshot.hasData || !snapshot.data!.exists) {
                            return const Center();
                          }

                          final transactionData =
                              snapshot.data!.data() as Map<String, dynamic>;

                          final transactions = List<Map<String, dynamic>>.from(
                              transactionData['transactions'] ?? []);

                          transactions.sort((a, b) {
                            final dateA = (a['date'] as Timestamp?)?.toDate() ??
                                DateTime(0);
                            final dateB = (b['date'] as Timestamp?)?.toDate() ??
                                DateTime(0);
                            return dateB.compareTo(dateA); // Descending order
                          });

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Transaction List
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: transactions.length,
                                itemBuilder: (context, index) {
                                  final transaction = transactions[index];
                                  final name =
                                      transaction['name'] ?? 'Тодорхойгүй';
                                  final amount = transaction['price'] ?? 0.0;
                                  final isBuy = transaction['side'] == 'buy';
                                  final imageUrl = transaction['image'] ?? '';
                                  DateTime? date;

                                  try {
                                    date = (transaction['date'] as Timestamp)
                                        .toDate();
                                  } catch (_) {
                                    date = null;
                                  }

                                  final formattedDate = date != null
                                      ? DateFormat('MMM dd, yyyy').format(date)
                                      : 'Unknown Date';

                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: Row(
                                      children: [
                                        // Image container
                                        Container(
                                          padding: const EdgeInsets.all(
                                              7), // 5 padding all around
                                          decoration: BoxDecoration(
                                            color: const Color.fromRGBO(
                                                240,
                                                246,
                                                245,
                                                1), // rgba(240, 246, 245, 1)
                                            borderRadius: BorderRadius.circular(
                                                8), // radius of 8
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                                50), // radius for the image
                                            child: imageUrl.isNotEmpty
                                                ? Image.network(
                                                    imageUrl,
                                                    width: 40,
                                                    height: 40,
                                                    fit: BoxFit.cover,
                                                    errorBuilder: (context,
                                                        error, stackTrace) {
                                                      return const Icon(
                                                        Icons
                                                            .image_not_supported,
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
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
                                        Text(
                                          '\$${amount.toStringAsFixed(2)}',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: isBuy
                                                ? Colors.green
                                                : Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    Visibility(
                      visible: activeButton != "Гүйлгээнүүд",
                      child: FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance
                            .collection('users')
                            .doc(Config.user?.uid)
                            .get(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xFF3E7C78)),
                              strokeWidth: 6,
                            );
                          }

                          if (!snapshot.hasData || !snapshot.data!.exists) {
                            return const Center();
                          }

                          final transactionData =
                              snapshot.data!.data() as Map<String, dynamic>;

                          final transactions = List<Map<String, dynamic>>.from(
                              transactionData['payment'] ?? []);

                          transactions.sort((a, b) {
                            final dateA = (b['date'] as Timestamp?)?.toDate() ??
                                DateTime(0);
                            final dateB = (a['date'] as Timestamp?)?.toDate() ??
                                DateTime(0);
                            return dateB.compareTo(dateA); // Descending order
                          });

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Transaction List
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: transactions.length,
                                itemBuilder: (context, index) {
                                  final transaction = transactions[index];
                                  final name =
                                      transaction['name'] ?? 'Тодорхойгүй';
                                  final imageUrl = transaction['image'] ?? '';
                                  DateTime? date;

                                  try {
                                    date = (transaction['date'] as Timestamp)
                                        .toDate();
                                  } catch (_) {
                                    date = null;
                                  }

                                  final formattedDate = date != null
                                      ? DateFormat('MMM dd, yyyy').format(date)
                                      : 'Unknown Date';

                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: Row(
                                      children: [
                                        // Image container
                                        Container(
                                          padding: const EdgeInsets.all(
                                              7), // 5 padding all around
                                          decoration: BoxDecoration(
                                            color: const Color.fromRGBO(
                                                240,
                                                246,
                                                245,
                                                1), // rgba(240, 246, 245, 1)
                                            borderRadius: BorderRadius.circular(
                                                8), // radius of 8
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                                50), // radius for the image
                                            child: imageUrl.isNotEmpty
                                                ? Image.network(
                                                    imageUrl,
                                                    width: 40,
                                                    height: 40,
                                                    fit: BoxFit.cover,
                                                    errorBuilder: (context,
                                                        error, stackTrace) {
                                                      return const Icon(
                                                        Icons
                                                            .image_not_supported,
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
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
                                        InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      BillDetailScreen(
                                                          transaction:
                                                              transaction),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10,
                                                      horizontal: 15),
                                              decoration: BoxDecoration(
                                                color: const Color.fromRGBO(
                                                    236, 249, 248, 1),
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                border: Border.all(
                                                    color: const Color.fromRGBO(
                                                        64, 135, 130, 1)),
                                              ),
                                              child: const Text(
                                                "Төлөх",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Color(0xFF3E7C78),
                                                ),
                                              ),
                                            ))
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          );
                        },
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
