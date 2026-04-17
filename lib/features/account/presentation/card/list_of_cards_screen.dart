// ignore_for_file: must_be_immutable
import 'package:careplan/core/presentation/widgets/app_bar.dart';
import 'package:careplan/core/presentation/widgets/button.dart';
import 'package:careplan/core/presentation/widgets/loading_shimmers/list_loading_shimmers.dart';
import 'package:careplan/core/presentation/widgets/text_holder.dart';
import 'package:careplan/core/resources/assets.dart';
import 'package:careplan/core/resources/color.dart';
import 'package:careplan/features/card/data/models/card_model.dart';
import 'package:careplan/features/card/presentation/state/card_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

import 'add_card_screen.dart';

class ListOfCardsScreen extends StatefulWidget {
  const ListOfCardsScreen({super.key});

  @override
  State<ListOfCardsScreen> createState() => _ListOfCardsScreenState();
}

class _ListOfCardsScreenState extends State<ListOfCardsScreen> {
  bool _initialFetchDone = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialFetchDone) {
      _initialFetchDone = true;
      context.read<CardProvider>().fetchCards();
    }
  }

  Future<bool> _setAsDefault(BuildContext context, CardModel card) async {
    final provider = context.read<CardProvider>();
    final success = await provider.setDefaultCard(card.id);
    return success;
  }

  Future<void> _deleteCard(BuildContext context, CardModel card) async {
    final provider = context.read<CardProvider>();
    final success = await provider.deleteCard(card.id);
    if (success && context.mounted) {
      Navigator.of(context).pop();
    }
  }

  void _showDeleteCardModal(BuildContext context, CardModel card) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.credit_card_off_rounded,
                  size: 36,
                  color: Colors.red.shade700,
                ),
              ),
              const Gap(20),
              TextHolder(
                title: "Remove this card?",
                color: CarePlanColor.grey,
                size: 20,
                fontWeight: FontWeight.w700,
              ),
              const Gap(10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: CarePlanColor.light_orange,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextHolder(
                      title: "**** ${card.lastFourDigits}",
                      fontWeight: FontWeight.w800,
                      color: CarePlanColor.brown,
                      size: 16,
                    ),
                    TextHolder(
                      title: " · ${card.cardType}",
                      fontWeight: FontWeight.w500,
                      color: CarePlanColor.brown,
                      size: 14,
                    ),
                  ],
                ),
              ),
              const Gap(14),
              TextHolder(
                title:
                    "This card will be removed from your account.\nYou can add it again anytime.",
                color: CarePlanColor.grey_3,
                size: 14,
                fontWeight: FontWeight.w400,
                align: TextAlign.center,
              ),
              const Gap(24),
              Row(
                children: [
                  Expanded(
                    child: CustomButtom(
                      title: "Cancel",
                      btnColor: CarePlanColor.grey_5,
                      textColor: CarePlanColor.grey,
                      onTap: () => Navigator.of(dialogContext).pop(),
                    ),
                  ),
                  const Gap(12),
                  Expanded(
                    child: CustomButtom(
                      title: "Remove card",
                      btnColor: Colors.red.shade700,
                      textColor: Colors.white,
                      onTap: () async {
                        Navigator.of(dialogContext).pop();
                        await _deleteCard(context, card);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        showBackIcon: true,
        title: "Cards",
      ),
      body: Consumer<CardProvider>(
        builder: (context, cardProvider, _) {
          if (cardProvider.isLoading && cardProvider.cards.isEmpty) {
            return const CardsListShimmer();
          }
          if (cardProvider.hasError && cardProvider.cards.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: TextHolder(
                  title: cardProvider.errorMessage,
                  color: Colors.black,
                  align: TextAlign.center,
                ),
              ),
            );
          }
          if (cardProvider.cards.isEmpty) {
            return Center(
              child: TextHolder(
                title: "You don't have any Card",
                color: Colors.black,
              ),
            );
          }
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cardProvider.cards.length,
                  shrinkWrap: true,
                  itemBuilder: (context, i) {
                    final card = cardProvider.cards[i];
                    return _AddedCardWidget(
                      card: card,
                      onTapSetDefault: () =>
                          _showSetDefaultModal(context, card),
                      onTapDelete: () => _showDeleteCardModal(context, card),
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
                    if (context.mounted) {
                      context.read<CardProvider>().fetchCards();
                    }
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showSetDefaultModal(BuildContext context, CardModel card) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      builder: (context) {
        bool isSubmitting = false;
        String? errorText;

        return StatefulBuilder(
          builder: (sheetContext, setSheetState) {
            Future<void> onConfirm() async {
              if (isSubmitting) return;
              setSheetState(() {
                isSubmitting = true;
                errorText = null;
              });

              final success = await _setAsDefault(context, card);
              if (!mounted) return;

              if (success) {
                if (Navigator.of(sheetContext).canPop()) {
                  Navigator.of(sheetContext).pop();
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Default card updated'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                return;
              }

              final provider = context.read<CardProvider>();
              setSheetState(() {
                isSubmitting = false;
                errorText = provider.errorMessage.isNotEmpty
                    ? provider.errorMessage
                    : 'Could not update default card. Please try again.';
              });
            }

            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 20,
              ),
              child: WillPopScope(
                onWillPop: () async => !isSubmitting,
                child: SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 14, 20, 10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                          child: Container(
                            width: 42,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(99),
                            ),
                          ),
                        ),
                        const Gap(18),
                        TextHolder(
                          title: 'Set as default card?',
                          color: CarePlanColor.grey,
                          size: 18,
                          fontWeight: FontWeight.w800,
                          align: TextAlign.center,
                        ),
                        const Gap(10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: CarePlanColor.light_orange,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextHolder(
                                title: "**** ${card.lastFourDigits}",
                                fontWeight: FontWeight.w800,
                                color: CarePlanColor.brown,
                                size: 16,
                              ),
                              TextHolder(
                                title: " · ${card.cardType}",
                                fontWeight: FontWeight.w500,
                                color: CarePlanColor.brown,
                                size: 14,
                              ),
                            ],
                          ),
                        ),
                        const Gap(12),
                        TextHolder(
                          title:
                              'We’ll use this card by default for future payments.',
                          color: CarePlanColor.grey_3,
                          size: 13,
                          fontWeight: FontWeight.w400,
                          align: TextAlign.center,
                        ),
                        if (errorText != null) ...[
                          const Gap(12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TextHolder(
                              title: errorText!,
                              color: Colors.red.shade700,
                              size: 13,
                              fontWeight: FontWeight.w500,
                              align: TextAlign.center,
                            ),
                          ),
                        ],
                        const Gap(18),
                        Row(
                          children: [
                            Expanded(
                              child: CustomButtom(
                                title: "Cancel",
                                btnColor: CarePlanColor.grey_5,
                                textColor: CarePlanColor.grey,
                                onTap: isSubmitting
                                    ? null
                                    : () => Navigator.of(sheetContext).pop(),
                              ),
                            ),
                            const Gap(12),
                            Expanded(
                              child: CustomButtom(
                                title: isSubmitting ? "Setting..." : "Set default",
                                onTap: onConfirm,
                              ),
                            ),
                          ],
                        ),
                        const Gap(10),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _AddedCardWidget extends StatelessWidget {
  final CardModel card;
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

String _getCardType(String cardType) {
  if (cardType == "VISA") return Assets.visa_card;
  if (cardType == "MASTERCARD") return Assets.master_card;
  if (cardType == "AMEX") return Assets.visa_card;
  return "assets/images/card_placholder.svg";
}
