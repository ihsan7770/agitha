import 'package:agitha/ModelsFoder/MessageModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:mailer/mailer.dart';

class Messageprovider extends ChangeNotifier{

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isLoading = false;
  bool get isLoading => _isLoading;


  Future<void>addMessage(MessageModel messageModel)async{
   _isLoading = true;
  notifyListeners();
  try{
 final docRef = _firestore.collection('message').doc();
final user = _auth.currentUser;
if (user == null) {
  debugPrint("User not logged in");
  return;
}

 MessageModel newmessage =MessageModel(
 docId: docRef.id,
  userId: user.uid, 
  username: messageModel.username,
   email:messageModel. email, 
   phone: messageModel.phone,
    subject: messageModel.subject,
     message: messageModel.message
     
     
     );
 await docRef.set(newmessage.toMap());
    debugPrint("Message added successfully!");

  } catch (e) {
    debugPrint("Error saving Message: $e");
  } finally {
    _isLoading = false;
    notifyListeners();
  }

}

  Stream<List<MessageModel>>messageStream() {
  return _firestore
      .collection('message')
      .snapshots()
      .map((snapshot) {
    return snapshot.docs.map((doc) {
      return MessageModel.fromMap(doc.data(), doc.id);
    }).toList();
  });
}




  }







