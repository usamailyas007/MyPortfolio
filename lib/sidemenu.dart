import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:portfolio/theme.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'images.dart';

class SideMenu extends StatefulWidget {
  final Function(GlobalKey) onMenuTap;
  final GlobalKey aboutMeKey;
  final GlobalKey homeKey;
  final GlobalKey servicesKey;
  final GlobalKey portfolioKey;
  final GlobalKey skillKey;
  final GlobalKey contactKey;
  const SideMenu({super.key,
    required this.onMenuTap,
    required this.aboutMeKey,
    required this.homeKey,
    required this.servicesKey,
    required this.portfolioKey,
    required this.skillKey,
    required this.contactKey,
  });

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  @override
  Widget build(BuildContext context) {
    bool isTablet = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    return Drawer(
      shape: const OutlineInputBorder(
        borderSide: BorderSide.none,
          borderRadius: BorderRadius.only(
          topRight: Radius.circular(25),
          bottomRight: Radius.circular(25))),
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 150,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          height: 50,
                          width: 50,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: CachedNetworkImage(
                              imageUrl: '',
                              placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) => SizedBox(
                                height: 50,
                                width: 50,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Image.asset(
                                    Images.myPic,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Usama Ilyas",
                                  textAlign: TextAlign.start,
                                  style: GoogleFonts.onest(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 15,
                                      color: primaryColor),
                                ),
                              ],
                            ),
                            Text(
                              "devusama818@gmail.com",
                              textAlign: TextAlign.start,
                              style: GoogleFonts.onest(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  "03197026592",
                                  textAlign: TextAlign.start,
                                  style: GoogleFonts.onest(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.arrow_forward_ios_outlined,
                          size: 20,
                        )
                      ],
                    ),
                    const SizedBox(height: 25),
                  ],
                ),
              ),
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                    ListTile(
                      leading: Icon(
                        Iconsax.home,
                        color: primaryColor,
                        size: 25,
                      ),
                      title: Text(
                        "Home",
                        style: GoogleFonts.onest(
                          color: primaryColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        widget.onMenuTap(widget.homeKey);
                      },
                    ),
                    ListTile(
                      leading: Icon(
                        Iconsax.profile_circle,
                        color: primaryColor,
                        size: 25,
                      ),
                      title: Text(
                        "About Me",
                        style: GoogleFonts.onest(
                          color: primaryColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        widget.onMenuTap(widget.aboutMeKey);

                      },
                    ),
                    ListTile(
                      leading: Image.asset(Images.services,height: 25,width: 25,color: primaryColor,),
                      title: Text(
                        "Services",
                        style: GoogleFonts.onest(
                          color: primaryColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        widget.onMenuTap(widget.servicesKey);
                      },
                    ),
                    ListTile(
                      leading: Image.asset(Images.portfolio,height: 25,width: 25,color: primaryColor,),
                      title: Text(
                        "Portfolio",
                        style: GoogleFonts.onest(
                          color: primaryColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        widget.onMenuTap(widget.portfolioKey);
                      },
                    ),
                    ListTile(
                      leading: Image.asset(Images.skills,height: 25,width: 25,color: primaryColor,),
                      title: Text(
                        "Skills",
                        style: GoogleFonts.onest(
                          color: primaryColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        widget.onMenuTap(widget.skillKey);
                      },
                    ),
                    ListTile(
                      leading: Icon(
                        Iconsax.call,
                        color: primaryColor,
                        size: 25,
                      ),
                      title: Text(
                        "Contact",
                        style: GoogleFonts.onest(
                          color: primaryColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        widget.onMenuTap(widget.contactKey);
                      },
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
