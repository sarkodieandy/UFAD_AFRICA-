import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
import 'package:ufad/payments_management/model/account.dart';
import 'package:ufad/payments_management/model/payment_transaction.dart';
import 'package:ufad/payments_management/model/purchase_model.dart'; // <-- Import your purchase model

class PaymentProvider extends ChangeNotifier {
  final List<Account> _accounts = [
    Account(id: "1", name: "Momo", type: "mobile_money", balance: 24333.33, description: ''),
    Account(id: "23", name: "TERLO SERVICES- GCB", type: "bank", balance: 8000.00, description: ''),
  ];

  final List<Purchase> _purchases = [
    // Dummy purchases (add yours as needed)
    Purchase(id: "p1", item: "IPHONE", supplier: "Test Supplier", amountDue: 3500.00),
    Purchase(id: "p2", item: "CHAIRS", supplier: "Office Depot", amountDue: 6000.00),
  ];

  final List<PaymentTransaction> _transactions = [
    PaymentTransaction(
      id: "t1",
      type: "Deposit",
      account: "1",
      secondaryAccount: null,
      supplier: null,
      purchase: null,
      amount: 1000,
      description: "Initial deposit",
      date: DateTime.now(),
    ),
  ];

  final Map<String, List<String>> _transactionComments = {};

  // ---- GETTERS ----
  List<Account> get accounts => List.unmodifiable(_accounts);
  List<Purchase> get purchases => List.unmodifiable(_purchases); // <--- ADD THIS
  List<PaymentTransaction> get transactions => List.unmodifiable(_transactions);

  double get totalBalance => _accounts.fold(0.0, (sum, a) => sum + a.balance);

  // Filtered transactions (by account/type/date)
  List<PaymentTransaction> filteredTransactions({
    String? accountId,
    String? type,
    DateTime? start,
    DateTime? end,
  }) {
    return _transactions.where((tx) {
      final matchAccount = accountId == null || tx.account == accountId;
      final matchType = type == null || tx.type == type;
      final matchStart = start == null || !tx.date.isBefore(start);
      final matchEnd = end == null || !tx.date.isAfter(end);
      return matchAccount && matchType && matchStart && matchEnd;
    }).toList();
  }

  // ---- ACCOUNT & TRANSACTION LOGIC ----

  void addAccount(Account account) {
    _accounts.add(account);
    notifyListeners();
  }

  void addTransaction(PaymentTransaction tx) {
    _transactions.insert(0, tx);

    // Update account balances based on transaction type
    final mainAccount = _accounts.firstWhereOrNull((a) => a.id == tx.account);
    final secondaryAccount = _accounts.firstWhereOrNull((a) => a.id == tx.secondaryAccount);

    switch (tx.type.toLowerCase()) {
      case 'deposit':
        if (mainAccount != null) mainAccount.balance += tx.amount;
        break;
      case 'expense':
      case 'payment':
        if (mainAccount != null) mainAccount.balance -= tx.amount;
        break;
      case 'transfer':
        if (mainAccount != null) mainAccount.balance -= tx.amount;
        if (secondaryAccount != null) secondaryAccount.balance += tx.amount;
        break;
    }

    notifyListeners();
  }

  // ---- PURCHASE LOGIC (optional, for adding new purchases) ----
  void addPurchase(Purchase purchase) {
    _purchases.add(purchase);
    notifyListeners();
  }

  // ---- COMMENT LOGIC ----

  void addComment(String transactionId, String comment) {
    final comments = _transactionComments.putIfAbsent(transactionId, () => []);
    comments.add(comment);
    notifyListeners();
  }

  List<String> getComments(String transactionId) {
    return _transactionComments[transactionId] ?? [];
  }

  void deleteComment(String transactionId, int index) {
    final comments = _transactionComments[transactionId];
    if (comments != null && index >= 0 && index < comments.length) {
      comments.removeAt(index);
      notifyListeners();
    }
  }
}
