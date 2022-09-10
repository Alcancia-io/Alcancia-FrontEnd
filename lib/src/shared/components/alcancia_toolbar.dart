import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:alcancia/src/shared/components/alcancia_components.dart';

enum stateToolbar {
  logoNoletters ,
  logoLetters,
  titleIcon,
  profileTitleIcon
}
// extension stateToolbarValue on stateToolbar {
//   String get name => describeEnum(this);
//
//    String get displayTitle {
//      switch(this) {
//        case stateToolbar.logoLetters: return "logoNoletters";
//      }
//    }
// }
class AlcanciaToolbar extends StatelessWidget {
  const AlcanciaToolbar({Key? key, this.title, required this.state, this.userName,required this.height }) : super(key: key);
  final String? title;
  final String? userName;
  final double height;
  /*
  logo-noletters
  logo-letters
  title-icon
  profile-title-icon
   */
  final stateToolbar state;
  @override
  Widget build(BuildContext context) {
    var txtTheme = Theme.of(context).textTheme;
     switch(state) {
       case stateToolbar.logoNoletters:
         return Row(
           mainAxisAlignment: MainAxisAlignment.center,
           children: [AlcanciaLogo(height: height)],
         );
       case stateToolbar.logoLetters:
         return Row(
           mainAxisAlignment: MainAxisAlignment.center,
           children: [AlcanciaLogo(letters: true,
             height: height,
           ),],
         );
       case stateToolbar.titleIcon:
         return Container(
           padding: const EdgeInsets.only(top: 10,bottom: 10),
           child: Stack(
             children: [
               Align(
                 alignment: Alignment.center,
                 child: Text("${title}",style: txtTheme.subtitle1,),
               ),
               Align(
                 alignment: Alignment.topRight,
                 child: Transform(transform: Matrix4.translationValues(0, -10, 0),child: AlcanciaLogo(
                   height: height,
                 ) ,)
               ),
             ],
           ),
         );
       case stateToolbar.profileTitleIcon:
          return Container(
            padding: const EdgeInsets.only(bottom: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset(
                      "lib/src/resources/images/profile.png",
                      width: 38,
                      height: 38,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: Text(
                        "Hola, ${userName}",
                        style: txtTheme.subtitle1,
                      ),
                    ),
                  ],
                ),
                AlcanciaLogo(
                  height: height,
                ),
              ],
            ),
          );
       default:
         return Text("Default");
     }

    //  return Container(
    //   padding: const EdgeInsets.only(bottom: 24),
    //   child: Row(
    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //     children: [
    //       Row(
    //         children: [
    //           Image.asset(
    //             "lib/src/resources/images/profile.png",
    //             width: 38,
    //             height: 38,
    //           ),
    //           Padding(
    //             padding: EdgeInsets.only(left: 16),
    //             child: Text(
    //               title,
    //               style: TextStyle(
    //                 fontSize: 20,
    //                 fontWeight: FontWeight.bold,
    //               ),
    //             ),
    //           ),
    //         ],
    //       ),
    //       AlcanciaLogo(
    //         height: 38,
    //       ),
    //     ],
    //   ),
    // );
  }
}
