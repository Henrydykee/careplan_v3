import 'package:careplan/core/resources/assets.dart';

class Slide {
  final String? image;
  final String? title;
  final String? subTitle;
  final String? number;

  Slide({this.image, this.title, this.subTitle, this.number});
}

final slideList = [
  Slide(
    image: Assets.boarding_image1,
    title: "Create a care plan to manage your mental health  👍 ",
    subTitle: "Indicate your long term mental health goals as a first step to getting better.",
    number: "1"
  ),

  Slide(
    image: Assets.boarding_image2,
    title: "Book an appointment with a GP to approve your Care Plan  ✅",
    subTitle: "Call your GP if you have one, or choose a GP nearest to you.",
    number: "2"
  ),

  Slide(
    image: Assets.boarding_image3,
    title: "Schedule and see a Therapist  👩‍",
    subTitle: "See a therapist backed with a referral document from your GP.",
    number: "3"
  )
  
];
