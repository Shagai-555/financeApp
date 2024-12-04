import 'package:flutter/material.dart';

class Bank extends StatefulWidget {
  const Bank({super.key});

  @override
  _BankState createState() => _BankState();
}

class _BankState extends State<Bank> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController cvcController = TextEditingController();
  final TextEditingController expirationController = TextEditingController();
  final TextEditingController accountNumberController = TextEditingController();

  TextField? selectedTextField;

  String cardHolderName = "Нэр: ";
  String cardNumber = "**** **** **** ****";
  String cvc = "***";
  String expirationDate = "MM/YY";

  @override
  void initState() {
    super.initState();

    nameController.addListener(_updateCardHolderName);
    cardNumberController.addListener(_updateCardNumber);
    cvcController.addListener(_updateCVC);
    expirationController.addListener(_updateExpirationDate);
  }

  @override
  void dispose() {
    nameController.dispose();
    cardNumberController.dispose();
    cvcController.dispose();
    expirationController.dispose();
    accountNumberController.dispose();
    super.dispose();
  }

  void _onFocusChanged(TextField textField) {
    setState(() {
      selectedTextField = textField;
    });
  }

  void _updateCardHolderName() {
    setState(() {
      cardHolderName =
          nameController.text.isEmpty ? "Нэр: " : nameController.text;
    });
  }

  void _updateCardNumber() {
    String rawText = cardNumberController.text
        .replaceAll(RegExp(r'\D'), ''); 
    if (rawText.length > 12) {
      rawText = rawText.substring(0, 12);
    }
    String formattedText = '';
    for (int i = 0; i < rawText.length; i++) {
      if (i > 0 && i % 4 == 0) formattedText += ' ';
      formattedText += rawText[i];
    }
    setState(() {
      cardNumber =
          formattedText.isEmpty ? "**** **** **** ****" : formattedText;
    });
  }

  void _updateCVC() {
    String rawText = cvcController.text
        .replaceAll(RegExp(r'\D'), '');
    if (rawText.length > 3) {
      rawText = rawText.substring(0, 3); 
    }
    setState(() {
      cvc = rawText.isEmpty ? "***" : rawText.padLeft(3, '*');
    });
  }

  void _updateExpirationDate() {
    String rawText = expirationController.text
        .replaceAll(RegExp(r'\D'), '');
    if (rawText.length > 4) {
      rawText = rawText.substring(0, 4);
    }
    String formattedText = '';
    if (rawText.length >= 2) {
      formattedText =
          '${rawText.substring(0, 2)}/${rawText.substring(2, rawText.length)}';
    } else {
      formattedText = rawText;
    }
    setState(() {
      expirationDate = formattedText.isEmpty ? "MM/YY" : formattedText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF3E7C78),
                  Color(0xFF36756D)
                ], // Green gradient
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 12,
                  spreadRadius: 3,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Bank Name or Logo (example)
                const Text(
                  "Банк карт",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                // Card Number Placeholder (realistic style)
                Text(
                  cardNumber,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                // Expiration Date and CVC aligned to the right
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      expirationDate,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      cvc,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  cardHolderName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Card Details Form
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Text(
              "КАРТЫН МЭДЭЭЛЭЛ",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  onTap: () => _onFocusChanged(const TextField()),
                  decoration: InputDecoration(
                    labelText: 'КАРТ ДЭЭРХ НЭР',
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
                const SizedBox(height: 16),
                TextField(
                  controller: cardNumberController,
                  keyboardType: TextInputType.number,
                  onTap: () => _onFocusChanged(const TextField()),
                  decoration: InputDecoration(
                    labelText: 'КАРТЫН ДУГААР',
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
                const SizedBox(height: 16),
                Row(
                  children: [
                    Flexible(
                      flex: 2,
                      child: TextField(
                        controller: cvcController,
                        keyboardType: TextInputType.number,
                        onTap: () => _onFocusChanged(const TextField()),
                        decoration: InputDecoration(
                          labelText: 'CVC',
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
                                color: Color.fromRGBO(221, 221, 221, 1),
                                width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                                color: Color.fromRGBO(67, 136, 131, 1),
                                width: 1),
                          ),
                        ),
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Flexible(
                      flex: 3,
                      child: TextField(
                        controller: expirationController,
                        onTap: () => _onFocusChanged(const TextField()),
                        decoration: InputDecoration(
                          labelText: 'ДУУСАХ ХУГАЦАА (MM/YY)',
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
                                color: Color.fromRGBO(221, 221, 221, 1),
                                width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                                color: Color.fromRGBO(67, 136, 131, 1),
                                width: 1),
                          ),
                        ),
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
