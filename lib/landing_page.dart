import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:path_provider/path_provider.dart';
import 'package:portfolio/sidemenu.dart';
import 'package:portfolio/theme.dart';
import 'package:portfolio/utilities/custom_button.dart';
import 'package:portfolio/utilities/custom_textfield.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:open_file_mac/open_file_mac.dart';
// import 'package:http/http.dart' as http;
import 'animate_on_visible.dart';
import 'images.dart';
import 'dart:convert';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool showSecondText = false;
  TextEditingController mobileController = TextEditingController();
  PhoneNumber number = PhoneNumber(isoCode: "PK", dialCode: "");
  PhoneNumber phoneNumber = PhoneNumber();
  final ScrollController _scrollController = ScrollController();
  bool _aboutMeVisible = false; // At the top of your stateful widget

  // bool isHovered = false;
  static const String linkedinUrl =
      'https://www.linkedin.com/in/usama-ilyas-ab5b67257/';

  // static const String githubUrl = 'https://github.com/usamailyas007/';
  static const String githubUrl = 'https://github.com/Devconst-Account/';
  static const String whatsappUrl = 'https://wa.me/+923197026592';
  late final Function(GlobalKey) onMenuTap;
  List<bool> isHoveredList = List.generate(6, (index) => false);
  final GlobalKey servicesKey = GlobalKey();
  final GlobalKey portfolioKey = GlobalKey();
  final GlobalKey aboutMeKey = GlobalKey();
  final GlobalKey contactKey = GlobalKey();
  final GlobalKey homeKey = GlobalKey();
  final GlobalKey skillKey = GlobalKey();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  void _scrollToSection(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(context,
          duration: const Duration(seconds: 1), curve: Curves.easeInOut);
    }
  }

  // Future<void> sendEmailWithEmailJS({
  //   required String firstName,
  //   required String lastName,
  //   required String email,
  //   required String phone,
  //   required String message,
  // }) async {
  //   const serviceId = 'service_oagzr6s';
  //   const templateId = 'your_template_id';
  //   const publicKey = 'your_public_key';
  //
  //   final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
  //
  //   final response = await http.post(
  //     url,
  //     headers: {
  //       'origin': 'http://localhost',
  //       'Content-Type': 'application/json',
  //     },
  //     body: json.encode({
  //       'service_id': serviceId,
  //       'template_id': templateId,
  //       'user_id': publicKey,
  //       'template_params': {
  //         'from_firstname': firstName,
  //         'from_lastname': lastName,
  //         'from_email': email,
  //         'from_phone': phone,
  //         'message': message,
  //       }
  //     }),
  //   );
  //
  //   if (response.statusCode == 200) {
  //     print('✅ Email sent successfully');
  //   } else {
  //     print('❌ Failed to send email: ${response.body}');
  //   }
  // }

  Future<void> _openUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  // Function to update hover state for a specific index
  void _onHover(bool isHovered, int index) {
    setState(() {
      isHoveredList[index] = isHovered;
    });
  }

  _downloadAndOpenCV() async {
    try {
      final ByteData data =
          await rootBundle.load('assets/images/Usama Ilyas.pdf');
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/Usama Ilyas.pdf';

      final File file = File(filePath);
      await file.writeAsBytes(data.buffer.asUint8List());

      final openFileMac = OpenFileMac();
      final result = await openFileMac.open(filePath);

      if (result != null) {
        // Check if there's an error based on the message
        if (result.message != null && result.message!.isNotEmpty) {
          print("Failed to open file: ${result.message}");
        } else {
          print("File opened successfully.");
        }
      } else {
        print("No result received, failed to open file.");
      }
    } catch (e) {
      print("Error opening CV: $e");
    }
  }

  Widget platformButton(String image, Color color, String text, double width,
      Color textColor, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 45,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(mainP),
          color: color,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: mainP),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                image,
                height: 20,
                width: 20,
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                text,
                style: GoogleFonts.onest(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: textColor),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget serviceContainer(String image, String title, String text,
      VoidCallback onTap, bool hoveredList) {
    bool isTablet = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    double width = MediaQuery.of(context).size.width;

    return GestureDetector(
        onTap: onTap,
        child: Container(
          // height: 190,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(p),
              border: Border.all(color: primaryColor),
              color: hoveredList ? primaryColor : null),
          child: Padding(
            padding: EdgeInsets.all(mainP),
            child: ResponsiveRowColumn(
              rowMainAxisAlignment: MainAxisAlignment.spaceBetween,
              layout: ResponsiveRowColumnType.ROW,
              // columnCrossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ResponsiveRowColumnItem(
                    rowOrder: isTablet ? 2 : 1,
                    child: Padding(
                      padding: EdgeInsets.only(
                          right: isTablet ? 20 : 0, left: isTablet ? 5 : 0),
                      child: Container(
                        height: isTablet ? 170 : 120,
                        width: isTablet ? width / 6.2 : 120,
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(isTablet ? 20 : mainP),
                        ),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(p),
                            child: Padding(
                              padding:
                                  EdgeInsets.only(right: isTablet ? 0 : mainP),
                              child: Image.asset(
                                image,
                                fit: BoxFit.cover,
                              ),
                            )),
                      ),
                    )),
                // ResponsiveRowColumnItem(
                //   child: SizedBox(width: 20,),),
                ResponsiveRowColumnItem(
                    rowOrder: isTablet ? 1 : 2,
                    child: Expanded(
                      child: ResponsiveRowColumn(
                        layout: isTablet
                            ? ResponsiveRowColumnType.ROW
                            : ResponsiveRowColumnType.COLUMN,
                        rowMainAxisAlignment: MainAxisAlignment.spaceBetween,
                        columnMainAxisAlignment: MainAxisAlignment.start,
                        columnCrossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ResponsiveRowColumnItem(
                              child: SizedBox(
                            width: isTablet ? width / 4 : null,
                            child: Center(
                              child: Text(
                                title,
                                style: GoogleFonts.onest(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: backgroundColor),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )),
                          ResponsiveRowColumnItem(
                            child:
                                SizedBox(height: isTablet ? 0 : 35, width: 20),
                          ),
                          ResponsiveRowColumnItem(
                            // rowOrder: isTablet ? 1 : 2,
                            child: SizedBox(
                              width: isTablet ? width / 3 : null,
                              child: Text(
                                text,
                                style: GoogleFonts.onest(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: backgroundColor),
                              ),
                            ),
                          )
                        ],
                      ),
                    ))
              ],
            ),
          ),
        ));
  }

  Widget workspaceContainer(String image, String title, String text,
      VoidCallback onTap, double width) {
    bool isTablet = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    return GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.only(bottom: isTablet ? 0 : 20),
          child: Container(
            height: isTablet ? 320 : 280,
            width: width,
            decoration: BoxDecoration(
              color: backgroundColor,
              // border: Border.all(color: greyLightColor.withOpacity(1)),
              borderRadius: BorderRadius.circular(mainP),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    // Shadow color
                    spreadRadius: 2,
                    // Spread radius
                    blurRadius: 6,
                    // Blur radius
                    offset: const Offset(-1, 3),
                    blurStyle: BlurStyle.normal),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  SizedBox(
                    height: 130,
                    width: 130,
                    child: Image.asset(
                      image,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Text(
                    title,
                    textAlign: isTablet ? TextAlign.center : TextAlign.start,
                    style: GoogleFonts.onest(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: darkColor),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          text,
                          style: GoogleFonts.onest(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: darkColor),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Widget projectContainer(String image, String title, VoidCallback onTap,
      String detail, String playStoreLink) {
    bool isTablet = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    double width = MediaQuery.of(context).size.width;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
          onTap: () async {
            if (await canLaunch(playStoreLink)) {
              await launch(playStoreLink); // Launch Play Store link
            } else {
              throw 'Could not launch $playStoreLink';
            }
          },
          child: Padding(
            padding: const EdgeInsets.only(bottom: 60),
            child: SizedBox(
              // height: 290,
              width: isTablet ? width / 3.5 : width,
              child: Column(
                children: [
                  Container(
                    height: 250,
                    width: MediaQuery.of(context).size.width,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(16)),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          image,
                          fit: BoxFit.cover,
                        )),
                  ),
                  SizedBox(height: mainP),
                  Center(
                    child: Text(
                      title,
                      style: GoogleFonts.onest(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: darkColor),
                    ),
                  ),
                  SizedBox(height: mainP),
                  Text(
                    detail,
                    style: GoogleFonts.onest(
                        color: greyColor,
                        fontWeight: FontWeight.w400,
                        fontSize: 16),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  Widget skillContainer(String image, String title) {
    bool isTablet = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    double width = MediaQuery.of(context).size.width;

    return SizedBox(
      height: 170,
      width: isTablet ? 140 : MediaQuery.of(context).size.width / 3.1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 120,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.grey.shade700),
            child: Center(
              child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: backgroundColor),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      image,
                      fit: BoxFit.contain,
                    )),
              ),
            ),
          ),
          Text(
            title,
            style: GoogleFonts.onest(
                color: backgroundColor,
                fontSize: 16,
                fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    bool isTablet = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: isTablet
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: isTablet ? 80 : 0),
                        child: Image.asset(
                          Images.logo,
                          height: 45,
                          width: 45,
                        ),
                      ),
                      SizedBox(width: mainP),
                      Text(
                        'Portfolio',
                        style: GoogleFonts.onest(
                          fontSize: isTablet ? 35 : 20,
                          color: primaryColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      TextButton(
                          onPressed: () {
                            _scrollToSection(homeKey);
                          },
                          child: Text(
                            'Home',
                            style: GoogleFonts.onest(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                          )),
                      TextButton(
                          onPressed: () {
                            _scrollToSection(aboutMeKey);
                          },
                          child: Text(
                            'About Me',
                            style: GoogleFonts.onest(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                          )),
                      TextButton(
                          onPressed: () {
                            _scrollToSection(servicesKey);
                          },
                          child: Text(
                            'Services',
                            style: GoogleFonts.onest(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                          )),
                      TextButton(
                          onPressed: () {
                            _scrollToSection(portfolioKey);
                          },
                          child: Text(
                            'Portfolio',
                            style: GoogleFonts.onest(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                          )),
                      TextButton(
                          onPressed: () {
                            _scrollToSection(skillKey);
                          },
                          child: Text(
                            'Skills',
                            style: GoogleFonts.onest(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                          )),
                      TextButton(
                          onPressed: () {
                            _scrollToSection(contactKey);
                          },
                          child: Text(
                            'Contact',
                            style: GoogleFonts.onest(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                          )),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 60.0),
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: CustomButton(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        text: "Hire Me",
                        width: isTablet ? width / 13 : width / 4,
                        height: 40,
                        onTap: () {
                          _openUrl(whatsappUrl);
                        },
                        backgroundColor: primaryColor,
                      ),
                    ),
                  ),
                ],
              )
            : Text(
                'Portfolio',
                style: GoogleFonts.onest(
                  fontSize: isTablet ? 20 : 20,
                  color: primaryColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
        centerTitle: false,
        leading: isTablet
            ? null
            : IconButton(
                onPressed: () {
                  _scaffoldKey.currentState?.openDrawer();
                },
                icon: Image.asset(
                  Images.menu,
                  height: 25,
                  width: 25,
                  color: primaryColor,
                )),
        actions: [
          isTablet
              ? const SizedBox()
              : Padding(
                  padding: EdgeInsets.only(
                      left: 10,
                      top: 10,
                      bottom: 10,
                      right: isTablet ? 80 : 10.0),
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: CustomButton(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      text: "Hire Me",
                      width: isTablet ? width / 13 : width / 4,
                      height: 40,
                      onTap: () {
                        _openUrl(whatsappUrl);
                      },
                      backgroundColor: primaryColor,
                    ),
                  ),
                )
        ],
      ),
      drawer: isTablet ? null : SideMenu(
          onMenuTap: _scrollToSection,
          aboutMeKey: aboutMeKey,
          homeKey: homeKey,
          servicesKey: servicesKey,
          portfolioKey: portfolioKey,
          skillKey: skillKey,
          contactKey: contactKey),
      body: Container(
        color: backgroundColor,
        width: width,
        height: double.infinity,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                key: homeKey,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: isTablet ? width * 0.06 : mainP,
                      vertical: isTablet ? 30 : mainP),
                  child: Column(
                    children: [
                      ResponsiveRowColumn(
                        layout: isTablet
                            ? ResponsiveRowColumnType.ROW
                            : ResponsiveRowColumnType.COLUMN,
                        children: [
                          ResponsiveRowColumnItem(
                            child: SizedBox(
                              height: isTablet ? 340 : null,
                              width: isTablet ? width / 2 : width,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: isTablet ? width / 2.5 : width,
                                    child: TypeWriterText(
                                      text:
                                          "I'm Usama Ilyas Creative Flutter App Developer",
                                      style: GoogleFonts.onest(
                                        fontSize: isTablet ? 45 : 32.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                      duration:
                                          const Duration(milliseconds: 2000),
                                      onFinished: () {
                                        if (mounted) {
                                          setState(() {
                                            showSecondText = true;
                                          });
                                        }
                                      },
                                      primaryStyle: GoogleFonts.onest(
                                          color: Colors.black),
                                      secondaryStyle: GoogleFonts.onest(
                                          color: primaryColor),
                                      changeAfterLetter: 25,
                                    ),
                                  ),
                                  SizedBox(
                                    height: mainP,
                                  ),
                                  Text(
                                    "Hi! I'm a skilled Flutter developer with over 3.5 years of "
                                    "experience in creating robust mobile apps for Android and iOS."
                                    " Eager to contribute my expertise to impactful projects and collaborate with a forward-thinking"
                                    " team to build cutting-edge apps that enhance user experience.",
                                    style: GoogleFonts.onest(
                                        fontSize: isTablet ? 18 : 14,
                                        fontWeight: isTablet
                                            ? FontWeight.w400
                                            : FontWeight.w500,
                                        color: darkColor),
                                  ),
                                ],
                              ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.2),
                            ),
                          ),
                          ResponsiveRowColumnItem(
                            child: isTablet ? const Spacer() : const SizedBox(),
                          ),
                          ResponsiveRowColumnItem(
                            child: SizedBox(
                              height: isTablet ? 0 : 16,
                            ),
                          ),
                          ResponsiveRowColumnItem(
                            child: SizedBox(
                              height: 308,
                              width: isTablet ? width / 3.1 : width,
                              child: Stack(
                                children: [
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              height: 150,
                                              decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      // Color(0xffeee5fe),
                                                      primaryColor.withOpacity(0.3),
                                                      primaryColor.withOpacity(0.3),
                                                    ],
                                                    begin: Alignment.topLeft,
                                                    end: Alignment.bottomRight,
                                                  ),
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  24),
                                                          topRight:
                                                              Radius.circular(
                                                                  24))),
                                            ),
                                          ),
                                          SizedBox(
                                            width: p,
                                          ),
                                          Expanded(
                                            flex: 5,
                                            child: Container(
                                              height: 150,
                                              decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      // Color(0xfff3dfff),
                                                      primaryColor.withOpacity(0.3),
                                                      primaryColor.withOpacity(0.3),
                                                    ],
                                                    begin: Alignment.topLeft,
                                                    end: Alignment.bottomRight,
                                                  ),
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  24),
                                                          topRight:
                                                              Radius.circular(
                                                                  24))),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        height: 150,
                                        decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                // Color(0xffeee5fe),
                                                primaryColor.withOpacity(0.3),
                                                primaryColor.withOpacity(0.3),                                             ],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            ),
                                            borderRadius: const BorderRadius.only(
                                                bottomLeft: Radius.circular(24),
                                                topRight: Radius.circular(24))),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(20),
                                            child: Image.asset(
                                              Images.mobileApp,
                                              height: 290,
                                            )
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.2),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      ResponsiveRowColumn(
                        layout: isTablet
                            ? ResponsiveRowColumnType.ROW
                            : ResponsiveRowColumnType.COLUMN,
                        children: [
                          ResponsiveRowColumnItem(
                              child: Container(
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: primaryColor.withOpacity(0.3),
                            ),
                            width: isTablet ? width / 4 : width / 1.5,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: GestureDetector(
                                      onTap: () {
                                        _scrollToSection(portfolioKey);
                                      },
                                      child: Container(
                                        height: 50,
                                        width: isTablet ? width / 8 : width / 3,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          color: primaryColor,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Portfolio',
                                              style: GoogleFonts.onest(
                                                  color: backgroundColor,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 14),
                                            ),
                                            Image.asset(
                                              Images.arrow,
                                              height: 10,
                                              width: 10,
                                              color: backgroundColor,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: Padding(
                                      padding: EdgeInsets.only(right: isTablet ? 17 : 0),
                                      child: TextButton(
                                        onPressed: () {
                                          _scrollToSection(contactKey);
                                        },
                                        child: Center(
                                          child: Text(
                                            'Contact Me',
                                            style: GoogleFonts.onest(
                                                fontWeight: FontWeight.w700,
                                                color: darkColor,
                                                fontSize: 14),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.2),
                          )),
                          ResponsiveRowColumnItem(
                            child: isTablet
                                ? const Spacer()
                                : const SizedBox(
                                    height: 16,
                                  ),
                          ),
                          ResponsiveRowColumnItem(
                              child: Container(
                            height: isTablet ? 160 : 180,
                            width: isTablet ? width / 2 : width,
                            decoration: BoxDecoration(
                              color: backgroundColor,
                              // border: Border.all(color: greyLightColor.withOpacity(1)),
                              borderRadius: BorderRadius.circular(mainP),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.03),
                                    spreadRadius: 2,
                                    blurRadius: 6,
                                    offset: const Offset(-1, 3),
                                    blurStyle: BlurStyle
                                        .normal
                                    ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        height: 60,
                                        // width: width / 2,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '15+',
                                              style: GoogleFonts.onest(
                                                  color: primaryColor,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 32),
                                            ),
                                            Text(
                                              'Projects',
                                              style: GoogleFonts.onest(
                                                  color: greyColor,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 14),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 60,
                                        // width: width / 2,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '5',
                                              style: GoogleFonts.onest(
                                                  color: primaryColor,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 32),
                                            ),
                                            Text(
                                              'Companies',
                                              style: GoogleFonts.onest(
                                                  color: greyColor,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 14),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 60,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '3.5+',
                                          style: GoogleFonts.onest(
                                              color: primaryColor,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 32),
                                        ),
                                        Text(
                                          'Years Experience',
                                          style: GoogleFonts.onest(
                                              color: greyColor,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )),
                          const ResponsiveRowColumnItem(
                            child: SizedBox(
                              height: 16,
                            ),
                          ),
                        ],
                      ),
                    ].animate().fadeIn(duration: 500.ms).slideY(begin: 0.2),
                  ),
                ),
              ),
              AnimateOnVisible(
                key: const Key('about_me_visibility'),
                child: Container(
                  height: isTablet ? 700 : null,
                  key: aboutMeKey,
                  color: primaryColor.withOpacity(0.3),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: mainP, vertical: 20),
                    child: ResponsiveRowColumn(
                      layout: isTablet
                          ? ResponsiveRowColumnType.ROW
                          : ResponsiveRowColumnType.COLUMN,
                      children: [
                        ResponsiveRowColumnItem(
                          child: SizedBox(
                            width: isTablet ? width / 2.7 : width,
                            child: Center(
                              child: Container(
                                height: isTablet ? 300 : 200,
                                width: isTablet ? 300 : 200,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(150),
                                  gradient: LinearGradient(
                                    colors: [
                                      primaryColor.withOpacity(0.6),
                                      primaryColor.withOpacity(0.6)],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(150),
                                  child: Image.asset(
                                    Images.myPic,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ).animate()
                                  .fadeIn(duration: 500.ms)
                                  .slideX(begin: -0.2),
                            ),
                          ),
                        ),
                        ResponsiveRowColumnItem(
                          child: isTablet ? const Spacer() : const SizedBox(),
                        ),
                        ResponsiveRowColumnItem(
                          child: SizedBox(
                            width: isTablet ? width / 2 : width,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(height: mainP),
                                Row(
                                  children: [
                                    Text(
                                      "About Me",
                                      style: GoogleFonts.onest(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        color: grey,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: mainP),
                                Row(
                                  children: [
                                    Text(
                                      "Why Did You Choose Me?",
                                      style: GoogleFonts.onest(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w700,
                                        color: darkColor,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "I am a skilled Flutter developer with 3.5 years of experience, specializing in creating user-friendly and high-performance mobile applications. Proficient in Dart and passionate about delivering innovative solutions, I thrive in dynamic environments. Eager to contribute my expertise to impactful projects and collaborate with a forward-thinking team to build cutting-edge apps that enhance user experience.",
                                        style: GoogleFonts.onest(
                                          fontSize: isTablet ? 20 : 14,
                                          fontWeight:
                                          isTablet ? FontWeight.w300 : FontWeight.w500,
                                          color: grey,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: CustomButton(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    text: "Download CV",
                                    width: width,
                                    textColor: backgroundColor,
                                    height: 50,
                                    backgroundColor: primaryColor,
                                    onTap: () => _downloadAndOpenCV(),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Wrap(
                                    spacing: p,
                                    runSpacing: p,
                                    children: [
                                      MouseRegion(
                                        cursor: SystemMouseCursors.click,
                                        child: platformButton(
                                          Images.linkedin,
                                          const Color(0xff1976d2),
                                          "Linkedin",
                                          isTablet ? width / 6 : width / 3,
                                          backgroundColor,
                                              () => _openUrl(linkedinUrl),
                                        ),
                                      ),
                                      MouseRegion(
                                        cursor: SystemMouseCursors.click,
                                        child: platformButton(
                                          Images.github,
                                          lightGrey,
                                          "Github",
                                          isTablet ? width / 8 : width / 3.5,
                                          darkColor,
                                              () => _openUrl(githubUrl),
                                        ),
                                      ),
                                      MouseRegion(
                                        cursor: SystemMouseCursors.click,
                                        child: platformButton(
                                          Images.wp,
                                          const Color(0xff388e3c),
                                          "WhatsApp",
                                          isTablet ? width / 6 : width / 2.8,
                                          backgroundColor,
                                              () => _openUrl(whatsappUrl),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ).animate()
                                .fadeIn(duration: 500.ms)
                                .slideX(begin: 0.2),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              AnimateOnVisible(
                key: const Key('services_visibility'),
                child: Container(
                  key: servicesKey,
                  width: width,
                  color: Colors.black,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: isTablet ? 80 : mainP, vertical: 25),
                    child: Column(
                      children: [
                        Text(
                          "Services",
                          style: GoogleFonts.onest(
                              fontSize: isTablet ? 22 : 18,
                              fontWeight: FontWeight.w700,
                              color: greyColor),
                        ),
                        SizedBox(height: mainP),
                        Text(
                          "My Quality Services",
                          style: GoogleFonts.onest(
                              fontSize: isTablet ? 30 : 24,
                              fontWeight: FontWeight.w700,
                              color: backgroundColor),
                        ),
                        SizedBox(height: isTablet ? 45 : 35),
                        ...List.generate(6, (index) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: mainP),
                            child: MouseRegion(
                              onEnter: (_) => _onHover(true, index),
                              onExit: (_) => _onHover(false, index),
                              child: serviceContainer(
                                [
                                  Images.mobile,
                                  Images.project,
                                  Images.apis,
                                  Images.firebase,
                                  Images.node,
                                  Images.sql
                                ][index],
                                [
                                  "Mobile App Development",
                                  "Custom User Interface Design",
                                  "API Integration (REST APIs)",
                                  "Firebase & Real-Time Database Integration",
                                  "Node.js Backend Development",
                                  "MySQL Database Management"
                                ][index],
                                [
                                  "I specialize in building cross-platform mobile applications using Flutter, delivering smooth and efficient apps for both IOS and Android with a single codebase.",
                                  "I design intuitive, user-friendly interfaces tailored to meet users' specific needs, ensuring an engaging experience with brand consistency.",
                                  "I integrate robust APIs into mobile apps, including Google Maps, Pusher, and other third-party services for seamless data communication.",
                                  "From user authentication to real-time data syncing, I offer complete Firebase Integration for smooth, responsive, and scalable app functionality.",
                                  "Specializing in efficient API development and server-side logic, I build robust, scalable backends with Node.js for secure communication.",
                                  "Experienced in designing and managing relational databases with MySQL, I provide reliable data storage solutions for large-scale applications."
                                ][index],
                                    () {},
                                isHoveredList[index],
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),
              AnimateOnVisible(
                key: const Key('work_process_visibility'),
                child: Container(
                  width: width,
                  height: isTablet ? 600 : null,
                  color: primaryColor.withOpacity(0.3),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: mainP, vertical: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "My Work Process",
                          style: GoogleFonts.onest(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: darkColor,
                          ),
                        ),
                        SizedBox(height: isTablet ? 40 : 25),
                        Wrap(
                          children: [
                            workspaceContainer(
                              Images.research,
                              "Research and Design",
                              "I conduct thorough research and design intuitive user experiences, focusing on accessibility and responsiveness.",
                                  () {},
                              isTablet ? 250 : width,
                            ),
                            SizedBox(
                              height: isTablet ? 0 : mainP,
                              width: isTablet ? mainP : 0,
                            ),
                            workspaceContainer(
                              Images.development,
                              "Development",
                              "I develop high-quality, responsive, and user-friendly mobile and web applications using Flutter, ensuring optimal performance.",
                                  () {},
                              isTablet ? 250 : width,
                            ),
                            SizedBox(
                              height: isTablet ? 0 : mainP,
                              width: isTablet ? mainP : 0,
                            ),
                            workspaceContainer(
                              Images.testing,
                              "Testing",
                              "I perform comprehensive testing to ensure functionality, usability, and performance, guaranteeing a smooth user interface.",
                                  () {},
                              isTablet ? 250 : width,
                            ),
                            const SizedBox(height: 30),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              AnimateOnVisible(
                key: const Key('portfolio_visibility'),
                child: Container(
                  key: portfolioKey,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: mainP),
                    child: Column(
                      children: [
                        const SizedBox(height: 30),
                        Center(
                          child: Text(
                            "Portfolio",
                            style: GoogleFonts.onest(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: darkColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Wrap(
                          spacing: isTablet ? 12 : 0,
                          runSpacing: 20,
                          children: [
                            projectContainer(
                              Images.anad,
                              "ANAD CRM",
                                  () {},
                              'Anad CRM is a powerful app designed to help users effortlessly manage and track their leads. With intuitive features, it enables users to fetch leads, organize customer data, and streamline communication for better sales efficiency. The app offers real-time updates, task management, and analytics to monitor lead progress.',
                              'https://play.google.com/store/apps/details?id=com.paragon.anad.crm',
                            ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.3),

                            projectContainer(
                              Images.duckin,
                              "GO DUCKIN",
                                  () {},
                              "Go Duckin is the ultimate platform for duck enthusiasts! Post and showcase your ducks, explore unique collections, and connect with a community that shares your passion. Whether you're a breeder, collector, or simply a fan, Go Duckin makes it easy to track, manage, and display your beloved ducks in one place.",
                              'https://play.google.com/store/apps/details?id=com.paragon.goduckin',
                            ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.3),

                            projectContainer(
                              Images.ligo,
                              "LIGO APP",
                                  () {},
                              "LIGO is your ultimate ride and delivery companion! Whether you're booking a ride, scheduling a parcel, or transporting cargo, LIGO makes it effortless. With real-time tracking, smooth ride management, and easy reviews, it’s the perfect solution for hassle-free transportation.",
                              'https://play.google.com/store/apps/details?id=com.paragon.godu',
                            ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.3),

                            projectContainer(
                              Images.libas,
                              "Libas",
                                  () {},
                              'Libas is an e-commerce application where preloved brands sell their products. The platform connects buyers with trusted sellers of second-hand fashion items, promoting sustainable shopping and offering premium branded goods at affordable prices.',
                              'https://play.google.com/store/apps/details?id=com.libas.libas&hl=en',
                            ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.3),

                            projectContainer(
                              Images.oga,
                              "OGA",
                                  () {},
                              'OGA is a comprehensive social media application with all the modern features—posts, messaging, likes, comments, and shares—all in one app.',
                              'https://apps.apple.com/us/app/oga-i-on-good-authority/id6739505173',
                            ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.3),

                            projectContainer(
                              Images.alajeeConnect,
                              "Alajee Connect",
                                  () {},
                              'Alajee Connect is an innovative eCommerce app that bridges the gap between service providers and customers for home services, personal care, and more.',
                              'https://play.google.com/store/apps/details?id=com.alaje.alajeconnect',
                            ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.3),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              AnimateOnVisible(
                key: const Key('skills_visibility'),
                child: Container(
                  key: skillKey,
                  width: width,
                  height: isTablet ? 650 : null,
                  color: Colors.black,
                  child: Column(
                    mainAxisAlignment: isTablet
                        ? MainAxisAlignment.center
                        : MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: 30),
                      Text(
                        "My Skills",
                        style: GoogleFonts.onest(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: backgroundColor,
                        ),
                      ),
                      const SizedBox(height: 30),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: isTablet ? 30 : 0),
                        child: Wrap(
                          runSpacing: 20,
                          spacing: 20,
                          children: [
                            skillContainer(Images.flutter, "Flutter"),
                            skillContainer(Images.dart, "Dart"),
                            skillContainer(Images.firebase, "Firebase"),
                            skillContainer(Images.sql, "MySQL"),
                            skillContainer(Images.mongo, "MongoDB"),
                            skillContainer(Images.java, "JavaScript"),
                            skillContainer(Images.node, "Node.js"),
                            skillContainer(Images.api, "Rest APIs"),
                            skillContainer(Images.git, "Git"),
                            skillContainer(Images.github, "GitHub"),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
              AnimateOnVisible(
                key: const Key('education_visibility'),
                child: Container(
                  width: width,
                  color: primaryColor.withOpacity(0.3),
                  child: Column(
                    children: [
                      const SizedBox(height: 35),
                      Text(
                        "Education",
                        style: GoogleFonts.onest(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: darkColor,
                        ),
                      ),
                      const SizedBox(height: 35),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Container(
                          width: width,
                          decoration: BoxDecoration(
                            color: backgroundColor,
                            borderRadius: BorderRadius.circular(mainP),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.03),
                                spreadRadius: 2,
                                blurRadius: 6,
                                offset: const Offset(-1, 3),
                                blurStyle: BlurStyle.normal,
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: primaryColor.withOpacity(0.1),
                                  ),
                                  child: Center(
                                    child: Image.asset(
                                      Images.education,
                                      height: 30,
                                      width: 30,
                                      color: primaryColor,
                                    ),
                                  ),
                                ),
                                SizedBox(width: mainP),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '2020-2024',
                                        style: GoogleFonts.onest(
                                          fontWeight: FontWeight.w600,
                                          color: greyColor,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        'Bachelor\'s of Software Engineering',
                                        style: GoogleFonts.onest(
                                          fontWeight: FontWeight.w700,
                                          color: darkColor,
                                          fontSize: 20,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        'Government College University Faisalabad (GCUF)',
                                        style: GoogleFonts.onest(
                                          fontWeight: FontWeight.w400,
                                          color: darkColor,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 60),
                    ],
                  ),
                ),
              ),
              AnimateOnVisible(
                key: const Key('contact_visibility'),
                child: Container(
                  key: contactKey,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: isTablet ? 140 : 12),
                    child: Column(
                      children: [
                        const SizedBox(height: 40),
                        Center(
                          child: Text(
                            "Let's work together",
                            style: GoogleFonts.onest(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: darkColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        MyCustomTextField(
                          textInputType: TextInputType.text,
                          hintText: 'eg: john',
                          prefixIcon: Icons.person_2_outlined,
                          borderColor: lightGrey,
                          controller: firstNameController,

                        ),
                        SizedBox(height: mainP),
                        MyCustomTextField(
                          textInputType: TextInputType.text,
                          hintText: 'eg: doe',
                          prefixIcon: Icons.person_2_outlined,
                          borderColor: lightGrey,
                          controller: lastNameController,

                        ),
                        SizedBox(height: mainP),
                        MyCustomTextField(
                          textInputType: TextInputType.text,
                          hintText: 'eg: john@gmail.com',
                          prefixIcon: Icons.email_outlined,
                          borderColor: lightGrey,
                          controller: emailController,

                        ),
                        SizedBox(height: mainP),
                        Container(
                          width: width,
                          height: 53,
                          decoration: BoxDecoration(
                            color: backgroundColor,
                            border: Border.all(color: lightGrey),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(left: p),
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(12),
                                bottomRight: Radius.circular(12),
                              ),
                              child: InternationalPhoneNumberInput(
                                onInputChanged: (PhoneNumber number) {
                                  setState(() => phoneNumber = number);
                                },
                                selectorConfig: const SelectorConfig(
                                  selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                                  useBottomSheetSafeArea: true,
                                ),
                                spaceBetweenSelectorAndTextField: 0,
                                ignoreBlank: false,
                                autoValidateMode: AutovalidateMode.disabled,
                                selectorTextStyle: const TextStyle(color: Colors.black),
                                initialValue: number,
                                textFieldController: mobileController,
                                formatInput: true,
                                keyboardType: const TextInputType.numberWithOptions(
                                  signed: true,
                                  decimal: true,
                                ),
                                inputBorder: InputBorder.none,
                                inputDecoration: const InputDecoration(
                                  hintText: "Phone Number",
                                  border: InputBorder.none,
                                  focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
                                  enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
                                  disabledBorder: UnderlineInputBorder(),
                                ),
                                onSaved: (PhoneNumber number) {},
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: mainP),
                        MyCustomTextField(
                          textInputType: TextInputType.text,
                          hintText: 'Write here something...',
                          prefixIcon: Icons.message_outlined,
                          maxLines: 8,
                          borderColor: lightGrey,
                          controller: messageController,

                        ),
                        const SizedBox(height: 40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: CustomButton(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                text: "Send Message",
                                width: isTablet ? width / 7 : width / 2,
                                height: 50,
                                onTap: () {
                                  // sendEmailWithEmailJS(
                                  //   firstName: firstNameController.text,
                                  //   lastName: lastNameController.text,
                                  //   email: emailController.text,
                                  //   phone: mobileController.text,
                                  //   message: messageController.text,
                                  // );
                                  },
                                textColor: backgroundColor,
                                backgroundColor: primaryColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
              AnimateOnVisible(
                key: const Key('contact_info_visibility'),
                child: Container(
                  width: width,
                  color: Colors.black.withOpacity(0.9),
                  padding: EdgeInsets.symmetric(
                    horizontal: isTablet ? 80 : 14,
                    vertical: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Contact Information",
                        style: GoogleFonts.onest(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: backgroundColor,
                        ),
                      ),
                      const SizedBox(height: 30),
                      _infoRow(Icons.call, "+923197026592"),
                      SizedBox(height: mainP),
                      _infoRow(Icons.email, "devusama818@gmail.com"),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _infoRow(IconData icon, String value) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Icon(icon, color: Colors.grey.shade700, size: 20),
      SizedBox(width: mainP),
      Expanded(
        child: Text(
          value,
          style: GoogleFonts.onest(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Colors.grey.shade700,
          ),
        ),
      ),
    ],
  );
}

class TypeWriterText extends StatefulWidget {
  final String text;
  final TextStyle style;
  final Duration duration;
  final VoidCallback onFinished;
  final TextStyle primaryStyle;
  final TextStyle secondaryStyle;
  final int changeAfterLetter;

  TypeWriterText({
    required this.text,
    required this.style,
    required this.duration,
    required this.onFinished,
    required this.primaryStyle,
    required this.secondaryStyle,
    this.changeAfterLetter = 10,
  });

  @override
  _TypeWriterTextState createState() => _TypeWriterTextState();
}

class _TypeWriterTextState extends State<TypeWriterText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _animation =
        IntTween(begin: 0, end: widget.text.length).animate(_controller)
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              widget.onFinished();
            }
          });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String displayedText = widget.text.substring(0, _animation.value);
    List<TextSpan> spans = [];

    for (int i = 0; i < displayedText.length; i++) {
      spans.add(
        TextSpan(
          text: displayedText[i],
          style: i < widget.changeAfterLetter
              ? widget.primaryStyle
              : widget.secondaryStyle,
        ),
      );
    }

    return RichText(
      text: TextSpan(
        children: spans,
        style: widget.style,
      ),
    );
  }
}
