import 'package:cloud_firestore/cloud_firestore.dart';

class Room {
  String title;
  bool hasSingle;
  bool hasDouble;
  bool hasThree;
  String priceSingle;
  String priceTwin;
  String priceThree;
  String location;
  List <String> imageUrl;
  String ownerName;
  String ownerNumber;
  double latitude;
  double longitude;
  String propertySize;
  String description;
  String? userId;
  String? roomId;
  bool hasFAirCond;
  bool hasFCCTV;
  bool hasFMeals;
  bool hasFKitchen;
  bool hasFParking;
  bool hasFPower;
  int popularity;
  Timestamp timestamp;

  //
  // bool isVerified;
  // bool isRejected;


  Room(
      {required this.title,
      required this.priceSingle,
      this.priceTwin = '0',
      this.priceThree = '0',
      required this.location,
       this.hasDouble= true,
      this.hasSingle = true,
       this.hasThree = true,
      required this.imageUrl,
      required this.ownerNumber,
      required this.ownerName,
      this.hasFCCTV = false,
        this.hasFAirCond = false,
        this.hasFParking = false,
        this.hasFKitchen = false,
        this.hasFMeals = false,
        this.hasFPower = false,
        required this.longitude,
        required this.latitude,
        required this.description,
        required this.propertySize,
        required this.userId,
        required this.roomId,
        required this.popularity,
        required this.timestamp,
       // required this.isRejected,
       // required this.isVerified
      });

  Map<String, dynamic> toMap() {
    return {
      'roomId': roomId,
      'roomName': title,
      'location': location,
      'longitude': longitude,
      'latitude': latitude,
      'singlePrice': priceSingle,
      'doublePrice': priceTwin,
      'triplePrice':priceThree,
      'hasFAirCond':hasFAirCond,
      'hasFCCTV':hasFCCTV,
      'hasFKitchen':hasFKitchen,
      'hasFMeals':hasFMeals,
      'hasFParking':hasFParking,
      'hasFPower':hasFPower,
      'property size':propertySize,
      'description':description,
      'imageUrls':imageUrl,
      'ownerName':ownerName,
      'ownerNumber':ownerNumber,
      'userId':userId,
      'popularity':popularity,
      'timestamp':timestamp
      // 'isVerified': isVerified,
      // 'isRejected': isRejected,


    };
  }

  factory Room.fromMap(Map<String, dynamic> map) {
    return Room(
      title: map['name'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      priceSingle : map['singlePrice'],
      priceTwin: map['doublePrice'],
      priceThree: map['triplePrice'],
      hasFAirCond: map['hasFAirCond'],
      hasFCCTV: map['hasFCCTV'],
      hasFKitchen: map['hasFKitchen'],
      hasFMeals: map['hasFMeals'],
      hasFParking: map['hasFParking'],
      hasFPower: map['hasFPower'],
      location: map['address'],
      propertySize: map['property size'],
      description: map['description'],
      imageUrl: List<String>.from(map['imageUrls']),
      ownerName: map['ownerName'],
      ownerNumber: map['ownerNumber'],
      userId: map['userId'],
      roomId: map['roomId'],
     popularity: map['popularity'],
     timestamp: map['timestamp'],
     // isRejected: map['isRejected'],
      //isVerified: map['isVerified'],


    );
  }
}
