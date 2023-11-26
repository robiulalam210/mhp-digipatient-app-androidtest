import 'dart:io';
import 'package:badges/badges.dart' as badges;
import 'package:badges/badges.dart';
import 'package:digi_patient/view/authentications/user_detail_view.dart';
import 'package:digi_patient/view/daily_upcomming_appointment/daily_and_upcomming_appointments_view.dart';
import 'package:digi_patient/view/payment/invoice_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterzilla_fixed_grid/flutterzilla_fixed_grid.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../generated/assets.dart';
import '../../resources/app_url.dart';
import '../../resources/colors.dart';
import '../../resources/styles.dart';
import '../../utils/message.dart';
import '../../utils/route/routes_name.dart';
import '../../utils/user.dart';
import '../../view_model/auth_view_model.dart';
import '../../view_model/home_view_model.dart';
import '../../view_model/mydoctor/new_my_doctor_view_model.dart';
import '../../view_model/user_view_model/user_view_model.dart';
import '../../widgets/back_button.dart';
import '../../widgets/drawer_list_tile.dart';
import '../../widgets/shimmer.dart';
import '../privacy_policy/privacypolicy.dart';
import '../support/support_page.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  TextEditingController userName = TextEditingController();
  TextEditingController password = TextEditingController();
  String? name = "";

  @override
  void initState() {
    super.initState();
    getUserData();
    context.read<UserViewModel>().getUserDetails();
  }

  getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    name = prefs.getString(UserP.name) ?? "";

    bool isLoggedIn = prefs.getBool(UserP.isLoggedIn) ?? false;

    String role = prefs.getString(UserP.role) ?? "";

    if (isLoggedIn) {
      context.read<AuthViewModel>().onUserLogin();
    } else {
      context.read<AuthViewModel>().onUserLogout();
    }
  }

  @override
  void dispose() {
    super.dispose();
    userName.dispose();
    password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double width = (size.width / 3);
    debugPrint(size.width.toString());


    final auth = Provider.of<AuthViewModel>(context, listen: false);
    final dvm = Provider.of<MyDoctorDelaisViewModel>(context, listen: false);
    return WillPopScope(
      onWillPop: () {
        return exit(0);
      },
      child: SafeArea(
        top: true,
        maintainBottomViewPadding: true,
        child: Scaffold(
          backgroundColor: AppColors.backgroundColor,
          extendBody: true,
          drawer: Drawer(
            width: width,
            shape: OutlineInputBorder(
              borderRadius:
                  BorderRadius.only(bottomRight: Radius.circular(70.w)),
              borderSide: BorderSide.none,
            ),
            child: ListView(
              padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 40.h),
              shrinkWrap: true,
              children: [
                Row(
                  children: [
                    const CustomBackButton(
                      margin: 0,
                      padding: 8,
                    ),
                    Expanded(
                        child: Text(
                      "Menu",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor),
                    )),
                  ],
                ),
                SizedBox(
                  height: 50.h,
                ),
                DrawerListTile(
                  iconData: Icons.person,
                  title: "Profile",
                  onTap: () {
                    // Navigator.push(context, MaterialPageRoute(builder: (context)=>UserDetailView(user: userprovide)));

                    // context.router.push(UserDetailRoute(user: user));
                  },
                ),
                SizedBox(
                  height: 6.h,
                ),
                DrawerListTile(
                  iconData: Icons.calendar_view_day,
                  title: "Appointment",
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DailyAndUpcommingView()));

                    // context.router.push(const DailyAndUpcommingRoute());
                  },
                ),
                SizedBox(
                  height: 6.h,
                ),
                DrawerListTile(
                  iconData: Icons.favorite_border,
                  title: "Favourite",
                  onTap: () {},
                ),
                SizedBox(
                  height: 6.h,
                ),
                DrawerListTile(
                  iconData: Icons.payment,
                  title: "Payment & Invoice",
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => InvoiceView()));
                    //  context.router.push(const InvoiceRoute());
                  },
                ),
                SizedBox(
                  height: 6.h,
                ),
                DrawerListTile(
                  iconData: Icons.fact_check_outlined,
                  title: "FAQ",
                  onTap: () {},
                ),
                SizedBox(
                  height: 6.h,
                ),
                DrawerListTile(
                  iconData: Icons.support,
                  title: "Support",
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SupportPage()));
                  },
                ),
                SizedBox(
                  height: 6.h,
                ),
                DrawerListTile(
                  iconData: Icons.privacy_tip,
                  title: "Privacy & Policy",
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PrivacyPolicy()));
                  },
                ),
                SizedBox(
                  height: 6.h,
                ),
                Card(
                  color: AppColors.primaryColor,
                  child: ListTile(
                    onTap: () async {
                      final prefs = await SharedPreferences.getInstance();

                      await prefs.setBool(UserP.isLoggedIn, false);
                      auth.onUserLogout();
                      Navigator.pushNamed(context, RoutesName.login);
                      //  context.router.replace(const SignInRoute());
                    },
                    leading: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.logout,
                        size: 15.h,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    title: Text(
                      "Logout",
                      style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  "V 2.0.0(200)",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 12.sp, color: const Color(0xFFAAAAAA)),
                ),
                SizedBox(
                  height: 100.h,
                ),
              ],
            ),
          ),
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: Builder(builder: (context) {
              return InkWell(
                onTap: () {
                  Scaffold.of(context).openDrawer();
                },
                child: Image.asset(
                  Assets.iconsDrawer,
                  height: 100,
                  width: 100,
                ),
              );
            }),
            title: Container(
              height: 30.h,
              // width: double.infinity,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(Assets.imagesMacroHealthPlus))),
            ),
            actions: [
              badges.Badge(
                  position: BadgePosition.topEnd(top: 3, end: 6),
                  badgeContent: const Text(
                    "6",
                    style: TextStyle(color: Colors.white),
                  ),
                  child: IconButton(
                      onPressed: () {
                        //  context.router.push(const NotificationsRoute());
                      },
                      icon: Icon(
                        Icons.notification_important,
                        color: AppColors.primaryColor,
                      ))),
              SizedBox(
                width: 8.w,
              ),
            ],
          ),
          body: ListView(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            children: [
              Container(
                height: 150.h,
                width: double.infinity,
                decoration: const BoxDecoration(
                    // image: DecorationImage(
                    //     image: AssetImage(Assets.imagesWelcomeBackground))
                    ),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Consumer<UserViewModel>(
                        builder: (context, userprovider, child) {
                      if (userprovider.userData.isEmpty) {
                        return userprovider.isUserLoading == true
                            ? Center(
                                child: ListView.builder(
                                  itemCount: 1,
                                  scrollDirection: Axis.vertical,
                                  physics: const ScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: bannerShimmereffect(
                                          120.toDouble(), 400.toDouble()),
                                    );
                                  },
                                ),
                              )
                            : noDataFounForList("");
                      } else {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Hello!",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18.sp,
                                      color: AppColors.primaryColor),
                                ),
                                SizedBox(
                                  height: 4.h,
                                ),
                                Text(
                                  "$name",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.sp,
                                      color: const Color(0xFF454545)),
                                ),
                                SizedBox(
                                  height: 4.h,
                                ),
                                Text(
                                  "Welcome to MacroHealthPlus",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: const Color(0xFF7A7A7A),
                                  ),
                                ),
                              ],
                            ),
                            CircleAvatar(
                                radius: 40,
                                backgroundImage: NetworkImage(
                                    "${AppUrls.image}${userprovider.user?.patientImages}"))
                          ],
                        );
                      }
                    }),
                  ),
                ),
              ),
              SizedBox(
                height: 6.h,
              ),

              // ZegoSendCallInvitationButton(
              //   isVideoCall: true,
              //   resourceID: "digi_project",
              //   //You need to use the resourceID that you created in the subsequent steps. Please continue reading this document.
              //   invitees: [
              //     ZegoUIKitUser(
              //       id: "2",
              //       name: "Mhp",
              //     ),
              //   ],
              // ),
              // Card(
              //   shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(12.h)),
              //   child: Padding(
              //     padding: EdgeInsets.symmetric(horizontal: 0, vertical: 8.h),
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.spaceAround,
              //       children: [
              //         CircleAvatar(
              //             backgroundColor: const Color(0xFFF0F3F6),
              //             child: IconButton(
              //                 onPressed: () {
              //                   // NotificationService().sendNotification(body: "f__eQHA9TFmTrIFGdUh_e8:APA91bGyUQ5AxCwcQwtTFgxfpiUA2WGLHCGt2C4bnLazfCFRyqA1fl_KVX-zIkq27tmX-RTO_JGn_QpGBAEFpbBA0qCdn2gf-2-OZhGpqtSGEbaKbJW9Fgcdi3pmpjmsIvyBIFg6hzND", senderId: "senderId");
              //                   // context.router.push(const ChatRoute());
              //                 },
              //                 icon: Icon(
              //                   Icons.call,
              //                   size: 18.h,
              //                   color: AppColors.primaryColor,
              //                 ))),
              //         CircleAvatar(
              //             backgroundColor: const Color(0xFFF0F3F6),
              //             child: IconButton(
              //                 onPressed: () {
              //                   // videoCall.getVideoCallToken(context, appId: appId, channelName: channelName, userId: channelName);
              //                 },
              //                 icon: Icon(
              //                   Icons.video_call,
              //                   size: 18.h,
              //                   color: AppColors.primaryColor,
              //                 ))),
              //         CircleAvatar(
              //             backgroundColor: const Color(0xFFF0F3F6),
              //             child: IconButton(
              //                 onPressed: () {
              //                   // context.router.push(const ChatRTMRoute());
              //                   showDialog(
              //                     context: context,
              //                     builder: (context) => AlertDialog(
              //                       title: const Text("Login"),
              //                       actions: [
              //                         TextButton(
              //                             onPressed: () {
              //                               // context.router.push( AgoraChatPageRoute(chatKey: appKey, userId: userId, agoraToken: agoraToken, receiverId: receiverId));
              //                             },
              //                             child: const Text("Log-In")),
              //                       ],
              //                       content: Column(
              //                         children: [
              //                           TextField(
              //                             controller: userName,
              //                           ),
              //                           TextField(
              //                             controller: password,
              //                           ),
              //                         ],
              //                       ),
              //                     ),
              //                   );
              //                 },
              //                 icon: Icon(
              //                   Icons.message,
              //                   size: 18.h,
              //                   color: AppColors.primaryColor,
              //                 ))),
              //       ],
              //     ),
              //   ),
              // ),
              // SizedBox(
              //   height: 6.h,
              // ),
              Text(
                "What do you need?",
                style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF8A8A8A)),
              ),
              SizedBox(
                height: 4.h,
              ),
              Consumer<MyDoctorDelaisViewModel>(builder: (context, dvm, child) {
                return Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.h)),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 0, vertical: 6.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          width: 200.w,
                          height: 40.h,
                          child: TextField(
                            controller: dvm.controllerRequest,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey)),
                                hintText: 'Enter 6 Digit Code',
                                labelText: 'Add Doctor / Clinic',
                                suffixStyle: TextStyle(color: Colors.green)),
                          ),
                        ),
                        MaterialButton(
                          onPressed: () {
                            if (dvm.controllerRequest.text.isNotEmpty) {
                              dvm.docotrRequest(
                                  context, dvm.controllerRequest.text);
                            } else {
                              Messages.snackBar(
                                context,
                                "Enter Doctor identity number",
                              );
                            }
                          },
                          color: AppColors.primaryColor,
                          child: Text("Submit"),
                        )
                      ],
                    ),
                  ),
                );
              }),

              SizedBox(
                height: 4.h,
              ),
              Consumer<HomeViewModel>(builder: (context, provider, child) {
                return GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: FlutterzillaFixedGridView(
                        crossAxisCount: 3,
                        mainAxisSpacing: 5,
                        crossAxisSpacing: 10,
                        height: 90.h),
                    itemCount: provider.homeItemsList.length,
                    itemBuilder: (BuildContext context, index) {
                      return InkWell(
                        onTap: () {
                          if (index == 0) {
                            dvm.getmyAllDoctors(context);
                          }

                          provider.homeItemsRouteTo(context, index);
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              height: 70.h,
                              width: double.infinity,
                              child: Card(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(12.0.r),
                                  child: Image.asset(
                                    provider.homeItemsList[index].image,
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              provider.homeItemsList[index].title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: Style.alltext_default_balck,
                            )
                          ],
                        ),
                      );
                    });
              }),

              SizedBox(
                height: 100.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
