import 'package:flutter/material.dart';
import '../services/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/mainProvider.dart';

class AddAssetDateScreen extends StatefulWidget {
  AddAssetDateScreen(
      {Key key, @required this.selectedAsset, @required this.selectedAssetText})
      : super(key: key);

  // The Selected Asset as an Enum
  final selectedAsset;
  // The Selected Asset in String form to display to User
  final selectedAssetText;
  @override
  _AddAssetDateScreenState createState() => _AddAssetDateScreenState();
}

class _AddAssetDateScreenState extends State<AddAssetDateScreen> {
  bool hasSelectedInstalledDate = false;
  DateTime installedDate;

  bool hasSelectedRemindedDate = false;
  DateTime remindedDate;

  TextEditingController textController = TextEditingController();

  nextScreen(BuildContext ctx, AuthService auth) {
    if (!hasSelectedInstalledDate || !hasSelectedRemindedDate) {
      Scaffold.of(ctx).removeCurrentSnackBar();
      Scaffold.of(ctx).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            'Please Select ${!hasSelectedInstalledDate ? 'installed date' : 'reminding date'}',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          duration: Duration(
            seconds: 2,
          ),
        ),
      );
    } else {
      // All dates have been selected, go to next dashboard screen
      print('All Good!');
      // Set onboarding as completed Locally
      print('Selected Name:');
      String newName = textController.value.text.trim();
      print(newName);

      if (newName != '') {
        print('Name is OK!');
      } else {
        print('Retaining the original Asset name, nothing has been entered...');
        newName = widget.selectedAssetText;
        print(newName);
        // newName = '';
      }

      // Set onboarding as completed in user Collection
      // Aslo pass in the data to be uplaoded to Firebase
      final providerData = Provider.of<MainProvider>(ctx, listen: false);
      providerData.addAsset(
        selectedAssetText: newName,
        assetType: widget.selectedAssetText,
        installedDate: this.installedDate,
        reminderDate: this.remindedDate,
      );
      // Navigate to the onboarding Screen again, which will detect
      // that onboardingComplete variable is true
      // And it will render the home dashboard Screen
      Navigator.of(ctx).pop();
      Navigator.of(ctx).pushReplacementNamed('/onboarding');
    }
  }

  Future<void> pickInstalledDate(BuildContext ctx) async {
    DateTime pickedDate = await showDatePicker(
      context: ctx,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        hasSelectedInstalledDate = true;
        installedDate = pickedDate;
      });
    } else {
      // It is null, user cancelled date picking
      print('User Cancelled Date Picking');
    }
  }

  Future<void> pickRemindedDate(BuildContext ctx) async {
    DateTime pickedDate = await showDatePicker(
      context: ctx,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
    );

    if (pickedDate != null) {
      setState(() {
        hasSelectedRemindedDate = true;
        remindedDate = pickedDate;
      });
    } else {
      // It is null, user cancelled date picking
      print('User Cancelled Date Picking');
    }
  }

  @override
  Widget build(BuildContext context) {
    final providerData = Provider.of<MainProvider>(context, listen: false);
    final AuthService auth = providerData.auth;

    Widget returnSelectedAssetIcon() {
      if (widget.selectedAsset == Assets.HVAC) {
        return Icon(
          Icons.hvac,
          size: 23,
        );
      } else if (widget.selectedAsset == Assets.Add) {
        return Icon(
          Icons.power,
          size: 23,
        );
      } else if (widget.selectedAsset == Assets.Appliance) {
        return Icon(
          Icons.kitchen,
          size: 23,
        );
      } else if (widget.selectedAsset == Assets.Plumbing) {
        return Icon(
          Icons.plumbing,
          size: 23,
        );
      } else {
        return Icon(
          Icons.roofing,
          size: 23,
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text('Add Home Asset'),
      ),
      body: Builder(
        builder: (ctx) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  returnSelectedAssetIcon(),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      'Add ${widget.selectedAssetText}',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                obscureText: false,
                controller: this.textController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.edit),
                  labelText: 'Personalize ${widget.selectedAssetText} Asset',
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 20, top: 20),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Date Installed: ${hasSelectedInstalledDate ? DateFormat('M/d/y').format(installedDate).toString() : ''}',
                    style: TextStyle(
                      fontSize: 18,
                      // fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: FlatButton(
                      onPressed: () {
                        pickInstalledDate(context);
                      },
                      // color: Colors.lightBlueAccent[700],
                      child: Icon(
                        Icons.today,
                        size: 50,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 20, top: 40),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Date to be reminded: ${hasSelectedRemindedDate ? DateFormat('M/d/y').format(remindedDate).toString() : ''}',
                    style: TextStyle(
                      fontSize: 20,
                      // fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: FlatButton(
                      onPressed: () {
                        pickRemindedDate(context);
                      },
                      //color: Colors.lightBlueAccent[700],
                      child: Icon(
                        Icons.today,
                        size: 50,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            Container(
              margin: EdgeInsets.only(left: 20, top: 40),
              child: FlatButton(
                child: Container(
                  width: 120,
                  height: 60,
                  child: Center(
                    child: Text(
                      'Finish',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                onPressed: () {
                  nextScreen(ctx, auth);
                },
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
