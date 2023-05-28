// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// import '../model/room.dart';
// import '../model/user_model.dart';
//
// class AdminScreen extends StatefulWidget {
//   @override
//   _AdminScreenState createState() => _AdminScreenState();
// }
//
// class _AdminScreenState extends State<AdminScreen> {
//   late List<UserModel> userList;
//   late List<Room> roomList;
//   late List<Room> pendingRoomList;
//
//   @override
//   void initState() {
//     super.initState();
//     getUsers();
//     getRooms();
//   }
//
//   Future<void> getUsers() async {
//     final QuerySnapshot<Map<String, dynamic>> userSnapshot =
//     await FirebaseFirestore.instance.collection('users').get();
//
//     setState(() {
//       userList = userSnapshot.docs
//           ?.map((e) => UserModel.fromJson(e.data() ))
//           .toList() ??
//           [];
//     });
//   }
//
//   Future<void> getRooms() async {
//     final QuerySnapshot<Map<String, dynamic>> roomSnapshot =
//     await FirebaseFirestore.instance.collection('rooms').get();
//
//     setState(() {
//       roomList = roomSnapshot.docs.map((DocumentSnapshot document) => Room.fromMap(document.data() as Map<String, dynamic>) ).toList() ?? [];
//       pendingRoomList =
//           roomList.where((room) => !room.isVerified && !room.isRejected).toList();
//     });
//   }
//
//   void verifyRoom(Room room) {
//     room.isVerified = true;
//     room.isRejected = false;
//     FirebaseFirestore.instance.collection('rooms').doc(room.roomId).set(room.toMap());
//     setState(() {
//       pendingRoomList.remove(room);
//     });
//   }
//
//   void rejectRoom(Room room) {
//     room.isVerified = false;
//     room.isRejected = true;
//     FirebaseFirestore.instance.collection('rooms').doc(room.roomId).set(room.toMap());
//     setState(() {
//       pendingRoomList.remove(room);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text('Admin Screen'),
//         ),
//         body: SingleChildScrollView(
//             child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                 SizedBox(height: 20),
//             Center(
//               child: Text(
//                 'User List',
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//             ),
//             SizedBox(height: 10),
//             if (userList == null)
//         Center(
//         child: CircularProgressIndicator(),
//     )
//     else
//     ListView.builder(
//     shrinkWrap: true,
//     physics: NeverScrollableScrollPhysics(),
//     itemCount: userList.length,
//     itemBuilder: (context, index) {
//     return ListTile(
//     title: Text(userList[index].userFullName),
//     subtitle: Text(userList[index].userEmail),
//     trailing: Text(userList[index].userPhone),
//     );
//     },
//     ),
//     SizedBox(height: 20),
//     Center(
//     child: Text(
//     'Pending Room List',
//     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//     ),
//     ),
//     SizedBox(height: 10),
//     if (pendingRoomList == null)
//     Center(
//     child: CircularProgressIndicator(),
//     )
//     else
//     ListView.builder(
//     shrinkWrap: true,
//     physics: NeverScrollableScrollPhysics(),
//     itemCount: pendingRoomList.length,
//     itemBuilder: (context, index) {
//     return Card(
//     margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//     child: Padding(
//     padding: const EdgeInsets.all(8.0),
//     child: Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//     Text(
//     'Room Name: ${pendingRoomList[index].title}',
//     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//     ),
//     SizedBox(height: 5),
//     Text(
//     'Location: ${pendingRoomList[index].location}',
//     style: TextStyle(fontSize: 14),
//     ),
//       SizedBox(height: 5),
//       Text(
//         'Price: ${pendingRoomList[index].priceTwin}',
//         style: TextStyle(fontSize: 14),
//       ),
//
//       SizedBox(height: 10),
//       Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: [
//           MaterialButton(
//             onPressed: () {
//               verifyRoom(pendingRoomList[index]);
//             },
//             child: Text('Verify'),
//             color: Colors.green,
//           ),
//           MaterialButton(
//             onPressed: () {
//               rejectRoom(pendingRoomList[index]);
//             },
//             child: Text('Reject'),
//             color: Colors.green,
//           ),
//         ],
//       ),
//     ],
//     ),
//     ),
//     );
//     },
//     ),
//                   SizedBox(height: 20),
//                   Center(
//                     child: Text(
//                       'All Room List',
//                       style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                   SizedBox(height: 10),
//                   if (roomList == null)
//                     Center(
//                       child: CircularProgressIndicator(),
//                     )
//                   else
//                     ListView.builder(
//                       shrinkWrap: true,
//                       physics: NeverScrollableScrollPhysics(),
//                       itemCount: roomList.length,
//                       itemBuilder: (context, index) {
//                         return Card(
//                           margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                           child: Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   'Room Name: ${roomList[index].title}',
//                                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                                 ),
//                                 SizedBox(height: 5),
//                                 Text(
//                                   'Location: ${roomList[index].location}',
//                                   style: TextStyle(fontSize: 14),
//                                 ),
//                                 SizedBox(height: 5),
//                                 Text(
//                                   'Price: ${roomList[index].priceTwin}',
//                                   style: TextStyle(fontSize: 14),
//                                 ),
//
//                                 SizedBox(height: 5),
//                                 Text(
//                                   'Verified: ${roomList[index].isVerified ? 'Yes' : 'No'}',
//                                   style: TextStyle(fontSize: 14),
//                                 ),
//                                 SizedBox(height: 5),
//                                 Text(
//                                   'Rejected: ${roomList[index].isRejected ? 'Yes' : 'No'}',
//                                   style: TextStyle(fontSize: 14),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                 ],
//             ),
//         ),
//     );
//   }
// }