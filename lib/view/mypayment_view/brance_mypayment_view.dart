import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';

import '../../generated/assets.dart';
import '../../resources/app_url.dart';
import '../../resources/colors.dart';
import '../../resources/styles.dart';
import '../../utils/utils.dart';
import '../../view_model/clinic/my_clinic_view_model/my_clinic_doctor_view_model.dart';
import '../../view_model/mypayment/my_payment_view.dart';
import '../../widgets/back_button.dart';
import '../../widgets/shimmer.dart';

class MyBrancePatmentView extends StatefulWidget {
   MyBrancePatmentView({super.key,this.DbName});
String? DbName;
  @override
  State<MyBrancePatmentView> createState() => _MyPatientViewState();
}

class _MyPatientViewState extends State<MyBrancePatmentView> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print("object${widget.DbName}");

      context.read<MyClinicDoctorViewModel>().getmypayment(context,widget.DbName.toString());
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("object");
    final myRecord = Provider.of<MyClinicDoctorViewModel>(context, listen: false);

    return SafeArea(
        child: RefreshIndicator(
      onRefresh: () async {
        context.read<MyClinicDoctorViewModel>().getmypayment(context,widget.DbName.toString());
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          leading:  CustomBackButton(),
          leadingWidth: leadingWidth,
          backgroundColor: AppColors.primaryColor,
          //automaticallyImplyLeading: false,

          centerTitle: true,
          title: Text(
            "My Payments",
            style: Style.alltext_default_white,
          ),
        ),
        body: Container(
          margin: EdgeInsets.only(left: 8, right: 8, top: 10),
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Consumer<MyClinicDoctorViewModel>(builder: (context, data, child) {
                  if (data.mypayment.isEmpty) {
                    return data.isDoctorLoading == true
                        ? Center(
                            child: ListView.builder(
                              itemCount: 6,
                              scrollDirection: Axis.vertical,
                              physics: const ScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: bannerShimmereffect(
                                      94.toDouble(), 385.toDouble()),
                                );
                              },
                            ),
                          )
                        : noDataFounForList("Currently you have no records");
                  } else {
                    return Column(
                      children: [
                        ListView.builder(
                            itemCount: data.mypayment.length,
                            scrollDirection: Axis.vertical,
                            physics: const ScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              var item = data.mypayment[index];
                              return Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: Card(
                                  elevation: 2,
                                  color: Colors.white,
                                  //shadowColor: Colors.black,
                                  child: Container(
                                    color: Colors.white,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [

                                          Style.widthdistan_size2,
                                          SizedBox(
                                            width: 220.w,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [

                                                Style.distan_size2,

                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      width: 70.w,
                                                      child: Text(
                                                        "Amount",
                                                        style: Style
                                                            .alltext_default_balck,
                                                      ),
                                                    ),
                                                    Text(":  "),
                                                    SizedBox(
                                                      width: 130.w,
                                                      child: Text(
                                                          item.amount
                                                              .toString(),
                                                          style: Style
                                                              .alltext_default_balck),
                                                    ),
                                                  ],
                                                ),
                                                Style.distan_size2,

                                                Style.distan_size2,
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      width: 70.w,
                                                      child: Text(
                                                        "Date",
                                                        style: Style
                                                            .alltext_default_balck,
                                                      ),
                                                    ),
                                                    Text(":  "),

                                                  ],
                                                ),
                                                Style.distan_size2,
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            })
                      ],
                    );
                  }
                }),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
