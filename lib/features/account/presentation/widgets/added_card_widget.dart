import 'package:careplan/core/presentation/widgets/text_holder.dart';
import 'package:careplan/core/resources/assets.dart';
import 'package:careplan/core/resources/color.dart';
import 'package:careplan/features/card/data/models/card_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

String cardTypeAsset(String cardType) {
  if (cardType == "VISA") return Assets.visa_card;
  if (cardType == "MASTERCARD") return Assets.master_card;
  if (cardType == "AMEX") return Assets.visa_card;
  return "assets/images/card_placholder.svg";
}

class AddedCardWidget extends StatelessWidget {
  final CardModel card;
  final VoidCallback? onTapSetDefault;
  final VoidCallback? onTapDelete;

  const AddedCardWidget({
    super.key,
    required this.card,
    this.onTapSetDefault,
    this.onTapDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: GestureDetector(
        onTap: card.isDefault ? null : onTapSetDefault,
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: const Color(0xFFF2F2F2),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                      cardTypeAsset(card.cardType),
                      height: 25,
                      width: 25,
                    ),
                    Column(
                      children: [
                        TextHolder(
                          title: "**** ${card.lastFourDigits}",
                          fontWeight: FontWeight.w800,
                          color: Colors.black,
                          size: 16,
                        ),
                        const Gap(6),
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: TextHolder(
                            title: "Expires ${card.expirationDate}",
                            fontWeight: FontWeight.w500,
                            size: 14,
                            color: const Color(0xFF666666),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                if (card.isDefault)
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: CarePlanColor.light_orange,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      child: TextHolder(
                        title: 'DEFAULT',
                        color: CarePlanColor.brown,
                        size: 10,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  )
                else
                  GestureDetector(
                    onTap: onTapDelete,
                    child: const Icon(Icons.delete, color: Colors.red),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
