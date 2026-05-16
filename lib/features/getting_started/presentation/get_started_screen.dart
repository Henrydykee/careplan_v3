import 'package:careplan/core/presentation/widgets/app_bar.dart';
import 'package:careplan/core/presentation/widgets/button.dart';
import 'package:careplan/core/presentation/widgets/router.dart';
import 'package:careplan/core/presentation/widgets/text_holder.dart';
import 'package:careplan/core/resources/assets.dart';
import 'package:careplan/core/utils/color.dart';
import 'package:careplan/features/auth/presentation/login_flow/login_screen.dart';
import 'package:careplan/features/auth/presentation/sign-up-flow/create_account_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

import 'slide_list.dart';

class GetStartedScreen extends StatefulWidget {
  GetStartedScreen({Key? key}) : super(key: key);

  @override
  _GetStartedScreenState createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> {
  final PageController _pageController =
      PageController(initialPage: 0, keepPage: true);
  // ignore: unused_field
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        showBackIcon: false,
      ),
      backgroundColor: Color(0xFFFAFAFA),
      body: Stack(
        children: [
          Column(
            children: [
              Gap(40),
              Expanded(
                child: PageView.builder(
                  onPageChanged: _onPageChanged,
                  controller: _pageController,
                  physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, i) => SliderItem(i),
                  itemCount: slideList.length,
                ),
              ),
              Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, bottom: 15),
                    child: CustomButtom(
                      title: "Get Started",
                      btnColor: CarePlanColor.orange,
                      textColor: Colors.white,
                      assetImage: Assets.get_started_icon,
                      onTap: () => router.push(CreateAccountScreen()),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, bottom: 30),
                    child: CustomButtom(
                      title: "Login",
                      textColor: Colors.white,
                      btnColor: CarePlanColor.orange,
                      onTap: () => router.push(LoginScreen()),
                    ),
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SliderItem extends StatelessWidget {
  final int index;
  SliderItem(this.index);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            flex: 2,
            child: Center(
              child: Container(
                height: 200,
                width: 200,
                child: SvgPicture.asset(
                  slideList[index].image!,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SizedBox(height: 15),
          Flexible(
            flex: 1,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextHolder(
                  title: slideList[index].title,
                  size: 20,
                  fontWeight: FontWeight.w900,
                  align: TextAlign.center,
                ),
                SizedBox(height: 20),
                TextHolder(
                  title: slideList[index].subTitle,
                  size: 15,
                  align: TextAlign.center,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
