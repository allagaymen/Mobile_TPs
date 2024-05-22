import 'package:flutter/material.dart';
import 'seconde_page.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController weight = TextEditingController();
  TextEditingController height = TextEditingController();
  double? h;
  // TextEditingController weight ;

  double calculate(String weight, String height) {
    return (double.parse(weight) * double.parse(weight)) / double.parse(height);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("BMI test"),
      ),
      body: SafeArea(
        child: ListView(
          clipBehavior: Clip.antiAlias,
          physics: const BouncingScrollPhysics(),
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    // const SizedBox(height: 10),

                    const SizedBox(height: 30),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      onSaved: (value) {
                        weight.text = value!;
                      },
                      onChanged: (value) {
                        weight.text = value;
                      },
                      // validator: (val) {
                      //   if (val!.isEmpty) {
                      //     return "fillYourUserName".tr;
                      //   }
                      //   if (!RegExp(r'^[a-zA-Z]+$').hasMatch(val)) {
                      //     return "usernameValidator".tr;
                      //   }
                      //   // usernameValidator
                      //   return null;
                      // },
                      // initialValue: signUpController.userName,
                      decoration: InputDecoration(hintText: "Weight(kg)"),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      onSaved: (value) {
                        height.text = value!;
                      },
                      onChanged: (value) {
                        height.text = value;
                      },

                      // validator: (val) {
                      //   if (val!.isEmpty) {
                      //     return "enterAnEmail";
                      //   }
                      //   if (!RegExp(
                      //           r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                      //       .hasMatch(val)) {
                      //     return "enterValidEmail".tr;
                      //   }
                      //   return null;
                      // },
                      // initialValue: signUpController.userEmailAddress,
                      decoration: InputDecoration(hintText: "Height (cm)"),
                    ),
                    const SizedBox(height: 20),

                    TextButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SecondePage(
                                      weight: weight.text,
                                      height: height.text,
                                      ibm:
                                          calculate(weight.text, height.text))),
                            );
                          }
                        },
                        child: Text("Submit")),

                    // GestureDetector(
                    //   onTap: () {
                    //     if (signUpController.formKey.currentState!
                    //         .validate()) {
                    //       signUpController.formKey.currentState!.save();
                    //       signUpController.createNewUser();
                    //     }
                    //   },
                    //   child: Card(
                    //     elevation: 0,
                    //     shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(100),
                    //     ),
                    //     child: Container(
                    //       height: 55,
                    //       alignment: Alignment.center,
                    //       width: double.maxFinite,
                    //       decoration: BoxDecoration(
                    //         color: AppColors.kPrimary2,
                    //         borderRadius: BorderRadius.circular(30),
                    //       ),
                    //       child: Text(
                    //         "Sign Up",
                    //         style: TextStyle(
                    //           color: Colors.white,
                    //           fontSize: 15,
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
