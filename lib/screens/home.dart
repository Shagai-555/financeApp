import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('users')
                .doc(user?.uid)
                .get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              if (!snapshot.hasData || !snapshot.data!.exists) {
                return const Center(child: Text('No data found'));
              }

              final data = snapshot.data!.data() as Map<String, dynamic>;
              final totalMoney = data['totalMoney'] ?? 0;
              final income = data['income'] ?? 0;
              final expenses = data['expenses'] ?? 0;

              return Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Money: \$${totalMoney.toStringAsFixed(2)}',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Income: \$${income.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Expenses: \$${expenses.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Recent Transactions:',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      // Here you can add a ListView.builder to display transactions
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
