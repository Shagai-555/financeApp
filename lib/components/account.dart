import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Account extends StatelessWidget {
  final String selectedButton;
  final Function(String) onSelect;

  const Account({
    super.key,
    required this.selectedButton,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> buttons = [
      {'label': 'Банкны холбоос', 'icon': 'assets/link.svg'},
      {'label': 'Microdeposits', 'icon': 'assets/depo.svg'},
      {'label': 'PayPal', 'icon': 'assets/paypal.svg'},
    ];

    return Column(
      children: buttons.map((button) {
        final String label = button['label'] as String; 
        final String icon = button['icon'] as String;
        final bool isSelected = selectedButton == label;

        return GestureDetector(
          onTap: () {
            onSelect(label); 
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
                          ? const Color.fromRGBO(67, 136, 131, 1)
                          : const Color.fromRGBO(136, 136, 136, 1),
                      placeholderBuilder: (context) => const Icon(
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
                              ? const Color.fromRGBO(67, 136, 131, 1)
                              : const Color.fromRGBO(136, 136, 136, 1),
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
    );
  }
}
