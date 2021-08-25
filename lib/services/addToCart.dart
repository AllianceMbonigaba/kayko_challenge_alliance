import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kayko_challenge_alliance/cart_View.dart';
import 'package:kayko_challenge_alliance/services/firebase.dart';
import 'package:kayko_challenge_alliance/services/models/flushbar.dart';
import 'package:provider/provider.dart';

addToCart(name, imgUrl, price, color, id, context) async {
  
  try {
    await Api().setDocFieldMerge('orders', id.toString(), {
      'name': name.toString(),
      'price': price.toString(),
      'color': color.toString(),
      'id': id.toString(),
      'imgUrl': imgUrl.toString()
    });

    
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => 
        StreamProvider<QuerySnapshot>.value(value: Api().orders,child: CartView())));
        
    flushbarMessage(context, 'Successfully added an item to your bag', true);
  } catch (e) {
    flushbarMessage(context, e.toString(), false);
  }
}
