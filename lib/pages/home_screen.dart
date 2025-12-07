import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currencies = ["Dollar", "Rupees", "Pound"];
  String _selectedCurrency = "Rupees";
  String displayResult = "";

  final TextEditingController principalController = TextEditingController();
  final TextEditingController roiController = TextEditingController();
  final TextEditingController timeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text("Simple Interest Calculator", style: TextStyle(fontFamily:"Alan Sans",fontSize: 25, fontWeight:FontWeight.w800),),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              SizedBox(height:50.0),
              Center(
                child: Image.asset(
                  "assets/images/Money.png",
                  width: 300.0,
                  height: 200.0,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: 60.0),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: principalController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a principal amount";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: "Principal Amount",
                  hintText: "Enter Principal Amount e.g 15000",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              const SizedBox(height: 15.0),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: roiController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter Rate of Interest";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: "Rate of Interest",
                  hintText: "Enter in Percentage e.g 15%",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              const SizedBox(height: 15.0),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: timeController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter time in years";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: "Time",
                        hintText: "Time in years e.g 10",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15.0),
                  DropdownButton<String>(
                    value: _selectedCurrency,
                    items: _currencies.map((value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedCurrency = newValue!;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              Row(
               mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 90.0),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        setState(() {
                          displayResult = calculateInterest();
                        });
                      }
                    },
                    child: const Text("Calculate"),
                  ),
                  const SizedBox(width: 10.0),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: resetField,
                    child: const Text("Reset"),
                  ),
                ],
              ),
              const SizedBox(height: 30.0),
              Center(
                child: Text(
                  displayResult,
                  style: const TextStyle(fontSize: 18.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String calculateInterest() {
    const double rupeesToDollar = 0.011;
    const double rupeesToPound = 0.0084;

    double principal = double.parse(principalController.text);
    double roi = double.parse(roiController.text);
    double time = double.parse(timeController.text);

    double totalPayable = principal + (principal * roi * time) / 100;
    double convertedAmount = totalPayable;

    if (_selectedCurrency == "Dollar") {
      convertedAmount = totalPayable * rupeesToDollar;
    } else if (_selectedCurrency == "Pound") {
      convertedAmount = totalPayable * rupeesToPound;
    }

    return "After $time years, your investment will be worth ${convertedAmount.toStringAsFixed(2)} $_selectedCurrency";
  }

  void resetField() {
    setState(() {
      principalController.clear();
      roiController.clear();
      timeController.clear();
      _selectedCurrency = _currencies[0];
      displayResult = "";
    });
  }
}
