import 'package:flutter/material.dart';

class BudgetOptionsWidget extends StatelessWidget {
  final List<BudgetOption> budgetOptions;

  const BudgetOptionsWidget({Key? key, required this.budgetOptions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Budget in mind',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Container(
          height: 100, // Adjust height as needed
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: budgetOptions.length,
            itemBuilder: (context, index) {
              final option = budgetOptions[index];
              return Padding(
                padding: EdgeInsets.only(right: 10),
                child: BudgetOptionCard(option: option),
              );
            },
          ),
        ),
      ],
    );
  }
}

class BudgetOption {
  final String label;
  final int priceInLakhs;
  final int sqft;

  BudgetOption({
    required this.label,
    required this.priceInLakhs,
    required this.sqft,
  });
}

class BudgetOptionCard extends StatelessWidget {
  final BudgetOption option;

  const BudgetOptionCard({Key? key, required this.option}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              option.label,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              '₹ ${option.priceInLakhs} Lakhs',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
            ),
            SizedBox(height: 8),
            Text(
              '${option.sqft} sq.ft',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
