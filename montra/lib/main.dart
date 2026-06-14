
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:montra/expense2.dart';
import 'package:montra/income2.dart';
import 'package:montra/login.dart';
import 'package:montra/profile.dart';

import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SignInPage(),
    );
  }
}

class Myhome extends StatefulWidget {
  final String username;
  const Myhome({super.key, required this.username});

  @override
  State<Myhome> createState() => _MyhomeState();
}

class _MyhomeState extends State<Myhome> {
  bool isHidden = true;
  double income = 0;
  double expense = 0;
  List<Map<String, dynamic>> incomeList = [];
  List<Map<String, dynamic>> expenseList = [];

  // Tracks which card index is expanded (null = none)
  int? _expandedIncomeIndex;
  int? _expandedExpenseIndex;

  String get _incomeKey  => 'income_${widget.username}';
  String get _expenseKey => 'expense_${widget.username}';

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    final prefs = await SharedPreferences.getInstance();

    final incomeJson  = prefs.getString(_incomeKey);
    final expenseJson = prefs.getString(_expenseKey);

    final List<Map<String, dynamic>> loadedIncome =
        incomeJson != null
            ? List<Map<String, dynamic>>.from(jsonDecode(incomeJson))
            : [];

    final List<Map<String, dynamic>> loadedExpense =
        expenseJson != null
            ? List<Map<String, dynamic>>.from(jsonDecode(expenseJson))
            : [];

    double totalIncome  = loadedIncome.fold(0, (sum, e) => sum + (double.tryParse(e['amount'].toString()) ?? 0));
    double totalExpense = loadedExpense.fold(0, (sum, e) => sum + (double.tryParse(e['amount'].toString()) ?? 0));

