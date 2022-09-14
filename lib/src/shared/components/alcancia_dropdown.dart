import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AlcanciaDropdown extends StatefulWidget {
  const AlcanciaDropdown({Key? key, this.dropdownWidth}) : super(key: key);
  final double? dropdownWidth;

  @override
  State<AlcanciaDropdown> createState() => _AlcanciaDropdownState();
}

class _AlcanciaDropdownState extends State<AlcanciaDropdown> {
  @override
  void initState() {
    super.initState();
  }

  final List<String> content = ["MXN", "DOP", "USD"];
  late String dropdownValue = content.first;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.dropdownWidth,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: const BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          icon: const Visibility(
            visible: false,
            child: Icon(Icons.arrow_downward),
          ),
          isExpanded: true,
          value: dropdownValue,
          items: content.map<DropdownMenuItem<String>>((value) {
            return DropdownMenuItem(
              value: value,
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SvgPicture.asset(
                      "lib/src/resources/images/icon_mexico_flag.svg",
                    ),
                    Text(value),
                    SvgPicture.asset(
                      "lib/src/resources/images/icon_arrow_down.svg",
                      width: 6,
                      height: 10,
                    )
                  ],
                ),
              ),
            );
          }).toList(),
          onChanged: (String? value) {
            setState(() {
              dropdownValue = value!;
            });
          },
        ),
      ),
    );
  }
}
