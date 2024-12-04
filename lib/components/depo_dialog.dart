import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance/conf.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class DepositDialog extends StatelessWidget {
  const DepositDialog({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController amountController = TextEditingController();

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          gradient: LinearGradient(
            colors: [Color(0xFF3E7C78), Color(0xFF1E4E50)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Депозитийн хэмжээ оруулна уу",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white.withOpacity(0.1),
                hintText: "\$ Хэмжээ",
                hintStyle: const TextStyle(color: Colors.white54),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text("Болих"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      String amountText = amountController.text.trim();
                      if (amountText.isNotEmpty) {
                        double amount = double.tryParse(amountText) ?? 0;
                        if (amount > 0) {
                          try {
                            final userDoc = FirebaseFirestore.instance
                                .collection('users')
                                .doc(Config.user?.uid);

                            await FirebaseFirestore.instance.runTransaction(
                              (transaction) async {
                                final snapshot = await transaction.get(userDoc);

                                if (!snapshot.exists) {
                                  transaction.set(userDoc, {
                                    'income': amount,
                                  });
                                } else {
                                  double currentIncome =
                                      (snapshot.data()?['income'] ?? 0)
                                          .toDouble();
                                  transaction.update(userDoc, {
                                    'income': currentIncome + amount,
                                  });
                                }

                                final transactionData = {
                                  'name':
                                      'Депозит',
                                  'price': amount,
                                  'side': 'buy',
                                  'image':
                                      'https://i.pinimg.com/736x/81/e2/cb/81e2cb082f344dc0dd2040cf20ac506b.jpg', 
                                  'date': Timestamp.now(),
                                };

                                try {
                                  await FirebaseFirestore
                                      .instance
                                      .collection('transaction')
                                      .doc(Config.user?.uid)
                                      .set({
                                    'transactions': FieldValue.arrayUnion([transactionData])
                                  }, SetOptions(merge: true));

                                } catch (e) {
                                  print('Error while adding document: $e');
                                  toastification.show(
                                    context: context,
                                    title: const Text("Алдаа гарлаа"),
                                    description: Text(
                                        "Мэдээллийг хадгалах үед алдаа гарлаа: $e"),
                                    type: ToastificationType.error,
                                    autoCloseDuration:
                                        const Duration(seconds: 3),
                                  );
                                }
                              },
                            );

                            toastification.show(
                              context: context,
                              title: const Text(
                                "Амжилттай!",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF3E7C78),
                                ),
                              ),
                              description: Text(
                                "$amount төгрөг цэнэглэгдлээ!",
                                style: const TextStyle(
                                  color: Color(0xFF3E7C78),
                                ),
                              ),
                              type: ToastificationType.success,
                              autoCloseDuration: const Duration(seconds: 3),
                            );

                            Navigator.pop(context);
                            Navigator.pop(context);
                            
                          } catch (e) {
                            toastification.show(
                              context: context,
                              title: const Text(
                                "Алдаа гарлаа",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.redAccent,
                                ),
                              ),
                              description: const Text(
                                "Мэдээллийг хадгалах үед алдаа гарлаа.",
                                style: TextStyle(color: Colors.red),
                              ),
                              type: ToastificationType.error,
                              autoCloseDuration: const Duration(seconds: 3),
                            );
                          }
                        } else {
                          toastification.show(
                            context: context,
                            title: const Text(
                              "Буруу утга",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                              ),
                            ),
                            description: const Text(
                              "Та зөв тоо оруулна уу.",
                              style: TextStyle(color: Colors.orangeAccent),
                            ),
                            type: ToastificationType.warning,
                            autoCloseDuration: const Duration(seconds: 3),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF3E7C78),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text("Батлах"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
