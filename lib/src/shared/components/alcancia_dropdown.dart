import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AlcanciaDropdown extends StatefulWidget {
  const AlcanciaDropdown({
    Key? key,
    this.dropdownWidth,
    this.onChanged,
    required this.dropdownItems,
    this.color,
    this.itemsAlignment,
  }) : super(key: key);

  final double? dropdownWidth;
  final List<Map> dropdownItems;
  final Function? onChanged;
  final Color? color;
  final MainAxisAlignment? itemsAlignment;

  @override
  State<AlcanciaDropdown> createState() => _AlcanciaDropdownState();
}

class _AlcanciaDropdownState extends State<AlcanciaDropdown> {
  @override
  void initState() {
    super.initState();
  }

  late String dropdownValue = widget.dropdownItems.first['name'];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.dropdownWidth,
      decoration: BoxDecoration(
        color: widget.color ?? Theme.of(context).primaryColor,
        borderRadius: const BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          style: TextStyle(
            fontSize: 15,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black,
          ),
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
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment:
                      widget.itemsAlignment ?? MainAxisAlignment.spaceAround,
                  children: [
                    item['icon'] == null
                        ? const Text("")
                        : Image(
                            width: 18,
                            image: AssetImage(
                              item['icon'],
                            ),
                            // width: 20,
                          ),
                    Text(item['name']),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
