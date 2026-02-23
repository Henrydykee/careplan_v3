import 'delete_card.dart';
import 'get_cards.dart';
import 'mark_default_card.dart';

class CardUseCases {
  final GetCards getCards;
  final MarkDefaultCard markDefaultCard;
  final DeleteCard deleteCard;

  CardUseCases(
    this.getCards,
    this.markDefaultCard,
    this.deleteCard,
  );
}
