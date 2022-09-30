import 'package:alcancia/src/resources/colors/colors.dart';
import 'package:flutter/material.dart';

class AlcanciaDropdown extends StatefulWidget {
  const AlcanciaDropdown({
    Key? key,
    this.dropdownWidth,
    this.onChanged,
    required this.dropdownItems,
    this.itemsAlignment,
  }) : super(key: key);

  final double? dropdownWidth;
  final List<Map> dropdownItems;
  final Function? onChanged;
  final MainAxisAlignment? itemsAlignment;

  @override
  State<AlcanciaDropdown> createState() => _AlcanciaDropdownState();
}

class _AlcanciaDropdownState extends State<AlcanciaDropdown> {
  late String dropdownValue = widget.dropdownItems.first['name'];

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

  getAlcanciaDropdownMenuItem(Map item) {
    return DropdownMenuItem<String>(
      value: item['name'],
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment:
              widget.itemsAlignment ?? MainAxisAlignment.spaceAround,
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
            Text(item['name'])
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.dropdownWidth,
      decoration: dropdownDecoration(context),
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
                item: item,
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

  const AlcanciaDropdownItem({
    super.key,
    required this.item,
    this.itemsAlignment,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
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
          Text(item['name'])
        ],
      ),
    );
  }
}
