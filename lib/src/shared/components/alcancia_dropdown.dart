import 'package:alcancia/src/shared/services/responsive_service.dart';
import 'package:flutter/material.dart';

class AlcanciaDropdown extends StatefulWidget {
  const AlcanciaDropdown({
    Key? key,
    this.dropdownWidth,
    this.dropdownHeight,
    this.onChanged,
    required this.dropdownItems,
    this.itemsAlignment,
    this.itemsFontSize = 18,
    this.decoration,
  }) : super(key: key);

  final double? dropdownWidth;
  final double? dropdownHeight;
  final List<Map> dropdownItems;
  final Function? onChanged;
  final MainAxisAlignment? itemsAlignment;
  final double itemsFontSize;
  final BoxDecoration? decoration;

  @override
  State<AlcanciaDropdown> createState() => _AlcanciaDropdownState();
}

class _AlcanciaDropdownState extends State<AlcanciaDropdown> {
  late String dropdownValue = widget.dropdownItems.first['name'];
  final ResponsiveService _responsiveService = ResponsiveService();

  @override
  void initState() {
    super.initState();
  }

  BoxDecoration dropdownDecoration(BuildContext context) {
    return BoxDecoration(
      color: Theme.of(context).primaryColor,
      borderRadius: const BorderRadius.all(
        Radius.circular(8),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.dropdownWidth,
      height: widget.dropdownHeight,
      decoration: widget.decoration ?? dropdownDecoration(context),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: dropdownValue,
          onChanged: (newValue) {
            setState(() {
              dropdownValue = newValue!;
            });
            if (widget.onChanged != null) {
              widget.onChanged!(newValue);
            }
          },
          items: widget.dropdownItems.map<DropdownMenuItem<String>>((item) {
            return DropdownMenuItem(
              value: item['name'],
              child: AlcanciaDropdownItem(
                itemsAlignment: widget.itemsAlignment,
                item: item,
                fontSize: widget.itemsFontSize,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class AlcanciaDropdownItem extends StatelessWidget {
  final Map item;
  final MainAxisAlignment? itemsAlignment;
  final ResponsiveService _responsiveService = ResponsiveService();
  final double fontSize;

  AlcanciaDropdownItem({
    super.key,
    required this.item,
    this.itemsAlignment,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: itemsAlignment ?? MainAxisAlignment.spaceAround,
        children: [
          if (item['icon'] != null)
            Padding(
              padding: const EdgeInsets.only(right: 5),
              child: Image(
                width: 18,
                image: AssetImage(
                  item['icon'],
                ),
              ),
            ),
          Text(
            item['name'],
            style: TextStyle(
              fontSize: _responsiveService.getHeightPixels(fontSize, screenHeight),
            ),
          )
        ],
      ),
    );
  }
}
