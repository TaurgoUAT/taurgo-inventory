import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:taurgo_inventory/pages/conditions/condition_details.dart';
import 'package:taurgo_inventory/pages/edit_report_page.dart';
import '../../constants/AppColors.dart';

class Keys extends StatefulWidget {
  const Keys({super.key});

  @override
  State<Keys> createState() => _KeysState();
}

class _KeysState extends State<Keys> {

  String? yale;
  String? mortice;
  String? windowLock;
  String? gasAndElectricMeter;
  String? carPass;
  String? remoteOrSecurityFob;
  String? other;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Keys',
            style: TextStyle(
              color: kPrimaryColor,
              fontSize: 14,
              fontFamily: "Inter",
            ),
          ),
          centerTitle: true,
          backgroundColor: bWhite,
          leading: GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => EditReportPage(),
                ),
              );
            },
            child: Icon(
              Icons.arrow_back_ios_new,
              color: kPrimaryColor,
              size: 24,
            ),
          ),
        ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              //Yale
              ConditionItem(
                name: "Yale",
                selectedCondition: yale,
                onConditionSelected: (condition) {
                  setState(() {
                    yale = condition;
                  });
                },
              ),

              //Mortice
              ConditionItem(
                name: "Mortice",
                selectedCondition: mortice,
                onConditionSelected: (condition) {
                  setState(() {
                    mortice = condition;
                  });
                },
              ),

              //Windows Lock
              ConditionItem(
                name: "Windows Lock",
                selectedCondition: windowLock,
                onConditionSelected: (condition) {
                  setState(() {
                    windowLock = condition;
                  });
                },
              ),

              //Mortice
              ConditionItem(
                name: "Gas / Electric meter",
                selectedCondition: gasAndElectricMeter,
                onConditionSelected: (condition) {
                  setState(() {
                    gasAndElectricMeter = condition;
                  });
                },
              ),


              //Windows Lock
              ConditionItem(
                name: "Car Pass / Permit",
                selectedCondition: carPass,
                onConditionSelected: (condition) {
                  setState(() {
                    carPass = condition;
                  });
                },
              ),

              //Mortice
              ConditionItem(
                name: "Remote / Security Fob",
                selectedCondition: remoteOrSecurityFob,
                onConditionSelected: (condition) {
                  setState(() {
                    remoteOrSecurityFob = condition;
                  });
                },
              ),

              //Windows Lock
              ConditionItem(
                name: "Other",
                selectedCondition: other,
                onConditionSelected: (condition) {
                  setState(() {
                    other = condition;
                  });
                },
              ),


              // Add more ConditionItem widgets as needed
            ],
          ),
        ),
      ),
    );
  }
}
class ConditionItem extends StatelessWidget {
  final String name;
  final String? selectedCondition;
  final Function(String?) onConditionSelected;

  const ConditionItem({
    Key? key,
    required this.name,
    this.selectedCondition,
    required this.onConditionSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Name",
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w700,
                      color: kPrimaryTextColourTwo,
                    ),
                  ),
                  SizedBox(height: 3.0),
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w700,
                      color: kSecondaryTextColourTwo,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.warning_amber,
                      size: 24,
                      color: kAccentColor,
                    ),
                    onPressed: () {
                      // Handle warning icon action
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.camera_alt_outlined,
                      size: 24,
                      color: kSecondaryTextColourTwo,
                    ),
                    onPressed: () {
                      // Handle camera icon action
                    },
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 12,),
          GestureDetector(
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ConditionDetails(
                    initialCondition: selectedCondition,
                    type: name,
                  ),
                ),
              );

              if (result != null) {
                onConditionSelected(result);
              }
            },
            child: Text(
              selectedCondition ?? "Key Location & Description",
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w700,
                color: kPrimaryTextColourTwo,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),

          Divider(thickness: 1, color: Color(0xFFC2C2C2)),
        ],
      ),
    );
  }
}

