import 'package:flutter/material.dart';

void main() {
  runApp(BMICalculatorApp());
}

class BMICalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test BMI',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BMICalculatorScreen(),
    );
  }
}

class BMICalculatorScreen extends StatefulWidget {
  @override
  _BMICalculatorScreenState createState() => _BMICalculatorScreenState();
}

class _BMICalculatorScreenState extends State<BMICalculatorScreen> {
  double _height = 170; // Initial height in cm
  double _weight = 70; // Initial weight in kg
  double _bmi = 0;
  String _bmiNote = '';
  String _imageURL = '';
  int _age = 20; // Initial age

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BMI Calculator'),
      ),
      body:
      SingleChildScrollView(
        child:Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    _age = int.parse(value);
                    _calculateBMI();
                  });
                },
              ),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(labelText: 'Height (cm)'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    _height = double.parse(value);
                    _calculateBMI();
                  });
                },
              ),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(labelText: 'Weight (kg)'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    _weight = double.parse(value);
                    _calculateBMI();
                  });
                },
              ),
              SizedBox(height: 20),
              Text(
                'BMI: ${_bmi.toStringAsFixed(1)}',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(height: 20),
              Text(
                '$_bmiNote',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              _imageURL.isNotEmpty ? Image.network(_imageURL) : SizedBox(),
            ],
          ),
        ),

      )
    );
  }

  void _calculateBMI() {
    // Formula: weight (kg) / [height (m)]^2
    double heightInMeter = _height / 100; // Convert height from cm to m
    setState(() {
      _bmi = _weight / (heightInMeter * heightInMeter);
      _bmiNote = _getBMIStatus(_bmi, _age);
      _setImageURL(_bmi);
    });
  }

  String _getBMIStatus(double bmi, int age) {
    if (age > 18) {
      if (bmi < 16) {
        return "Extrême maigreur";
      } else if (bmi >= 16 && bmi < 17) {
        return "Minceur modérée";
      } else if (bmi >= 17 && bmi < 18.5) {
        return "Légère maigreur";
      } else if (bmi >= 18.5 && bmi < 25) {
        return "Poids normal";
      } else if (bmi >= 25 && bmi < 30) {
        return "prise de poids";
      } else if (bmi >= 30 && bmi < 35) {
        return "Obésité de classe I";
      } else if (bmi >= 35 && bmi < 40) {
        return "Obésité de classe II";
      } else {
        return "Obésité de classe III";
      }
    } else {
      if (bmi < 16) {
        return "Underweight";
      } else if (bmi >= 16 && bmi < 17) {
        return "Moderate thinness";
      } else if (bmi >= 17 && bmi < 18.5) {
        return "Mild thinness";
      } else if (bmi >= 18.5 && bmi < 25) {
        return "Normal weight";
      } else {
        return "Obesity";
      }
    }
  }

  void _setImageURL(double bmi) {
    if (bmi < 18.5) {
      _imageURL = 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSly1pYo94RmuSvi_JZNxVWlWNrb7fjJBWReRPZ0UuTcg&s';
    } else if (bmi >= 18.5 && bmi < 24.9) {
      _imageURL = 'https://t3.ftcdn.net/jpg/05/66/32/22/360_F_566322207_Fa1DSykWMr5IjvNFFdgKapoCHJn36RgV.jpg';
    } else if (bmi >= 25 && bmi < 40){
      _imageURL = 'https://t3.ftcdn.net/jpg/05/66/32/22/360_F_566322207_Fa1DSykWMr5IjvNFFdgKapoCHJn36RgV.jpg';
    }
  }
}
