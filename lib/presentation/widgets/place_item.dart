import 'package:flutter/material.dart';
import 'package:flutter_maps/constants/my_colors.dart';
import 'package:flutter_maps/data/models/place_suggestions%20_model.dart';

class PlaceItem extends StatelessWidget {
  PlaceItem({Key? key, required this.suggestions}) : super(key: key);
  final PlaceSuggestionsModel suggestions;

  @override
  Widget build(BuildContext context) {
    var subTitle = suggestions.description
        .replaceAll(suggestions.description.split(',')[0], '');
    return Container(
      width: double.infinity,
      margin: EdgeInsetsDirectional.all(8),
      padding: EdgeInsetsDirectional.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: MyColors.myLightBlue,
              ),
              child: Icon(
                Icons.place,
                color: MyColors.myBlue,
              ),
            ),
            title: RichText(
              text: TextSpan(
                  // text: '${suggestions.description.split(',')[0]}\n',
                  // style: TextStyle(
                  //   color: MyColors.myBlack,
                  //   fontSize: 18,
                  //   fontWeight: FontWeight.bold,
                  // ),
                  children: [
                    TextSpan(
                      text: '${suggestions.description.split(',')[0]}\n',
                      style: TextStyle(
                        color: MyColors.myBlack,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: subTitle.substring(2),
                      style: TextStyle(
                        color: MyColors.myBlack,
                        fontSize: 16,
                      ),
                    ),
                  ]),
            ),
          ),
        ],
      ),
    );
  }
}
