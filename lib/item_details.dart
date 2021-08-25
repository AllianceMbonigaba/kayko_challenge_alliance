import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'dart:math';

import 'package:kayko_challenge_alliance/constant/colors.dart';
import 'package:http/http.dart' as http;
import 'package:kayko_challenge_alliance/services/addToCart.dart';
import 'package:kayko_challenge_alliance/services/models/productDetails.dart';

class ItemDetail extends StatefulWidget {
  final assetPath, price, name, id;
  ItemDetail({this.id, this.assetPath, this.price, this.name});
  @override
  _ItemDetailState createState() =>
      _ItemDetailState(id: id, assetPath: assetPath, name: name, price: price);
}

class _ItemDetailState extends State<ItemDetail> {
  final assetPath, price, name, id;

  _ItemDetailState({this.id, this.assetPath, this.price, this.name});
  var _selected = 'Select Size';
  var _selectedc = 'Select Color';
  Future pd;
  String description;
  List imgs;
  @override
  void initState() {
    super.initState();
    _selected = 'Select Size';
    _selectedc = 'Select Color';
    pd = _productDetail(id);

    description = '';
    imgs = [];
  }

  Future<ProductDetails> _productDetail(id) async {
    var headers = {
      'x-rapidapi-key': '70e04ce299msh2c9ca68cfae5e89p106f10jsn0ccf4ec06a25',
      'x-rapidapi-host': 'asos2.p.rapidapi.com'
    };
    var request = http.Request(
        'GET',
        Uri.parse(
            'https://asos2.p.rapidapi.com/products/v3/detail?id=$id&lang=en-US&country=RW'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var p = ProductDetails.fromJson(
          jsonDecode(await response.stream.bytesToString()));

      setState(() {
        description = p.description;
        imgs = p.imgUrls;
      });

      print(p.imgUrls);
      return p;
    } else {
      print(response.reasonPhrase);
    }

    return ProductDetails(description: description, imgUrls: imgs);
  }

  List<CachedNetworkImageProvider> _getImgProviders() {
    List<CachedNetworkImageProvider> result = [];

    result.add(CachedNetworkImageProvider(assetPath));

    for (var el in imgs) {
      result.add(CachedNetworkImageProvider(el));
    }

    return result;
  }

  Widget build(BuildContext context) {
    while (pd == null) {
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
            backgroundColor: Color.fromRGBO(249, 249, 249, 1),
            appBar: AppBar(
              backgroundColor: Colors.black,
              elevation: 0.0,
              centerTitle: true,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Color(0xFF545D68)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.share_rounded, color: Color(0xFF545D68)),
                  onPressed: () {},
                ),
              ],
            ),
            body: ListView(children: [
              // SizedBox(height: 15.0),
              Container(
                  color: Color.fromRGBO(240, 240, 240, 1),
                  height: MediaQuery.of(context).size.height * 0.45,

                  //display all the images of the products
                  child: Carousel(
                    autoplay: false,
                    dotColor: Colors.black.withOpacity(0.6),
                    dotIncreasedColor: Colors.black.withOpacity(0.8),
                    dotBgColor: Color.fromRGBO(240, 240, 240, 0.4),
                    boxFit: BoxFit.cover,
                    images: _getImgProviders(),
                    animationCurve: Curves.slowMiddle,
                    animationDuration: Duration(milliseconds: 10),
                  )),
              // SizedBox(height: 20.0),

              Container(
                padding: EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FlatButton(
                        color: Colors.black.withOpacity(0.6),
                        onPressed: () {},
                        child: DropdownButton<String>(
                          elevation: 0,
                          style: TextStyle(
                            color: yellow,
                          ),
                          hint: Text('Select Size'),
                          value: _selected,
                          items: <String>['Select Size', '43', '40', '39']
                              .map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: new Text(
                                value,
                                style: TextStyle(
                                    fontSize: 12,
                                    color: yellow,
                                    fontWeight: FontWeight.bold),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selected = value;
                              print(value);
                            });
                          },
                        )),
                    FlatButton(
                        // height: 10,
                        color: Colors.black.withOpacity(0.6),
                        onPressed: () {},
                        child: DropdownButton<String>(
                          elevation: 0,
                          hint: Text('Select Color'),
                          value: _selectedc,
                          items: <String>[
                            'Select Color',
                            'Black',
                            'Grey',
                            'dark grey'
                          ].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: new Text(
                                value,
                                style: TextStyle(
                                    fontSize: 12,
                                    color: yellow,
                                    fontWeight: FontWeight.bold),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedc = value;
                              print(value);
                            });
                          },
                        )),
                  ],
                ),
              ),
              Center(
                child: Text(price,
                    style: TextStyle(
                        fontFamily: 'Varela',
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFDD148))),
              ),
              SizedBox(height: 10.0),
              Container(
                padding: EdgeInsets.all(12),
                child: Center(
                  child: Text(name,
                      style: TextStyle(
                          color: Color(0xFF575E67),
                          fontFamily: 'Varela',
                          fontSize: 24.0)),
                ),
              ),
              // SizedBox(height: 20.0),
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width - 50.0,
                  child: Text(description.toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'Varela',
                          fontSize: 16.0,
                          color: Color(0xFFB4B8B9))),
                ),
              ),
              SizedBox(height: 20.0),
            ]),
            // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
            bottomNavigationBar: Container(
              color: Colors.white,
              width: double.infinity,
              height: 60,
              child: InkWell(
                onTap: () {
                  addToCart(widget.name, widget.assetPath, widget.price,
                      _selectedc, widget.id, context);
                },
                child: Container(
                    margin: EdgeInsets.all(8),
                    width: MediaQuery.of(context).size.width * 0.6,
                    height: 30.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Color.fromRGBO(255, 165, 16, 1)),
                    child: Center(
                        child: Text(
                      'Add to cart',
                      style: TextStyle(
                          fontFamily: 'Varela',
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ))),
              ),
            )),
      ),
    );
  }
}
