
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:room_finder/screens/profile_screen/my_rooms.dart';
import 'package:uuid/uuid.dart';

import '../../model/room.dart';
import '../add_new_room/components/image_uploader.dart';
import '../add_new_room/components/my_checkbox.dart';
import '../add_new_room/components/price_text_field.dart';
import '../add_new_room/map_screen.dart';
import '../login_screen/components/my_button.dart';
import '../login_screen/components/my_textfield.dart';

class ModifyRoomScreen extends StatefulWidget {
  final Room room;
  const ModifyRoomScreen({Key? key,required this.room}) : super(key: key);

  @override
  State<ModifyRoomScreen> createState() => _ModifyRoomScreenState();
}

class _ModifyRoomScreenState extends State<ModifyRoomScreen> {
  late final houseNameController ;
  late final houseAddressController ;
  late final propertySizeController ;

  late final singlePriceController ;
  late final doublePriceController ;
  late final triplePriceController ;
  final _formKey = GlobalKey<FormState>();

  late final aboutController ;

  late BuildContext loadingContext;

  late var userName;
  late var userNumber;



  var hasSingle = true;
  var hasDoubleSharing = false;
  var hasTripleSharing = false;

  var hasFPower = false;
  var hasFMeals = false;
  var hasFKitchen = false;
  var hasFParking = false;
  var hasFAirCond = false;
  var hasFCCTV = false;

  GoogleMapController? mapController;
  late LatLng _selectedLocation ;



  final userId = FirebaseAuth.instance.currentUser?.uid;







  late CollectionReference roomsRef;
  late DocumentReference roomDocument ;

  @override
  void initState() {

    super.initState();
    roomsRef = FirebaseFirestore.instance.collection('rooms');
    roomDocument = roomsRef.doc(widget.room.roomId);


    houseNameController = TextEditingController(text: widget.room.title );
    houseAddressController = TextEditingController(text: widget.room.location );
    propertySizeController = TextEditingController(text: widget.room.propertySize);
    aboutController = TextEditingController(text: widget.room.description);
    singlePriceController = TextEditingController(text: widget.room.priceSingle );
    doublePriceController = TextEditingController(text: widget.room.priceTwin);
    triplePriceController = TextEditingController(text: widget.room.priceThree);

    // Set the initial values of the checkboxes
    hasFPower = widget.room.hasFPower ;
    hasFMeals = widget.room.hasFMeals ;
    hasFKitchen = widget.room.hasFKitchen ;
    hasFParking = widget.room.hasFParking ;
    hasFAirCond = widget.room.hasFAirCond ;
    hasFCCTV = widget.room.hasFCCTV ;

    hasSingle = widget.room.hasSingle;
    hasTripleSharing = widget.room.hasThree;
    hasDoubleSharing = widget.room.hasDouble;
    _selectedLocation = LatLng(widget.room.latitude, widget.room.longitude);


  }

  void hideLoadingDialog() {
    Navigator.pop(loadingContext); // use the stored context to remove the loading dialog
  }

