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
        required this.roomId
      });

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
      roomId: map['roomId']


    );
  }
}