    setState(() {
      incomeList  = loadedIncome;
      expenseList = loadedExpense;
      income      = totalIncome;
      expense     = totalExpense;
    });
  }

  Future<void> _saveTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_incomeKey,  jsonEncode(incomeList));
    await prefs.setString(_expenseKey, jsonEncode(expenseList));
  }

  void _deleteIncome(int index) {
    setState(() {
      income -= double.tryParse(incomeList[index]['amount'].toString()) ?? 0;
      incomeList.removeAt(index);
      _expandedIncomeIndex = null;
    });
    _saveTransactions();
  }

  void _deleteExpense(int index) {
    setState(() {
      expense -= double.tryParse(expenseList[index]['amount'].toString()) ?? 0;
      expenseList.removeAt(index);
      _expandedExpenseIndex = null;
    });
    _saveTransactions();
  }

  Future<void> _confirmDelete(BuildContext ctx, String type, int index) async {
    final confirmed = await showDialog<bool>(
      context: ctx,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: const Color(0xFF1E2130),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Delete Transaction',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: const Text('Are you sure you want to delete this transaction?',
            style: TextStyle(color: Colors.grey)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx, false),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      if (type == 'income') {
        _deleteIncome(index);
      } else {
        _deleteExpense(index);
      }
    }
  }


  Widget _buildTransactionCard({
    required Map<String, dynamic> item,
    required int index,
    required String type,
  }) {
    final isIncome  = type == 'income';
    final color     = isIncome ? Colors.green : Colors.red;
    final icon      = isIncome ? Icons.trending_up : Icons.trending_down;
    final bgColor   = isIncome ? Colors.green.withOpacity(0.15) : Colors.red.withOpacity(0.15);
    final prefix    = isIncome ? '+ ₹' : '- ₹';

    final isExpanded = isIncome
        ? _expandedIncomeIndex == index
        : _expandedExpenseIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          if (isIncome) {
            _expandedIncomeIndex = isExpanded ? null : index;
          } else {
            _expandedExpenseIndex = isExpanded ? null : index;
          }
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 50, 47, 45),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            
            Row(
              children: [
                // ICON
                CircleAvatar(
                  radius: 26,
                  backgroundColor: bgColor,
                  child: Icon(icon, color: color, size: 26),
                ),

                const SizedBox(width: 14),

                
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['name'] ?? '',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          item['category'] ?? '',
                          style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),

                
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '$prefix${item["amount"]}',
                      style: TextStyle(
                        color: color,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Icon(
                      isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                      color: Colors.grey,
                      size: 20,
                    ),
                  ],
                ),
              ],
            ),

            
            if (isExpanded) ...[
              const SizedBox(height: 14),
              const Divider(color: Colors.white12, height: 1),
              const SizedBox(height: 12),

             
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.notes, color: Colors.grey, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      item['description'] ?? '-',
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              
              Row(
                children: [
                  const Icon(Icons.calendar_today_outlined, size: 14, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text(
                    item['date'] ?? '',
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ],
              ),

              const SizedBox(height: 12),

             
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () => _confirmDelete(context, type, index),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.delete_outline, color: Colors.red, size: 16),
                        SizedBox(width: 5),
                        Text('Delete', style: TextStyle(color: Colors.red, fontSize: 13)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFF0F111A),

        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.green[900],
          onPressed: () {
            showModalBottomSheet(
              context: context,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
              ),
              builder: (ctx) {
                return Padding(
                  padding: const EdgeInsets.all(25),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Add Transaction",
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      const SizedBox(height: 25),

                      
                      SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            Navigator.pop(ctx);
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const IncomeAdd()),
                            );
                            if (result != null) {
                              setState(() {
                                income += double.tryParse(result["amount"].toString()) ?? 0;
                                incomeList.insert(0, result);
                              });
                              await _saveTransactions();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[900],
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                          ),
                          icon: const Icon(Icons.arrow_upward, color: Colors.white),
                          label: const Text("Add Income",
                              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                        ),
                      ),

                      const SizedBox(height: 15),

                     
                      SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            Navigator.pop(ctx);
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const ExpenseAdd()),
                            );
                            if (result != null) {
                              setState(() {
                                expense += double.tryParse(result["amount"].toString()) ?? 0;
                                expenseList.insert(0, result);
                              });
                              await _saveTransactions();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                          ),
                          icon: const Icon(Icons.arrow_downward, color: Colors.white),
                          label: const Text("Add Expense",
                              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
          child: const Icon(Icons.add, color: Colors.white, size: 32),
        ),

        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // TOP ROW
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "My Wallet",
                      style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: const Color.fromARGB(255, 50, 47, 45),
                      child: IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => ProfilePage(username: widget.username)),
                          );
                        },
                        icon: const Icon(Icons.person, color: Colors.white),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 25),

              
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 254, 255, 239),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text("Total Balance", style: TextStyle(color: Colors.black, fontSize: 18)),
                          Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: IconButton(
                              onPressed: () => setState(() => isHidden = !isHidden),
                              icon: Icon(
                                isHidden ? Icons.visibility_off : Icons.visibility,
                                color: Colors.black,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            isHidden ? "******" : "₹${(income - expense).toStringAsFixed(2)}",
                            style: const TextStyle(color: Colors.black, fontSize: 34, fontWeight: FontWeight.bold),
                          ),
                          Container(
                            height: 50, width: 50,
                            decoration: BoxDecoration(color: const Color(0xFFF7F3F0), borderRadius: BorderRadius.circular(10)),
                            child: const Icon(Icons.wallet, color: Color(0xFF2E7D32), size: 28),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const CircleAvatar(
                                radius: 18,
                                backgroundColor: Color.fromARGB(255, 205, 255, 206),
                                child: Icon(Icons.trending_up, color: Colors.green, size: 18),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Income", style: TextStyle(color: Color.fromARGB(179, 0, 0, 0), fontSize: 15)),
                                    const SizedBox(height: 3),
                                    Text(
                                      isHidden ? "******" : "₹${income.toStringAsFixed(2)}",
                                      style: const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const CircleAvatar(
                                radius: 18,
                                backgroundColor: Color.fromARGB(255, 255, 205, 206),
                                child: Icon(Icons.trending_down, color: Colors.red, size: 18),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Expense", style: TextStyle(color: Color.fromARGB(179, 0, 0, 0), fontSize: 15)),
                                    const SizedBox(height: 3),
                                    Text(
                                      isHidden ? "******" : "₹${expense.toStringAsFixed(2)}",
                                      style: const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

               
                Container(
                  decoration: BoxDecoration(color: const Color(0xFF0F111A), borderRadius: BorderRadius.circular(20)),
                  child: const TabBar(
                    indicatorColor: Colors.white,
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.grey,
                    tabs: [Tab(text: "Income"), Tab(text: "Expense")],
                  ),
                ),

                const SizedBox(height: 20),

                
                Expanded(
                  child: TabBarView(
                    children: [
                      // INCOME TAB
                      incomeList.isEmpty
                          ? const Center(child: Text("No income transactions yet", style: TextStyle(color: Colors.grey, fontSize: 16)))
                          : ListView.builder(
                              itemCount: incomeList.length,
                              itemBuilder: (ctx, index) => _buildTransactionCard(
                                item: incomeList[index],
                                index: index,
                                type: 'income',
                              ),
                            ),

                     
                      expenseList.isEmpty
                          ? const Center(child: Text("No expense transactions yet", style: TextStyle(color: Colors.grey, fontSize: 16)))
                          : ListView.builder(
                              itemCount: expenseList.length,
                              itemBuilder: (ctx, index) => _buildTransactionCard(
                                item: expenseList[index],
                                index: index,
                                type: 'expense',
                              ),
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}