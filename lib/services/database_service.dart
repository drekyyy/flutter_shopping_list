import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class DatabaseService {
  final String uid;
  DatabaseService(this.uid);

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  Future createUserDocumentInDatabase(String name) async {
    String? fcmToken = await FirebaseMessaging.instance.getToken();
    await userCollection
        .doc(uid)
        .set({'userId': uid, 'houseId': uid, 'name': name, 'token': fcmToken});
  }

  Future updateFcmTokenOfUser() async {
    String? fcmToken = await FirebaseMessaging.instance.getToken();
    await userCollection.doc(uid).update({'token': fcmToken});
  }

  Future createHouseInDatabase() async {
    await FirebaseFirestore.instance.collection('houses').doc(uid).set({});
  }

  static Future createShoppingList(String uid) async {
    DateTime now = DateTime.now();
    dynamic houseId = await getHouseId(uid);
    String month = now.month.toString();
    String day = now.day.toString();
    String minute = now.minute.toString();
    int monthInt = now.month;
    int dayInt = now.day;
    int minuteInt = now.minute;
    if (monthInt < 10) {
      month = "0$month";
    }
    if (dayInt < 10) {
      day = "0$day";
    }
    if (minuteInt < 10) {
      minute = "0$minute";
    }
    await FirebaseFirestore.instance
        .collection('houses')
        .doc(houseId)
        .collection('shopping-lists')
        .doc()
        .set({
      'name': 'Brak nazwy',
      'createdBy': uid,
      'dateWhenCreated': '${now.year}/$month/$day',
      'hourWhenCreated': '${now.hour}:$minute',
      'timestamp': now.millisecondsSinceEpoch
    });
  }

  static Future addProductToShoppingList(String houseId, String shoppingListId,
      String productName, String userId) async {
    String userName = await getUserName(userId);
    await FirebaseFirestore.instance
        .collection('houses')
        .doc(houseId)
        .collection('shopping-lists')
        .doc(shoppingListId)
        .collection('products')
        .doc()
        .set({
      'name': productName,
      'createdByUid': userId,
      'createdByName': userName
    });
  }

  static Future deleteShoppingList(
      String houseId, String shoppingListId, String useless) async {
    await FirebaseFirestore.instance
        .collection('houses')
        .doc(houseId)
        .collection('shopping-lists')
        .doc(shoppingListId)
        .delete()
        .then(
          (doc) => print("Document deleted"),
          onError: (e) => print("Error updating document $e"),
        );
  }

  static Future deleteProductFromShoppingList(
      String houseId, String shoppingListId, String productId) async {
    await FirebaseFirestore.instance
        .collection('houses')
        .doc(houseId)
        .collection('shopping-lists')
        .doc(shoppingListId)
        .collection('products')
        .doc(productId)
        .delete()
        .then(
          (doc) => print("Document deleted"),
          onError: (e) => print("Error updating document $e"),
        );
  }

  static Future changeNameOfUser(
      String userId, String useless, String name) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .update({'name': name}).catchError(
            (error) => print("Failed to update user: $error"));
  }

  static Future changeNameOfShoppingList(
      String houseId, String shoppingListId, String listName) async {
    await FirebaseFirestore.instance
        .collection('houses')
        .doc(houseId)
        .collection('shopping-lists')
        .doc(shoppingListId)
        .update({'name': listName}).catchError(
            (error) => print("Failed to update user: $error"));
  }

  static Future getHouseId(userid) async {
    dynamic snapshot;
    snapshot =
        await FirebaseFirestore.instance.collection('users').doc(userid).get();
    return snapshot.data()['houseId'];
  }

  static Future getUserName(userid) async {
    dynamic snapshot;
    snapshot =
        await FirebaseFirestore.instance.collection('users').doc(userid).get();
    return snapshot.data()['name'];
  }

  static Future checkIfHouseExists(String houseId) async {
    dynamic userDocRef =
        await FirebaseFirestore.instance.collection('users').doc(houseId);
    dynamic doc = await userDocRef.get();
    if (doc.exists) {
      return true;
    } else {
      return false;
    }
  }

  static Future updateUserHouseId(String houseId, String userId) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .update({'houseId': houseId});
  }
}
