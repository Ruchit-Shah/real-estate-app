import 'package:flutter/material.dart';
import 'package:real_estate_app/view/map/components/search_field/search_field.dart';
typedef onSearchCallback = void Function(bool showresult);
class CustomSearchBar extends StatefulWidget {
  const CustomSearchBar({
    Key? key,
    required this.onSearchCallback,
  }) : super(key: key);
  final onSearchCallback;
  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {

  List list = [
    "Boutique",
    "Restaurant",
    "Salon",
    "Plumber",
    "Cosmetic"
  ];

  bool showresult=false;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 15,right: 5),
      child: GFSearchBar(
        searchList: list,
        searchQueryBuilder: (query, list) {
          return list
              .where((item) =>
              item.toString().toLowerCase().contains(query.toLowerCase()))
              .toList();
        },
        overlaySearchListItemBuilder: (item) {
          return Container(
            padding: const EdgeInsets.all(5),
            child: Text(
              item.toString(),
              style: const TextStyle(fontSize: 18),
            ),
          );
        },
        onItemSelected: (item) {
          setState(() {
            showresult;
            widget.onSearchCallback(showresult);
          });
        }, onRemoveWishlistCallback: (bool showresult) {  removeFromWishlist(showresult);},
      ),
    );
  }
  removeFromWishlist(bool showresul1) async {
    if(mounted){
      setState(() {
        showresult=showresul1;
        print(showresul1);
      });
    }

  }
}
