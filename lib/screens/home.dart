import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './../conf.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _total = true;
  int k = 0;
  bool seeAll = false;

  final List<String> imageLinks = [
    'https://s3-alpha-sig.figma.com/img/4287/951c/d56d0ce47cf60b4ac10b5bda4e3d3ad8?Expires=1734307200&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=j1cFdH0ipJFMIB3ibG6tVCnUZsqsyp2VbpjFqL1rYchKpFAL28FKatPOyDV2jBceK3PjNWbx~vVwwrosuO1OTl5ViT0bQdDGdqOwCuxPsYy~kYqddkbgDFsasWWWqMh5vFTuNqXiSOTNkMweWo~Jo8SQAQbdtb97gHKm5V7YPvVZyK0-QiDC8ZnXfodI0KbSFtSmCgxNlbA~OxzKZxlzfeJL~Z2roViGCwf9MJWUqQVdhhwq9WxPlT3StLU5qFk8KpCky3Zf7zP0imNWs4mScKKcZ~bxAQogopjCOYReNojYj4mt3bXl-jMlf5kgIgEQy8aFeDEzx5SWv-FALHz9Dw__',
    'https://s3-alpha-sig.figma.com/img/b5c6/866c/380ea551e51beced165b52ccc218ea53?Expires=1734307200&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=ZnWaeyj4GcyyMQR74wBx7XXLUOCvqKPFvcRZFK-RM3r8PD4MFhYaLAr2ymAvktVp1JsoCd1uZx0AYL8lU8Ejunh44bA-tWF8tuF4NQ3U7EAVZT6n2GkUGmdstj~oAx0yqNxxFRedWPCV-SXXP3ALo2jq3bxYXBJTspyuBdtj0o6d8Yt~Ig48x985RlZS5AvpufqDcA-et~RJx5bIXjnWnZCHWGaIEN1ViSaZ0RH74U7roJrAj7g3c56qASTvwMyAVESG0DrjxCQrsd9pYeyrF41U8PKBpl2O94I5sqe~bPojC0qv9NPUM40vbQFUTvn-ylxRClkQwIo3sG5zHx353w__',
    'https://s3-alpha-sig.figma.com/img/d3d4/59c6/e858e6f489611c178f7e9a05bd359837?Expires=1734307200&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=ed9n0~AbfLsQozYrGvSc3-2QE8tNosNGO3MiTpaYGAyjiGHg7zm3h48PrW5fWnlI5pg4fa8oYbcC~KJv-yOsD28nSCyXyOdIhMgyYNeI-cRGLyvRS7GGni24214pqxFjidI9r2f3qYrJsHHmikPqOOZf7A7EbE62PLzPI6c0R8uyi-OaEE90cHIA~o8B2Cj2D1rEgRuK2OIUBWOcPdBXO2xeYw6U5iBybHA5YNPcVQCcp-zeX5UU8U1atswQvjiZlkMoMRUJmNZiwWRb7xiCk29Z3YtBeQ~J4Q-aLW8fE1U00Vo4p7AGrYbaNF03OjuCG6gFWpCbgXokC3v7bU0ChA__',
    'https://s3-alpha-sig.figma.com/img/2e43/34b3/d5a80abda90d979e3cea243f2c0a99a8?Expires=1734307200&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=P~64LXoeXREAzBm-bhAU-Ogh6ZgL6SWM-5dKGx7at~Q9Y1QozuJma2-88-wJPM6JA1rJwpPUITSd-RIrf55NyZsg4qycsydWSHHqL0~fyuKFcBFBRUxo23vEBoctiH3h8zCmZbW6NRBqNKf8nWJk6bLBJs2E5-ZD0vnHv1tgAPfTb~UuMIIyac6A-pPhjXH9Cacbw7jQw4h7wGx7qKEt5EVkFR90MlLgI54-c-SWQh9N5gIWxSktP1EMb5JOQowmeUGETD6XTZ4SQmJG24NHxoaw2F1gEQ8vd~bTaRUdRXV11Mbprc-56tqMMo1Jx4CGkP6B6p6xtcEdGntNdu6FFQ__',
    'https://s3-alpha-sig.figma.com/img/b371/e94b/2543f6d8a37effc561aed4efea51f99f?Expires=1734307200&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=U0wjvpChnVDqDBf0LSNOvODsuCWex2aqqEjR3kFK5hQTvA99bYlfei3pJhWzw7ev6Sk9V3IqXzRwsqQgy0irNh9wTrfsHeg2vRhe2Hbw6eIeyJzxRXTvGtDCh~w93M5FiGWNw57QKu2gaQ~Us2e4s4YWHd4vDAviibijIfrk9-SRz2dqZ5oGkO3Qr6oCNbmpeZfeRbV7MQ~rMPrPUECDWcTmx6HWBB8UXOuP98Ni2F4j7ULf5G7k-54xmf8xds9shxn86noXHYR9XThKiGGEMGtmS93hyu18HQ7efwjYqNuoXhUpDCH5Cf8Qy~vZGJbFNvrUVwWlOW3xsY1k9q1AYA__',
  ];

  Future<void> _refresh() async {
    setState(() {
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: SingleChildScrollView(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
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
              final data = snapshot.data!.data() as Map<String, dynamic>;
              final income = data['income'] ?? 0;
              final expenses = data['expenses'] ?? 0;
              final totalMoney = (data['totalMoney'] ?? 0) + income - expenses;

              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                color: const Color.fromRGBO(47, 126, 121, 1),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Нийт үлдэгдэл',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text(
                                  _total
                                      ? '\$${totalMoney.toStringAsFixed(2)}'
                                      : '*****',
                                  style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],
                          ),
                          IconButton(
                            icon: Icon(
                              _total ? Icons.visibility : Icons.visibility_off,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                _total = !_total;
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: const Color.fromRGBO(
                                            255, 255, 255, 0.15),
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: const Icon(
                                        Icons.arrow_downward,
                                        size: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    const Text(
                                      'Орлого',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.white),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  '\$${income.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: const Color.fromRGBO(
                                            255, 255, 255, 0.15),
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: const Icon(
                                        Icons.arrow_upward,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    const Text(
                                      'Зардал',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.white),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  '\$${expenses.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(
            height: 10,
          ),
          FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('transaction')
                .doc(Config.user?.uid)
                .get(),
            builder: (context, snapshot) {

              if(!snapshot.hasData || !snapshot.data!.exists || snapshot.connectionState == ConnectionState.waiting){
                return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Гүйлгээний Түүх",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            seeAll = !seeAll;
                          });
                        },
                        child: Text(
                          seeAll ? "Сүүлийнх" : "Бүгдийг харах",
                          style:const TextStyle(
                            color: Color.fromRGBO(102, 102, 102, 1),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  );
              }
              final transactionData =
                  snapshot.data!.data() as Map<String, dynamic>;

              final transactions = List<Map<String, dynamic>>.from(
                  transactionData['transactions'] ?? []);

              transactions.sort((a, b) {
                final dateA = (a['date'] as Timestamp?)?.toDate() ?? DateTime(0);
                final dateB = (b['date'] as Timestamp?)?.toDate() ?? DateTime(0);
                return dateB.compareTo(dateA); // Descending order
              });

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Гүйлгээний Түүх",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            seeAll = !seeAll;
                          });
                        },
                        child: Text(
                          seeAll ? "Сүүлийнх" : "Бүгдийг харах",
                          style:const TextStyle(
                            color: Color.fromRGBO(102, 102, 102, 1),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Transaction List
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: seeAll ? transactions.length : (transactions.length < 4 ? transactions.length : 4),
                    itemBuilder: (context, index) {
                      final transaction = transactions[index];
                      final name = transaction['name'] ?? 'Тодорхойгүй';
                      final amount = transaction['price'] ?? 0.0;
                      final isBuy = transaction['side'] == 'buy';
                      final imageUrl = transaction['image'] ?? '';
                      DateTime? date;

                      try {
                        date = (transaction['date'] as Timestamp).toDate();
                      } catch (_) {
                        date = null;
                      }

                      final formattedDate = date != null
                          ? DateFormat('MMM dd, yyyy').format(date)
                          : 'Unknown Date';

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            // Image container
                            Container(
                              padding: const EdgeInsets.all(
                                  7), // 5 padding all around
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(
                                    240, 246, 245, 1), // rgba(240, 246, 245, 1)
                                borderRadius:
                                    BorderRadius.circular(8), // radius of 8
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
                            Text(
                              '\$${amount.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isBuy ? Colors.green : Colors.red,
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
          const SizedBox(height: 10),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Дахин илгээх",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: imageLinks.length,
              itemBuilder: (context, index) {
                final profile = imageLinks[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child: Image.network(
                          profile,
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.person,
                              size: 60,
                              color: Colors.grey,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    )));
  }
}
