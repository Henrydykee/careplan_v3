import 'package:careplan/core/presentation/widgets/text_holder.dart';
import 'package:careplan/core/resources/assets.dart';
import 'package:careplan/core/resources/color.dart';
import 'package:careplan/features/card/data/models/card_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

String cardTypeAsset(String cardType) {
  switch (cardType.toUpperCase()) {
    case 'VISA':
      return Assets.visa_card;
    case 'MASTERCARD':
      return Assets.master_card;
    default:
      return 'assets/images/card_placholder.svg';
  }
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
    final isDefault = card.isDefault;
    final subtitle = [
      if (card.cardName.trim().isNotEmpty) card.cardName.trim(),
      if (card.expirationDate.trim().isNotEmpty)
        'Expires ${card.expirationDate}',
    ].join('  •  ');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: isDefault ? null : onTapSetDefault,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: isDefault ? CarePlanColor.light_orange : Colors.white,
            border: Border.all(
              color: isDefault ? CarePlanColor.orange : CarePlanColor.grey_5,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  height: 44,
                  width: 44,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: CarePlanColor.grey_5),
                  ),
                  child: SvgPicture.asset(cardTypeAsset(card.cardType)),
                ),
                const Gap(12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextHolder(
                        title: "•••• ${card.lastFourDigits}",
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                        size: 16,
                      ),
                      if (subtitle.isNotEmpty) ...[
                        const Gap(4),
                        TextHolder(
                          title: subtitle,
                          fontWeight: FontWeight.w500,
                          size: 13,
                          color: CarePlanColor.grey_3,
                          maxLines: 1,
                          textOverflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                const Gap(8),
                if (isDefault)
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: CarePlanColor.orange,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      child: TextHolder(
                        title: 'DEFAULT',
                        color: Colors.white,
                        size: 10,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  )
                else
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: onTapDelete,
                    child: const Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(
                        Icons.delete_outline,
                        color: Color(0xFFE84343),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
