import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class IncomeAdd extends StatefulWidget {
  const IncomeAdd({super.key});

  @override
  State<IncomeAdd> createState() => _IncomeAddState();
}

class _IncomeAddState extends State<IncomeAdd> {

  final Color darkGreen = const Color(0xff0B3D2E);

  // CATEGORY
  String selectedCategory = "Salary";

  List<String> categories = [
    "Salary",
    "Business",
    "Investment",
    "Rent",
    "Freelance",
    "Trading",
    "Online",
    "Bonus",
    "Savings",
  ];

  
  TextEditingController dateController =
      TextEditingController();

  TextEditingController categoryController =
      TextEditingController();

  TextEditingController amountController =
      TextEditingController();

  TextEditingController nameController =
      TextEditingController();

  TextEditingController descriptionController =
      TextEditingController();

  @override
  void dispose() {
    dateController.dispose();
    categoryController.dispose();
    amountController.dispose();
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  
  void pickDate() async {

    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {

      setState(() {
        dateController.text =
            picked.toString().split(" ")[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFF0F111A),

      appBar: AppBar(
        backgroundColor: const Color(0xFF0F111A),
        elevation: 0,

        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },

          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),

        title: const Text(
          "Add Income",

          style: TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),

        children: [

          // TITLE
          const Text(
            "Income Details",

            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 25),

         
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),

            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 50, 47, 45),
              border: Border.all(color: darkGreen),
              borderRadius: BorderRadius.circular(20),
            ),

            child: TextField(
              controller: nameController,

              style: const TextStyle(
                color: Colors.white,
              ),

              inputFormatters: [
                FilteringTextInputFormatter.allow(
                  RegExp(r'[a-zA-Z ]'),
                ),
              ],

              decoration: InputDecoration(
                border: InputBorder.none,

                hintText: "Income name",

                hintStyle: const TextStyle(
                  color: Colors.grey,
                ),

                suffixIcon: Icon(
                  Icons.work_outline,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),

            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 50, 47, 45),
              border: Border.all(color: darkGreen),
              borderRadius: BorderRadius.circular(20),
            ),

            child: TextField(
              controller: amountController,

              style: const TextStyle(
                color: Colors.white,
              ),

              keyboardType: TextInputType.number,

              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],

              decoration: InputDecoration(
                border: InputBorder.none,

                hintText: "Amount (₹)",

                hintStyle: const TextStyle(
                  color: Colors.grey,
                ),

                suffixIcon: Icon(
                  Icons.currency_rupee,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),

            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 50, 47, 45),
              border: Border.all(color: darkGreen),
              borderRadius: BorderRadius.circular(20),
            ),

            child: TextField(
              controller: descriptionController,

              style: const TextStyle(
                color: Colors.white,
              ),

              minLines: 1,
              maxLines: null,

              keyboardType: TextInputType.multiline,

              decoration: InputDecoration(
                border: InputBorder.none,

                hintText: "Description",

                hintStyle: const TextStyle(
                  color: Colors.grey,
                ),

                suffixIcon: Icon(
                  Icons.description_outlined,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),

            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 50, 47, 45),
              border: Border.all(color: darkGreen),
              borderRadius: BorderRadius.circular(20),
            ),

            child: TextField(
              style: const TextStyle(
                color: Colors.white,
              ),

              controller: dateController,
              readOnly: true,
              onTap: pickDate,

              decoration: InputDecoration(
                border: InputBorder.none,

                hintText: "Date",

                hintStyle: const TextStyle(
                  color: Colors.grey,
                ),

                suffixIcon: Icon(
                  Icons.calendar_month_outlined,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          const SizedBox(height: 30),

          
          const Text(
            "Category",

            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          
          Wrap(
            spacing: 10,
            runSpacing: 10,

            children: categories.map((category) {

              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                ),

                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 50, 47, 45),
                  border: Border.all(color: darkGreen),
                  borderRadius: BorderRadius.circular(18),
                ),

                child: Row(
                  mainAxisSize: MainAxisSize.min,

                  children: [

                    Radio<String>(
                      activeColor: Colors.green,

                      value: category,

                      groupValue: selectedCategory,

                      onChanged: (value) {

                        setState(() {
                          selectedCategory = value!;
                        });
                      },
                    ),

                    Text(
                      category,

                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 20),

          
          Row(
            children: [

              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),

                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 50, 47, 45),
                    border: Border.all(color: darkGreen),
                    borderRadius: BorderRadius.circular(20),
                  ),

                  child: TextField(
                    controller: categoryController,

                    style: const TextStyle(
                      color: Colors.white,
                    ),

                    decoration: const InputDecoration(
                      border: InputBorder.none,

                      hintText: "Add Category",

                      hintStyle: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 10),

              GestureDetector(
                onTap: () {

                  String newCategory =
                      categoryController.text.trim();

                  if (newCategory.isNotEmpty &&
                      !categories.contains(newCategory)) {

                    setState(() {

                      categories.add(newCategory);

                      selectedCategory = newCategory;
                    });

                    categoryController.clear();
                  }
                },

                child: Container(
                  padding: const EdgeInsets.all(16),

                  decoration: BoxDecoration(
                    color: darkGreen,
                    borderRadius: BorderRadius.circular(18),
                  ),

                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 40),

          // BUTTON
          SizedBox(
            width: double.infinity,
            height: 70,

            child: ElevatedButton(
              onPressed: () {

                
                if (nameController.text.trim().isEmpty ||
                    amountController.text.trim().isEmpty ||
                    dateController.text.trim().isEmpty ||
                    descriptionController.text.trim().isEmpty) {

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "All fields are required",
                      ),
                    ),
                  );

                  return;
                }

                Navigator.pop(
                  context,
                  {
                    "name": nameController.text,
                    "amount": amountController.text,
                    "category": selectedCategory,
                    "date": dateController.text,
                    "description":
                        descriptionController.text,
                  },
                );
              },

              style: ElevatedButton.styleFrom(
                backgroundColor: darkGreen,

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),

              child: const Text(
                "Add Income",

                style: TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
