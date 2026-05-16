import 'package:careplan/core/presentation/widgets/app_bar.dart';
import 'package:careplan/core/presentation/widgets/button.dart';
import 'package:careplan/core/presentation/widgets/loading_shimmers/list_loading_shimmers.dart';
import 'package:careplan/core/presentation/widgets/text_holder.dart';
import 'package:careplan/core/resources/color.dart';
import 'package:careplan/features/account/presentation/widgets/added_card_widget.dart';
import 'package:careplan/features/account/presentation/widgets/delete_card_dialog.dart';
import 'package:careplan/features/account/presentation/widgets/set_default_card_sheet.dart';
import 'package:careplan/features/card/data/models/card_model.dart';
import 'package:careplan/features/card/presentation/state/card_provider.dart';
import 'package:flutter/material.dart';
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

  Future<void> _deleteCard(CardModel card) async {
    final provider = context.read<CardProvider>();
    final success = await provider.deleteCard(card.id);
    if (success && mounted) {
      Navigator.of(context).pop();
    }
  }

  Future<void> _onRefresh() async {
    await context.read<CardProvider>().fetchCards();
  }

  void _handleSetDefault(CardModel card) {
    showSetDefaultCardSheet(
      context: context,
      card: card,
      onConfirm: () => context.read<CardProvider>().setDefaultCard(card.id),
    );
  }

  void _handleDelete(CardModel card) {
    showDeleteCardDialog(
      context: context,
      card: card,
      onConfirmDelete: () => _deleteCard(card),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        showBackIcon: true,
        title: "Cards",
      ),
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: _onRefresh,
              color: CarePlanColor.brown,
              child: Consumer<CardProvider>(
                builder: (context, cardProvider, _) {
                  if (cardProvider.isLoading && cardProvider.cards.isEmpty) {
                    return ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: const [CardsListShimmer()],
                    );
                  }
                  if (cardProvider.hasError && cardProvider.cards.isEmpty) {
                    return ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 60),
                          child: Center(
                            child: TextHolder(
                              title: cardProvider.errorMessage,
                              color: Colors.black,
                              align: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                  if (cardProvider.cards.isEmpty) {
                    return ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 80),
                          child: Center(
                            child: TextHolder(
                              title: "You don't have any Card",
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                  return ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: cardProvider.cards.length,
                    itemBuilder: (context, i) {
                      final card = cardProvider.cards[i];
                      return AddedCardWidget(
                        card: card,
                        onTapSetDefault: () => _handleSetDefault(card),
                        onTapDelete: () => _handleDelete(card),
                      );
                    },
                  );
                },
              ),
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
                if (mounted) {
                  context.read<CardProvider>().fetchCards();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
