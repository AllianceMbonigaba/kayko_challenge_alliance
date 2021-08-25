import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

import 'package:kayko_challenge_alliance/cart_View.dart';
import 'package:kayko_challenge_alliance/constant/colors.dart';
import 'package:kayko_challenge_alliance/item_details.dart';
import 'package:kayko_challenge_alliance/products_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:http/http.dart' as http;
import 'package:kayko_challenge_alliance/services/addToCart.dart';
import 'package:kayko_challenge_alliance/services/firebase.dart';
import 'package:kayko_challenge_alliance/services/models/productList.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  List _all;
  Future pr;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _all = [];
    pr = _products();
  }

  //read from api
  Future<ProductLst> _products() async {
    var headers = {
      'x-rapidapi-key': '70e04ce299msh2c9ca68cfae5e89p106f10jsn0ccf4ec06a25',
      'x-rapidapi-host': 'asos2.p.rapidapi.com'
    };
    var request = http.Request(
        'GET',
        Uri.parse(
            'https://asos2.p.rapidapi.com/products/v2/list?offset=0&limit=20&sort=freshness&categoryId=4209&lang=en-US&country=RW'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var p = ProductLst.fromJson(
          jsonDecode(await response.stream.bytesToString()));

      setState(() {
        _all = p.products;
      });

      print(p.products);
      return p;
    } else {
      print(response.reasonPhrase);
    }

    return ProductLst(products: []);
  }

  // List _All;

  @override
  Widget build(BuildContext context) {
    while (pr == null) {
      return Container(
          height: 30,
          width: 30,
          child: Center(child: CircularProgressIndicator()));
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.black,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            elevation: 0.0,
            centerTitle: true,
            leading: Container(
              child: IconButton(
                icon: Icon(Icons.person, color: Color(0xFF545D68)),
                onPressed: () {},
              ),
            ),
            title: Text('ASOS',
                style: TextStyle(
                    fontFamily: 'Varela',
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    color: Color(0xFF545D68))),
            actions: <Widget>[
              // IconButton(
              //   icon: Icon(Icons.notifications_none, color: Color(0xFF545D68)),
              //   onPressed: () {},
              // ),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              StreamProvider<QuerySnapshot>.value(
                                  value: Api().orders, child: CartView())));
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      child: Text(
                        'My bag',
                        style: TextStyle(
                            color: yellow,
                            fontSize: 13,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    IconButton(
                        icon: Icon(
                          Icons.shopping_bag_sharp,
                          color: yellow,
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      CartView()));
                        }),
                  ],
                ),
              )
            ],
          ),
          body: ListView(
            padding: EdgeInsets.only(left: 0),
            children: <Widget>[
              SizedBox(height: 15.0),
              Container(
                padding: EdgeInsets.only(left: 5),
                child: Text('Categories',
                    style: TextStyle(
                        fontFamily: 'Varela',
                        fontSize: 42.0,
                        fontWeight: FontWeight.bold)),
              ),
              SizedBox(height: 15.0),
              Container(
                padding: EdgeInsets.only(left: 5),
                child: TabBar(
                    controller: _tabController,
                    indicatorColor: Colors.transparent,
                    labelColor: Color(0xFFC88D67),
                    isScrollable: true,
                    labelPadding: EdgeInsets.only(right: 45.0),
                    unselectedLabelColor: Color(0xFFCDCDCD),
                    tabs: [
                      Tab(
                        child: Center(
                          child: Text('Men',
                              style: TextStyle(
                                fontFamily: 'Varela',
                                fontSize: 16.0,
                              )),
                        ),
                      ),
                      Tab(
                        child: Center(
                          child: Text('Women',
                              style: TextStyle(
                                fontFamily: 'Varela',
                                fontSize: 16.0,
                              )),
                        ),
                      ),
                    ]),
              ),

              //Hot selling segment
              Container(
                  height: MediaQuery.of(context).size.height - 100,
                  width: double.infinity,
                  child: TabBarView(controller: _tabController, children: [
                    ProductsView(
                      productList: _all,
                    ),
                    ProductsView(productList: _all.reversed),
                  ])),

              Container(
                color: Colors.black,
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: EdgeInsets.all(8.0),
                            child: Text('New',
                                style: TextStyle(
                                  fontFamily: 'Varela',
                                  color: background,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 42.0,
                                )),
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            child: Text('View All',
                                style: TextStyle(
                                  fontFamily: 'Varela',
                                  color: background,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14.0,
                                )),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(8),
                      alignment: Alignment.bottomLeft,
                      child: Text('You will like these ones',
                          style: TextStyle(
                            fontFamily: 'Varela',
                            color: Colors.white.withOpacity(0.3),
                            fontWeight: FontWeight.normal,
                            fontSize: 14.0,
                          )),
                    ),

                    //horizontall list view prod
                    Container(
                      height: 300,

                      padding: EdgeInsets.all(15),
                      // width: MediaQuery.of(context).size.width,
                      child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: _create4(context)),
                    )
                  ],
                ),
              ),
              // SizedBox(
              //   height: 15,
              // ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _create4(context) {
    List<Widget> all = [];
    List<Widget> toUse = [];

    if (_all.length == 0) {
      return toUse;
    }
    for (var p in _all.reversed) {
      all.add(_buildCard(p['id'], p['name'], p['price']['current']['text'],
          'https://' + p['imageUrl'], false, false, context));
    }

    toUse.add(all[0]);
    toUse.add(all[1]);
    toUse.add(all[2]);
    toUse.add(all[3]);

    return toUse;
  }

  Widget _buildCard(id, String name, String price, String imgPath, bool added,
      bool isFavorite, context) {
    return Container(
      // height: 300,
      width: 200,
      child: Padding(
          padding:
              EdgeInsets.only(top: 5.0, bottom: 5.0, left: 5.0, right: 5.0),
          child: InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ItemDetail(
                        id: id, assetPath: imgPath, price: price, name: name)));
              },
              child: Container(
                  // height: 800,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.01),
                            spreadRadius: 0.0,
                            blurRadius: 3.0)
                      ],
                      color: Colors.white),
                  child: Container(
                    child: Column(children: [
                      Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Row(
                              // mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(2),
                                  child: isFavorite
                                      ? Center(
                                          child: Icon(Icons.favorite,
                                              color: yellow),
                                        )
                                      : Center(
                                          child: Icon(Icons.favorite_border,
                                              color: yellow),
                                        ),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.25),
                                            blurRadius: 3,
                                            offset: Offset(0, 1))
                                      ],
                                      shape: BoxShape.circle),
                                ),
                              ])),
                      Container(
                        height: 120.0,
                        width: double.infinity,
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: imgPath,
                          placeholder: (context, url) =>
                              Image.asset('assets/launch_image.png'),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                      ),
                      SizedBox(height: 2.0),
                      Text(price,
                          style: TextStyle(
                              color: Color(0xFFCC8053),
                              fontFamily: 'Montserrat',
                              fontSize: 14.0)),
                      Text(name,
                          maxLines: 2,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Color(0xFF575E67),
                              fontFamily: 'Montserrat',
                              fontSize: 14.0)),
                      Padding(
                          padding: EdgeInsets.all(8.0),
                          child:
                              Container(color: Color(0xFFEBEBEB), height: 1.0)),
                      Padding(
                          padding: EdgeInsets.only(left: 5.0, right: 5.0),
                          child: InkWell(
                            onTap: () {
                              addToCart(
                                  name, imgPath, price, 'white', id, context);
                            },
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  if (!added) ...[
                                    // SizedBox(
                                    //   width: 1,
                                    // ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 7),
                                      child: Icon(Icons.add,
                                          color: yellow, size: 22.0),
                                    ),
                                    Text('Add to cart',
                                        style: TextStyle(
                                            fontFamily: 'Varela',
                                            fontWeight: FontWeight.bold,
                                            color: yellow,
                                            fontSize: 15.0))
                                  ],
                                  if (added) ...[
                                    Icon(Icons.remove_circle_outline,
                                        color: yellow, size: 20.0),
                                    Text('3',
                                        style: TextStyle(
                                            fontFamily: 'Varela',
                                            color: Colors.grey.withOpacity(0.5),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15.0)),
                                    Icon(Icons.add_circle_outline,
                                        color: yellow, size: 20.0),
                                  ]
                                ]),
                          ))
                    ]),
                  )))),
    );
  }
}
