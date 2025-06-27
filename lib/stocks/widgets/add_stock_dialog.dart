import 'package:flutter/material.dart';

class AddStockDialog extends StatefulWidget {
  const AddStockDialog({super.key});
  @override
  State<AddStockDialog> createState() => _AddStockDialogState();
}

class _AddStockDialogState extends State<AddStockDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: SizedBox(
            width: 380,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Add Stock Purchase',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 19,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Color(0xFF21C087)),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                ..._formFields(context),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF21C087),
                        ),
                        onPressed: () {}, // Add logic
                        child: const Text('Add Purchase'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _formFields(BuildContext context) => [
    // Product field with + button
    const Text('Product'),
    Row(
      children: [
        Expanded(
          child: DropdownButtonFormField(
            decoration: const InputDecoration(
              hintText: 'Select Product',
              border: OutlineInputBorder(),
            ),
            items: const [],
            onChanged: (_) {},
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF7B8593),
            minimumSize: const Size(48, 48),
            padding: EdgeInsets.zero,
          ),
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ],
    ),
    const SizedBox(height: 14),
    const Text('Supplier'),
    Row(
      children: [
        Expanded(
          child: DropdownButtonFormField(
            decoration: const InputDecoration(
              hintText: 'Select Supplier',
              border: OutlineInputBorder(),
            ),
            items: const [],
            onChanged: (_) {},
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF7B8593),
            minimumSize: const Size(48, 48),
            padding: EdgeInsets.zero,
          ),
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ],
    ),
    const SizedBox(height: 14),
    const Text('Category'),
    DropdownButtonFormField(
      decoration: const InputDecoration(
        hintText: 'Select Category',
        border: OutlineInputBorder(),
      ),
      items: const [],
      onChanged: (_) {},
    ),
    const SizedBox(height: 14),
    const Text('Unit Cost (GHS)'),
    TextFormField(
      decoration: const InputDecoration(border: OutlineInputBorder()),
    ),
    const SizedBox(height: 14),
    const Text('Selling Price (GHS)'),
    TextFormField(
      decoration: const InputDecoration(border: OutlineInputBorder()),
    ),
    const SizedBox(height: 14),
    const Text('Total Quantity'),
    TextFormField(
      decoration: const InputDecoration(border: OutlineInputBorder()),
    ),
    const SizedBox(height: 14),
    const Text('Payment Account'),
    DropdownButtonFormField(
      decoration: const InputDecoration(
        hintText: 'No Account (Unpaid)',
        border: OutlineInputBorder(),
      ),
      items: const [],
      onChanged: (_) {},
    ),
    const SizedBox(height: 14),
    const Text('Payment Method'),
    DropdownButtonFormField(
      decoration: const InputDecoration(
        hintText: 'Select Method',
        border: OutlineInputBorder(),
      ),
      items: const [],
      onChanged: (_) {},
    ),
    const SizedBox(height: 14),
    const Text('Due Date (if unpaid)'),
    TextFormField(
      readOnly: true,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        suffixIcon: Icon(
          Icons.calendar_today_outlined,
          color: Colors.grey[700],
        ),
      ),
    ),
  ];
}
