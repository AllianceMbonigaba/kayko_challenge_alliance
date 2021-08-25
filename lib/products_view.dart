import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kayko_challenge_alliance/constant/colors.dart';
import 'package:kayko_challenge_alliance/item_details.dart';
import 'package:kayko_challenge_alliance/services/addToCart.dart';

class ProductsView extends StatefulWidget {
  final productList;
  ProductsView({this.productList});
  @override
  _ProductsViewState createState() => _ProductsViewState();
}

class _ProductsViewState extends State<ProductsView> {
  ScrollController g = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFCFAF8),
      body: Column(
        children: <Widget>[
          SizedBox(height: 10.0),
          GridView.count(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              crossAxisCount: 2,
              primary: true,
              crossAxisSpacing: 0.0,
              mainAxisSpacing: 1.0,
              childAspectRatio: 0.7,
              children: _create4(context)),
          SizedBox(height: 5.0),

          // create hot selling segment
        ],
      ),
    );
  }

  List<Widget> _create4(context) {
    List<Widget> all = [];
    List<Widget> toUse = [];

    if (widget.productList.length == 0) {
      return toUse;
    }

    for (var p in widget.productList) {
      all.add(_buildCard(p['name'], p['price']['current']['text'],
          'https://' + p['imageUrl'], false, false, p['id'], context));
    }

    toUse.add(all[0]);
    toUse.add(all[1]);
    toUse.add(all[2]);
    toUse.add(all[3]);

    return toUse;
  }

  Widget _buildCard(String name, String price, String imgPath, bool added,
      bool isFavorite, id, context) {
    return Padding(
        padding: EdgeInsets.only(top: 5.0, bottom: 5.0, left: 5.0, right: 5.0),
        child: InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ItemDetail(
                      id: id, assetPath: imgPath, price: price, name: name)));
            },
            child: Container(
                // height: 500,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.01),
                          spreadRadius: 0.0,
                          blurRadius: 3.0)
                    ],
                    color: Colors.white),
                child: Column(children: [
                  Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              padding: EdgeInsets.all(2),
                              child: isFavorite
                                  ? Center(
                                      child:
                                          Icon(Icons.favorite, color: yellow),
                                    )
                                  : Center(
                                      child: Icon(Icons.favorite_border,
                                          color: yellow),
                                    ),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black.withOpacity(0.25),
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
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                  SizedBox(height: 2.0),
                  Text(price,
                      style: TextStyle(
                          color: Color(0xFFCC8053),
                          fontFamily: 'Montserrat',
                          fontSize: 14.0)),
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Text(name,
                        maxLines: 1,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Color(0xFF575E67),
                            fontFamily: 'Montserrat',
                            fontSize: 14.0)),
                  ),
                  Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Container(color: Color(0xFFEBEBEB), height: 1.0)),
                  Padding(
                      padding: EdgeInsets.only(left: 5.0, right: 5.0),
                      child: InkWell(
                        onTap: () {
                          addToCart(name, imgPath, price, 'black', id, context);
                        },
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                Text('1',
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
                ]))));
  }
}
