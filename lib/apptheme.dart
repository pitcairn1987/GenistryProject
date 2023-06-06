import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';


class AppTheme {
  AppTheme._();
  static final ThemeData lightTheme = ThemeData(

    useMaterial3: true,

    chipTheme: ChipThemeData(
      labelStyle: TextStyle (color: AppTheme.onButtonColor3, fontSize: 15),
      backgroundColor: AppTheme.buttonColor3,
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      side: BorderSide( color:AppTheme.buttonColor2, width: 0.5, style: BorderStyle.solid  ),
      checkmarkColor: AppTheme.onButtonColor3,
      selectedColor: AppTheme.buttonColor2,
    ),



    listTileTheme: ListTileThemeData(
        textColor: AppTheme.drawerFontColor,
        iconColor: AppTheme.typeIconColor,


    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: AppTheme.textColorMediumBolded
    ),

    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppTheme.buttonColor1,
      contentTextStyle: TextStyle(color: AppTheme.onButtonColor1, fontSize: 15)
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: backgroundColor1,
      iconTheme: IconThemeData(color: textColorHardBolded),
    ),

    dialogTheme: DialogTheme(
      backgroundColor: backgroundColor1,
      titleTextStyle: TextStyle(fontSize: 21,color: textColorHardBolded)
    ),

    segmentedButtonTheme: SegmentedButtonThemeData(
      style:ButtonStyle(
        backgroundColor:  MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
            if (states.contains(MaterialState.selected)){
              return segmentedButtonSelectedColor;
            }
            return Colors.white;
          },
        ),
        side: MaterialStateProperty.resolveWith<BorderSide>((_) {
          return BorderSide.none;
        }),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: textColorHardBolded),
          foregroundColor: textColorHardBolded
      ),
    ),

    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Color(0xFFF15152)
      ),
    ),

    fontFamily: GoogleFonts.manrope(
    ).fontFamily,



  );


  static final ThemeData darkTheme = ThemeData(

    useMaterial3: true,
    progressIndicatorTheme: ProgressIndicatorThemeData(
        color: canvasColor, circularTrackColor: primaryColor, refreshBackgroundColor: canvasColor, linearTrackColor: primaryColor
    ),

    canvasColor: canvasColor,
    colorScheme:  ColorScheme.dark().copyWith(primary: primaryColor),




    chipTheme: ChipThemeData(
      labelStyle: TextStyle (color: AppTheme.onButtonColor3, fontSize: 15),
      backgroundColor: AppTheme.buttonColor3,
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      side: BorderSide( color:AppTheme.buttonColor2, width: 0.5, style: BorderStyle.solid  ),
      checkmarkColor: AppTheme.onButtonColor3,
      selectedColor: AppTheme.buttonColor2,
    ),




    listTileTheme: ListTileThemeData(
      textColor: AppTheme.drawerFontColor,
      iconColor: AppTheme.typeIconColor

    ),

    textSelectionTheme: TextSelectionThemeData(
        cursorColor: AppTheme.textColorMediumBolded
    ),

    snackBarTheme: SnackBarThemeData(
        backgroundColor: AppTheme.buttonColor1,
        contentTextStyle: TextStyle(color: AppTheme.onButtonColor1, fontSize: 15)
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: backgroundColor1,
      iconTheme: IconThemeData(color: appBarIconFontColor),
      titleTextStyle: TextStyle(color: appBarIconFontColor, fontSize: 21)
    ),

    dialogTheme: DialogTheme(
        backgroundColor: backgroundColor1,
        titleTextStyle: TextStyle(fontSize: 21,color: dialogFontColor),
        contentTextStyle: TextStyle(fontSize: 17,color: dialogFontColor)
    ),

    segmentedButtonTheme: SegmentedButtonThemeData(
      style:ButtonStyle(


       foregroundColor: MaterialStateProperty.resolveWith<Color>((_) {
          return segmentedButtonIconColor;
        }),

        iconColor: MaterialStateProperty.resolveWith<Color>((_) {
          return segmentedButtonIconColor;
        }),





        textStyle: MaterialStateProperty.resolveWith<TextStyle>((_){
            return TextStyle(color: Colors.white);
          },
        ),

        backgroundColor:  MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
            if (states.contains(MaterialState.selected)){
              return segmentedButtonSelectedColor;
            }
            return segmentedButtonColor;
          },
        ),
        side: MaterialStateProperty.resolveWith<BorderSide>((_) {
          return isThemeDark
                ? BorderSide(color:Color(0xffebe4aa),width: 0.7,)
                : BorderSide.none;
        }),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
          side: BorderSide(color: outlinedBorderColor),
          foregroundColor: outlinedForegroundColor
      ),
    ),

    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
          foregroundColor: filledButtonFontColor,
          backgroundColor: filledButtonColor
      ),
    ),

    fontFamily: GoogleFonts.manrope(
    ).fontFamily,


  );





  // Custom colors
  static bool isThemeDark = false;

 // static set isThemeDark(bool value) {_isThemeDark = value;}


  static get canvasColor => isThemeDark ? Color(0xff783100) : Color(0xFFF15152);
  static get primaryColor => isThemeDark ? Color(0xffebe4aa) : Colors.white;


  static get backgroundColor1 => isThemeDark ? Color(0xff201a18) : Color(0xfffeebe3);
  static get backgroundColor2 => isThemeDark ? Colors.black87 : Color(0xffFEF9F6);
  static get selectedItemColor1 => isThemeDark ? Color(0xff36302f)  : Color(0xFFEDB183);
  static get buttonColor1 => isThemeDark ? Color(0xff783100) : Color(0xFFF15152);
  static get onButtonColor1 => isThemeDark ? Color(0xffffdbcb) : Colors.white;
  static get buttonColor2 => isThemeDark ? Color(0xff5c4032): Color(0xFFEDB183);
  static get onButtonColor2 => isThemeDark ? Color(0xffffdbcb) : Colors.black87;
  static get buttonColor3 => isThemeDark ? Color(0xff4c481c) : Color(0xfffeebe3);
  static get onButtonColor3 => isThemeDark ? Color(0xffebe4aa) : Colors.black87;
  static get outlinedForegroundColor => isThemeDark ? Color(0xffebe4aa) : Colors.black87;
  static get outlinedBorderColor => isThemeDark ? Color(0xffebe4aa) : Colors.black87;
  static get focusedBorder => isThemeDark ? Colors.redAccent : Colors.black54;
  static get errorBorder => isThemeDark ? Colors.redAccent : Color(0xFFF15152);
  static get enabledBorder => isThemeDark ? Colors.redAccent : Color(0xff81939d);

  static get textColorMediumBolded => isThemeDark ? Color(0xfffeebe3) : Color(0xff564A4A);
  static get textColorHardBolded => isThemeDark ? Color(0xfffeebe3) : Colors.black87;

  static get inputFillColor => isThemeDark ? Color(0xff36302F).withOpacity(0.2) : Color(0xfffef3ee);



  static get typeIconColor => isThemeDark ? Color(0xffebe4aa) : Colors.blue[700];
  static get geoIconColor => isThemeDark ? Color(0xffebe4aa):  Colors.blue.withOpacity(0.8);

  static get filledButtonColor => isThemeDark ? Color(0xffebe4aa): Color(0xFFF15152);
  static get filledButtonFontColor => isThemeDark ? Colors.black87: Colors.white;


  static get drawerBackground => isThemeDark ?  Color(0xff201a18) : Color(0xfffeebe3);
  static get drawerFontColor => isThemeDark ?  Color(0xffede0db):  Color(0xff564A4A);
  static get drawerIconColor => isThemeDark ?  Color(0xffebe4aa):  Color(0xff564A4A);
  static get drawerSelectedColor => isThemeDark ?  Color(0xff36302f)  : Color(0xFFEDB183);


  static get graveTileBackground => isThemeDark ?  Color(0xff201a18) : Color(0xfffeebe3);


  static get segmentedButtonColor => isThemeDark ?  Color(0xff201a18) : Color(0xfffeebe3);
  static get segmentedButtonSelectedColor => isThemeDark ?  Color(0xff36302f) : Colors.white;
  static get segmentedButtonIconColor => isThemeDark ?  Color(0xffebe4aa) : Colors.black87;


  static get searchButtonColor => isThemeDark ?  Color(0xff52443d) : Colors.white;
  static get searchButtonIconColor => isThemeDark ?  Color(0xffd7c2b9) : Colors.black87;

  static get errorColor => isThemeDark ?  Color(0xFFF15152) : Color(0xFFF15152);

  static get inputFontColor => isThemeDark ?  Color(0xFFede0db) : Colors.black87;
  static get inputLabelFontColor => isThemeDark ?  Color(0xFFebe4aa) : Color(0xff564A4A);

  static get formIconColor => isThemeDark ?  Color(0xffebe4aa):  Color(0xff564A4A);



  static get appBarIconFontColor => isThemeDark ?  Color(0xFFede0db) : Colors.black87;


  static get dialogFontColor => isThemeDark ?   Color(0xFFede0db) : Colors.black87;


  static get badgeBackground => isThemeDark ?   Color(0xffebe4aa) : Colors.blueGrey;
  static get badgeFontColor => isThemeDark ?   Colors.black87 : Colors.white;


  static get activeFiltersBorderColor => isThemeDark ?   Color(0xffebe4aa) : Colors.blue.withOpacity(0.8);




}







