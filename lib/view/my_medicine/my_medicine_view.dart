import 'package:auto_route/auto_route.dart';
import 'package:digi_patient/generated/assets.dart';
import 'package:digi_patient/resources/colors.dart';
import 'package:digi_patient/routes/routes.gr.dart';
import 'package:digi_patient/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../widgets/back_button.dart';

class MyMedicineView extends StatelessWidget {
  const MyMedicineView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: leadingWidth,
        leading: const CustomBackButton(),
        title: Text("My Medicine", style: TextStyle(fontSize: 18.sp, color: AppColors.primaryColor),),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(defaultPadding.r),
        child: Column(
          children: [
            Container(
              height: 149.h,
              width: double.infinity,
              padding: EdgeInsets.all(8.r),
              decoration: const BoxDecoration(
                color: Colors.white,
                image: DecorationImage(
                  image: AssetImage(Assets.myMedicineMyMedicineFull),
                  fit: BoxFit.fill
                )
              ),
            ),
            SizedBox(height: defaultPadding.h,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: (){
                    context.router.push(RXRoute());
                  },
                  child: Card(child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 18.h),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const CircleAvatar(
                          backgroundImage: AssetImage(Assets.myMedicineMedicineCircle),
                        ),
                        SizedBox(height: 8.r,),
                        Text("Medication ", style: TextStyle(fontSize: 14.sp, color: AppColors.primaryColor),),
                      ],
                    ),
                  ),),
                ),
                Card(child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 18.h),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const CircleAvatar(
                        backgroundImage: AssetImage(Assets.myMedicineBuyMedicineCircle),
                      ),
                      SizedBox(height: 8.r,),
                      Text("Buy Medicine ", style: TextStyle(fontSize: 14.sp, color: AppColors.primaryColor),),
                    ],
                  ),
                ),),
              ],
            ),
          ],
        ),
      ),
    );
  }
}