  void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        loadingContext = context;
        return Center(
          child: Container(
            width: 120.0,
            height: 120.0,
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16.0),
                Text('Saving...', style: TextStyle(fontSize: 16.0)),
              ],
            ),
          ),
        );
      },
    );
  }




  void addRoomDetails (String roomName,String roomAddress,
      String propertySize,String roomDescription) async {
    showLoadingDialog(context);

    try {
      // Add the room details as fields to the document

      final user = FirebaseAuth.instance.currentUser!;
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (!userDoc.exists) {
        print(user.uid);
        throw Exception('User document does not exist.');
      }

      userName = userDoc.get('name');
      userNumber = userDoc.get('phone');




      await roomDocument.update({
        'name': roomName,
        'ownerName': userName,
        'ownerNumber' :userNumber,
        'property size':propertySize,
        'address':roomAddress,
        'description': roomDescription,
        'latitude': _selectedLocation.latitude,
        'longitude':_selectedLocation.longitude,
        'singlePrice':hasSingle?singlePriceController.text : '0',
        'doublePrice' :hasDoubleSharing ?  doublePriceController.text : '0',
        'triplePrice' : hasTripleSharing ?  triplePriceController.text : '0',
        'hasFPower' : hasFPower,
        'hasFMeals' : hasFMeals,
        'hasFKitchen' : hasFKitchen,
        'hasFParking' : hasFParking,
        'hasFAirCond' : hasFAirCond,
        'hasFCCTV' : hasFCCTV,
        'userId' : userId

      });
      print('updated');

      // Hide the progress bar
      hideLoadingDialog();

      // Show a snackbar to inform that information is saved
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Room information updated.'),
          duration: Duration(seconds: 2),
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyRooms()),
      );
    } catch (error) {
      // Hide the progress bar
      hideLoadingDialog();

      // Show a snackbar to inform that there was an error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('There was an error: $error'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future deleteRoom(String roomId) async {
    await FirebaseFirestore.instance.collection('rooms').doc(roomId).delete();
    final roomRef = FirebaseFirestore.instance.collection('rooms').doc(roomId);
    final imagesRef = FirebaseStorage.instance.ref().child('room_images/$roomId');

// Delete room document from Firestore


// Delete room images from Firebase Storage
    final ListResult result = await imagesRef.listAll();
    result.items.forEach((Reference ref) {
      ref.delete();
    });

    await roomRef.delete();

  }



  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: [IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Confirm Delete'),
                    content: Text('Are you sure you want to delete this room?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () async {
                          // Code to delete the room from database goes here
                          await deleteRoom(widget.room.roomId!);
                          Navigator.pop(context);
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyRooms()));
                        },
                        child: Text('Delete'),
                      ),
                    ],
                  );
                },
              );
            },
            icon: Icon(Icons.delete),
          )],
        ),
        body: SingleChildScrollView(
          child: Container(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Update House/PG Details',
                      style: Theme.of(context)
                          .textTheme
                          .headlineLarge!
                          .copyWith(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MyTextField(
                              controller: houseNameController,
                              hintText: 'House/PG Name',
                              obscureText: false),
                          SizedBox(
                            height: 10,
                          ),
                          MyTextField(
                              controller: propertySizeController,
                              hintText: 'Property Size',
                              obscureText: false),
                          SizedBox(
                            height: 10,
                          ),
                          MyTextField(
                              controller: houseAddressController,
                              hintText: 'Address',
                              obscureText: false),
                          SizedBox(
                            height: 10,
                          ),

                          Row(
                            children: [
                              Text(
                                'Select Room Location:',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600),
                              ),
                              IconButton(
                                  onPressed: () async {
                                    final roomLocation = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MapScreen()),
                                    );

                                    setState(() {
                                      if (roomLocation != null) {
                                        _selectedLocation = roomLocation;
                                      }
                                    });
                                    print(_selectedLocation.latitude);
                                  },
                                  icon: Icon(Icons.location_on))
                            ],
                          ),
                          SizedBox(height: 10,),
                          Text('Select Images:',style: Theme.of(context).textTheme.headlineSmall,),
                          SizedBox(
                            height: 20,
                          ),
                          ImageUploader(roomId: widget.room.roomId!,room: widget.room,),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Types of Rooms Availabe:',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: MyCheckBox(
                                      checkBoxVal: hasSingle,
                                      checkBoxTitle: 'Single Rooms',
                                      onChanged: (value) {
                                        setState(() {
                                          hasSingle = value;
                                        });
                                      }),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Expanded(
                                  flex: 1,
                                  child: MyCheckBox(
                                    checkBoxVal: hasDoubleSharing,
                                    checkBoxTitle: 'Double Sharing',
                                    onChanged: (value) {
                                      setState(() {
                                        hasDoubleSharing = value;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: MyCheckBox(
                              checkBoxVal: hasTripleSharing,
                              checkBoxTitle: 'Triple Sharing',
                              onChanged: (value) {
                                setState(() {
                                  hasTripleSharing = value;
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Pricing:',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          if (hasSingle)
                            PriceTextField(
                              myController: singlePriceController,
                              hintText: 'Single Room Price',
                            ),
                          SizedBox(
                            height: 10,
                          ),
                          if (hasDoubleSharing)
                            PriceTextField(
                              myController: doublePriceController,
                              hintText: 'Double Sharing Room Price',
                            ),
                          SizedBox(
                            height: 10,
                          ),
                          if (hasTripleSharing)
                            PriceTextField(
                              myController: triplePriceController,
                              hintText: 'Triple Sharing Room Price',
                            ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Facilities:',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: MyCheckBox(
                                    checkBoxVal: hasFPower,
                                    checkBoxTitle: 'Power Backup    ',
                                    onChanged: (value) {
                                      setState(() {
                                        hasFPower = value;
                                      });
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  flex: 1,
                                  child: MyCheckBox(
                                    checkBoxVal: hasFMeals,
                                    checkBoxTitle: 'Meals Included',
                                    onChanged: (value) {
                                      setState(() {
                                        hasFMeals = value;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: MyCheckBox(
                                    checkBoxVal: hasFKitchen,
                                    checkBoxTitle: 'Common Kitchen',
                                    onChanged: (value) {
                                      setState(() {
                                        hasFKitchen = value;
                                      });
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  flex: 1,
                                  child: MyCheckBox(
                                    checkBoxVal: hasFParking,
                                    checkBoxTitle: 'Vehicle Parking',
                                    onChanged: (value) {
                                      setState(() {
                                        hasFParking = value;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: MyCheckBox(
                                    checkBoxVal: hasFAirCond,
                                    checkBoxTitle: 'A.C. Rooms       ',
                                    onChanged: (value) {
                                      setState(() {
                                        hasFAirCond = value;
                                      });
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  flex: 1,
                                  child: MyCheckBox(
                                    checkBoxVal: hasFCCTV,
                                    checkBoxTitle: 'CCTV Surveillance',
                                    onChanged: (value) {
                                      setState(() {
                                        hasFCCTV = value;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'About: ',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: aboutController,
                            decoration: InputDecoration(
                              //hintText: hintText,
                              hintStyle: TextStyle(color: Colors.grey.shade500),

                              fillColor: Colors.grey.shade200,
                              filled: true,
                              labelStyle: TextStyle(color: Colors.grey.shade500),
                              labelText: 'Description About the Accomodation',
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.grey.shade400),
                              ),
                            ),
                            obscureText: false,maxLines: 5,),
                          SizedBox(
                            height: 10,
                          ),
                          MyButton(onTap: () async{
                            addRoomDetails(houseNameController.text
                                ,houseAddressController.text,propertySizeController.text,aboutController.text);
                          }, buttonText: 'Submit'),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
