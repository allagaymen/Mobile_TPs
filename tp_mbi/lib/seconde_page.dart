import 'package:flutter/material.dart';

class SecondePage extends StatelessWidget {
  final String weight;
  final double ibm;
  final String height;
  SecondePage(
      {super.key,
      required this.weight,
      required this.ibm,
      required this.height});

  final Map<List<double>, String> listIBM = {
    [16]: "Extrême maigreur",
    [16, 17]: "Minceur modérée",
    [17, 18.5]: "Légère maigreur",
    [18.5, 25]: "Poids normal",
    [25, 30]: "prise de poids",
    [30, 35]: "Obésité de classe I",
    [35, 40]: "Obésité de classe II",
  };

  String getCategory(Map<List<double>, String> map, double ibmValue) {
    for (var entry in map.entries) {
      List<double> range = entry.key;
      if (range.length == 1 && ibmValue == range[0]) {
        return entry.value;
      } else if (range.length == 2 &&
          ibmValue >= range[0] &&
          ibmValue < range[1]) {
        return entry.value;
      }
    }
    return "Category not found"; // Or handle as needed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Second Page"),
      ),
      body: Container(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Weight : $weight",
              style: TextStyle(fontSize: 18),
            ),
            Text(
              "Height: $height",
              style: TextStyle(fontSize: 18),
            ),
            Text(
              "IBM : $ibm",
              style: TextStyle(fontSize: 18),
            ),
            Text("vous etes dans la categorie : ${getCategory(listIBM, ibm)}" , style: TextStyle(fontSize: 19),)
          ],
        ),
      ),
    );
  }
}
