import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taurgo_inventory/pages/edit_report_page.dart';
import '../../constants/AppColors.dart';

class AddAction extends StatefulWidget {
  const AddAction({super.key});

  @override
  State<AddAction> createState() => _AddActionState();
}

class _AddActionState extends State<AddAction> {
  String? _selectedResponsibility;
  String? _status;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Action',
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
                builder: (context) => EditReportPage(propertyId: '',),
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
      body: Container(
        color: bWhite,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Status",
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w700,
                  color: kPrimaryColor,
                ),
              ),
              SizedBox(height: 10),
              RadioListTile<String>(
                title: Text("Needs Cleaning"),
                value: "Needs Cleaning",
                groupValue: _status,
                onChanged: (value) {
                  setState(() {
                    _status = value;
                  });
                },
                activeColor: kPrimaryColor,
              ),
              RadioListTile<String>(
                title: Text("Needs Replacing"),
                value: "Needs Replacing",
                groupValue: _status,
                onChanged: (value) {
                  setState(() {
                    _status = value;
                  });
                },
                activeColor: kPrimaryColor,
              ),
              RadioListTile<String>(
                title: Text("Need Maintenance"),
                value: "Need Maintenance",
                groupValue: _status,
                onChanged: (value) {
                  setState(() {
                    _status = value;
                  });
                },
                activeColor: kPrimaryColor,
              ),
              SizedBox(height: 16),
              Text(
                "Who's responsible",
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w700,
                  color: kPrimaryColor,
                ),
              ),
              SizedBox(height: 10),
              RadioListTile<String>(
                title: Text("Tenant"),
                value: "Tenant",
                groupValue: _selectedResponsibility,
                onChanged: (value) {
                  setState(() {
                    _selectedResponsibility = value;
                  });
                },
                activeColor: kPrimaryColor,
              ),
              RadioListTile<String>(
                title: Text("Landlord"),
                value: "Landlord",
                groupValue: _selectedResponsibility,
                onChanged: (value) {
                  setState(() {
                    _selectedResponsibility = value;
                  });
                },
                activeColor: kPrimaryColor,
              ),
              RadioListTile<String>(
                title: Text("Agent"),
                value: "Agent",
                groupValue: _selectedResponsibility,
                onChanged: (value) {
                  setState(() {
                    _selectedResponsibility = value;
                  });
                },
                activeColor: kPrimaryColor,
              ),
              RadioListTile<String>(
                title: Text("Investigate"),
                value: "Investigate",
                groupValue: _selectedResponsibility,
                onChanged: (value) {
                  setState(() {
                    _selectedResponsibility = value;
                  });
                },
                activeColor: kPrimaryColor,
              ),
              RadioListTile<String>(
                title: Text("N/A"),
                value: "N/A",
                groupValue: _selectedResponsibility,
                onChanged: (value) {
                  setState(() {
                    _selectedResponsibility = value;
                  });
                },
                activeColor: kPrimaryColor,
              ),
              Spacer(),
              Center(
                child: GestureDetector(
                  onTap: () {
                    if (_status != null && _selectedResponsibility != null) {
                      Navigator.pop(context, {
                        'status': _status,
                        'responsibility': _selectedResponsibility,
                      });
                    } else {
                      // Show a dialog if both status and responsibility are not selected
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: 10,
                            backgroundColor: Colors.white,
                            title: Row(
                              children: [
                                Icon(Icons.info_outline, color: kPrimaryColor),
                                SizedBox(width: 10),
                                Text(
                                  'Selection Required',
                                  style: TextStyle(
                                    color: kPrimaryColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            content: Text(
                              'Please select both status and responsibility.',
                              style: TextStyle(
                                color: Colors.grey[800],
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                height: 1.5,
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  backgroundColor: kPrimaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  'OK',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  child: Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: kPrimaryColor,
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: Center(
                      child: Text(
                        "Save",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
