import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'Product.dart';

class ProductScreen extends StatefulWidget {

  final Product product;

  ProductScreen(this.product);

  @override
  _ProductScreenState createState() => _ProductScreenState(product);


}

class _ProductScreenState extends State<ProductScreen> {
  String size = "";
  final Product product;

  _ProductScreenState(this.product);
  @override
  Widget build(BuildContext context) {


    final Color primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: Text(this.product.title),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          AspectRatio(
            aspectRatio: 0.9,
            child: Carousel(
              images: product.images.map((url) {
                return NetworkImage(url);
              }).toList(),
              dotSize: 4.0,
              dotSpacing: 15.0,
              dotBgColor: Colors.transparent,
              dotColor: primaryColor,
              autoplay: false,
            ),
          ),
          Padding(
              padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  product.title,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500
                  ),
                  maxLines: 3,
                ),
                Text(
                  "R\$ ${product.price.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                    color: primaryColor
                  ),),
                SizedBox(height: 16.0,),
                Text(
                  "Tamanho",
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500
                  ),
                ),
                SizedBox(
                  height: 34.0,
                  child: GridView(
                    padding: EdgeInsets.symmetric(vertical: 4.0),
                    scrollDirection: Axis.horizontal,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      mainAxisSpacing: 8.0,
                      childAspectRatio: 0.5
                    ),
                    children: product.sizes.map<Widget>(
                            (s) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    size = s;
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                    border: Border.all(
                                      color: s == size ?
                                      primaryColor
                                          : Colors.grey
                                    )
                                  ),
                                  width: 50.0,
                                  alignment: Alignment.center,
                                  child: Text(s.toString()),
                                ),
                              );
                            }
                    ).toList(),
                  ),
                ),
                SizedBox(height: 16.0,),
                SizedBox(
                  height: 44.0,
                  child: ElevatedButton(
                    onPressed: size != "" ?
                        () {} : null,
                    child: Text("Adicionar ao carrinho",
                      style: TextStyle(
                        fontSize: 18.0,),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(primaryColor),
                      textStyle: MaterialStateProperty.all(TextStyle(color: Colors.white))
                    ),
                  )
                ),
                SizedBox(height: 16.0,),
                Text(
                  "Descrição",
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500
                  ),
                ),
                Text(
                  product.description.toString(),
                  style: TextStyle(
                    fontSize: 16.0
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
