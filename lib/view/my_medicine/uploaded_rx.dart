import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../generated/assets.dart';
import '../../../resources/colors.dart';
import '../../../resources/styles.dart';
import '../../../widgets/back_button.dart';
import '../../../widgets/shimmer.dart';
import '../../resources/app_url.dart';
import '../../utils/utils.dart';
import '../../view_model/my_medicine_view_model/my_medicine_view_model.dart';
import 'image_view.dart';

class UploadPrescription extends StatefulWidget {
  UploadPrescription({super.key, this.id});

  var id;

  @override
  State<UploadPrescription> createState() => _UploadPrescriptionState();
}

class _UploadPrescriptionState extends State<UploadPrescription> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MyMedicineViewModel>().getPrescriptionRx(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.page_background_color,
      appBar: AppBar(
        backgroundColor: AppColors.primary_color,
        leadingWidth: leadingWidth,
        leading: const CustomBackButton(),
        title: Text("Prescription", style: Style.alltext_appbar),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Consumer<MyMedicineViewModel>(builder: (context, data, child) {
                if (data.imageRxList.isEmpty) {
                  return data.isPrescriptionRxLoading == true
                      ? Center(
                    child: ListView.builder(
                      itemCount: 4,
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
                      : noDataFounForList("No Uploaded History");
                } else {
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        ListView.builder(
                            itemCount: data.imageRxList.length,
                            shrinkWrap: true,
                            physics: ScrollPhysics(),
                            itemBuilder: (context, index) {
                              var info = data.imageRxList[index];
                              return Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: Container(
                                  color: Colors.white,
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.only(left: 8),
                                        //width: 420.w,
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => ImageView(
                                                        image: info
                                                            .prescriptionUrl)));
                                          },
                                          child: Card(
                                            color: Colors.white,
                                            child: Row(

                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 6),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                        children: [
                                                          SizedBox(
                                                            width: 40.w,
                                                            child: Text(
                                                              "Name",
                                                              style: Style
                                                                  .alltext_default_balck,
                                                            ),
                                                          ),
                                                          Text(
                                                            ": ",
                                                            style: Style
                                                                .alltext_default_balck,
                                                          ),
                                                          SizedBox(
                                                            width: 120.w,
                                                            child: Text(
                                                                "${info.patient!.patientFirstName} ${info.patient!.patientMiddleName?? ""} ${info.patient!.patientFirstName}",
                                                                style: Style
                                                                    .alltext_default_balck),
                                                          ),
                                                        ],
                                                      ),
                                                      Style.distan_size2,Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                        children: [
                                                          SizedBox(
                                                            width: 40.w,
                                                            child: Text(
                                                              "Date",
                                                              style: Style
                                                                  .alltext_default_balck,
                                                            ),
                                                          ),
                                                          Text(
                                                            ": ",
                                                            style: Style
                                                                .alltext_default_balck,
                                                          ),
                                                          SizedBox(
                                                            width: 120.w,
                                                            child: Text(
                                                                "${info.date ?? ""}",
                                                                style: Style
                                                                    .alltext_default_balck),
                                                          ),
                                                        ],
                                                      ),
                                                      Style.distan_size2,
                                                    ],
                                                  ),
                                                ),
                                                SizedBox( height: 75.h,
                                                  width: 50.w,
                                                  child: Image.network(
                                                    "${AppUrls.prescription_image}${info.prescriptionUrl}",
                                                    height: 75.h,
                                                    width: 50.w,fit: BoxFit.fill,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                      ],
                    ),
                  );
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}
