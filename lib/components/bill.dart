import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance/components/reciept.dart';
import 'package:finance/conf.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:toastification/toastification.dart';

class BillScreen extends StatefulWidget {
  final Map<String, dynamic> transaction;
  final String type;

  const BillScreen({super.key, required this.transaction, required this.type});

  @override
  _BillScreenState createState() => _BillScreenState();
}

class _BillScreenState extends State<BillScreen> {
  @override
  Widget build(BuildContext context) {
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
                              borderRadius: BorderRadius.circular(50),
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
                    const SizedBox(
                      height: 50,
                    ),
                    InkWell(
                        onTap: () {
                          if (date == null) {
                            return;
                          }

                          final transactionData = {
                            'name': name,
                            'price': amount != null ? amount * 1.1 : 0.0,
                            'side': 'sell',
                            'image': imageUrl,
                            'date': Timestamp.now(),
                          };

                          FirebaseFirestore.instance
                              .collection('transaction')
                              .doc(Config.user?.uid)
                              .set({
                            'transactions':
                                FieldValue.arrayUnion([transactionData])
                          }, SetOptions(merge: true));

                          FirebaseFirestore.instance
                              .collection('users')
                              .doc(Config.user?.uid)
                              .get()
                              .then((docSnapshot) {
                            if (docSnapshot.exists) {
                              double currentExpense =
                                  (docSnapshot.data()?['expenses'] ?? 0)
                                      .toDouble();

                              double updatedExpense = currentExpense + total;

                              FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(Config.user?.uid)
                                  .update({
                                'expenses': updatedExpense,
                              });
                            } else {
                              print('User document not found!');
                            }
                          }).catchError((error) {
                            print("Error fetching user document: $error");
                          });

                          FirebaseFirestore.instance
                              .collection('users')
                              .doc(Config.user?.uid)
                              .update({
                            'payment': FieldValue.arrayRemove([
                              {
                                'name': name,
                                'image': imageUrl,
                                'amount': amount,
                                'date': Timestamp.fromDate(date),
                              }
                            ])
                          }).then((value) {
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
                          }).catchError((error) {
                            toastification.show(
                              context: context,
                              title: const Text(
                                "Алдаа гарлаа!",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                              description: Text(
                                "Төлбөрийг устгахад алдаа гарлаа: $error",
                                style: const TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                              type: ToastificationType.error,
                              autoCloseDuration: const Duration(seconds: 3),
                            );
                          });

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RecieptScreen(
                                transaction: transaction,
                                type: widget.type,
                              ),
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
                            "Баталгаажуулах",
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
