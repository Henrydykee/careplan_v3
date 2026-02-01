// ignore_for_file: must_be_immutable
import 'package:careplan/core/presentation/widgets/app_bar.dart';
import 'package:careplan/core/presentation/widgets/button.dart';
import 'package:careplan/core/presentation/widgets/text_holder.dart';
import 'package:careplan/core/resources/assets.dart';
import 'package:careplan/core/resources/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

import 'add_card_screen.dart';

/// Mock card data for list of cards screen.
class MockCard {
  final String id;
  final String? cardType;
  final String lastFourDigits;
  final String expirationDate;
  final bool isDefault;

  MockCard({
    required this.id,
    this.cardType,
    required this.lastFourDigits,
    required this.expirationDate,
    this.isDefault = false,
  });
}

final List<MockCard> mockCards = [
  MockCard(
    id: '1',
    cardType: 'VISA',
    lastFourDigits: '4242',
    expirationDate: '12/26',
    isDefault: true,
  ),
  MockCard(
    id: '2',
    cardType: 'MASTERCARD',
    lastFourDigits: '5555',
    expirationDate: '06/27',
    isDefault: false,
  ),
];

class ListOfCardsScreen extends StatefulWidget {
  const ListOfCardsScreen({super.key});

  @override
  State<ListOfCardsScreen> createState() => _ListOfCardsScreenState();
}

class _ListOfCardsScreenState extends State<ListOfCardsScreen> {
  late List<MockCard> _cards;

  @override
  void initState() {
    super.initState();
    _cards = List.from(mockCards);
  }

  void _setAsDefault(MockCard card) {
    setState(() {
      _cards = _cards
          .map((c) => MockCard(
                id: c.id,
                cardType: c.cardType,
                lastFourDigits: c.lastFourDigits,
                expirationDate: c.expirationDate,
                isDefault: c.id == card.id,
              ))
          .toList();
    });
    Navigator.of(context).pop();
  }

  void _deleteCard(MockCard card) {
    setState(() => _cards.removeWhere((c) => c.id == card.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        showBackIcon: true,
        title: "Cards",
      ),
      body: _cards.isEmpty
          ? Center(
              child: TextHolder(
                title: "You don't have any Card",
                color: Colors.black,
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _cards.length,
                    shrinkWrap: true,
                    itemBuilder: (context, i) {
                      final card = _cards[i];
                      return _AddedCardWidget(
                        card: card,
                        onTapSetDefault: () =>
                            _showSetDefaultModal(context, card),
                        onTapDelete: () => _deleteCard(card),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: CustomButtom(
                    title: "Add Card",
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddCardScreen(),
                        ),
                      );
                      setState(() {});
                    },
                  ),
                ),
              ],
            ),
    );
  }

  void _showSetDefaultModal(BuildContext context, MockCard card) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      builder: (context) {
        return Wrap(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 25,
                    right: 25,
                    top: 20,
                    bottom: 20,
                  ),
                  child: TextHolder(
                    title: "Tap Button to set Card as default",
                    color: CarePlanColor.brown,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: CustomButtom(
                    title: "Set as Default",
                    onTap: () => _setAsDefault(card),
                  ),
                ),
                const Gap(30),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _AddedCardWidget extends StatelessWidget {
  final MockCard card;
  final VoidCallback? onTapSetDefault;
  final VoidCallback? onTapDelete;

  const _AddedCardWidget({
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
                      _getCardType(card.cardType),
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

String _getCardType(String? cardType) {
  if (cardType == "VISA") return Assets.visa_card;
  if (cardType == "MASTERCARD") return Assets.master_card;
  return "assets/images/card_placholder.svg";
}