/*class AppTheme{


  const AppTheme();
  static  AppColors colors = AppColors();
  static ThemeData lightTheme(){
    return ThemeData(

      segmentedButtonTheme: SegmentedButtonThemeData(
        style:ButtonStyle(


          backgroundColor:  MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
              if (states.contains(MaterialState.selected)){
                return colors.selectedItemColor1;
              }
              return Colors.white;
            },
          ),

          side: MaterialStateProperty.resolveWith<BorderSide>((_) {
            return BorderSide.none;

          }),

        ),



      ),



      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(

            foregroundColor: colors.outlinedForegroundColor
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: colors.buttonColor1
        ),
      ),


      fontFamily: GoogleFonts.manrope(

        // fontWeight: FontWeight.w400
      ).fontFamily,


      textTheme: TextTheme(


        headlineLarge:  TextStyle(fontSize: 72.0, color: Colors.black87),
        displayLarge: TextStyle(fontSize: 21.0, color: Colors.black87),
        displayMedium: TextStyle(fontSize: 17.0, color: Colors.black87),
        displaySmall: TextStyle(fontSize: 14.0, color: Colors.black87),
      ),

      /*     buttonTheme: ButtonTheme(


          )



          extensions: <ThemeExtension<dynamic>>[
            const MyColors(
              mainBackgroundColor: Color(0xfffee6dc),
              floatingButtonColor: Color(0xFFF15152),
              drawerItemSelectedColor: Color(0xFFEDB183),
              filledButtonColor: Color(0xFFF15152),
            ),
          ],*/


      useMaterial3: true,
   //   colorScheme: lightScheme,
      // extensions: [lightCustomColors],
      //  colorScheme: Colors.redAccent,
      //useMaterial3: true,
      //colorSchemeSeed: Color(0xfffee6dc)
    );
  }
}
*/


