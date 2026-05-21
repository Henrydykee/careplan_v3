import 'add_card.dart';
import 'delete_card.dart';
import 'get_cards.dart';
import 'mark_default_card.dart';

class CardUseCases {
  final GetCards getCards;
  final MarkDefaultCard markDefaultCard;
  final DeleteCard deleteCard;
  final AddCard addCard;

  CardUseCases(
    this.getCards,
    this.markDefaultCard,
    this.deleteCard,
    this.addCard,
  );
}
