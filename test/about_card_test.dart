import 'package:api_happiness/api_happiness.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter_test/flutter_test.dart';

import 'init_test_environment.dart';

void main() {
  initTestEnvironment();

  group('JsonSerializable', () {
    const cardType = CardType.picture;
    const cardId = 'fox_and_fish';

    final jsonBase = <String, dynamic>{
      'type': EnumToString.convertToString(cardType),
      'id': cardId,
      'original_size': [6144, 4608],
      'compositions': ['4to3', '16to7', '16to9'],
      'elements': [100, 50],
      'previews': ['4to3/256x192/canvas'],
    };

    test('AboutCard Full', () async {
      final jsonAboutCard = jsonBase;

      final o = AboutCard.fromJson(jsonAboutCard);
      final oJson = o.toJson();

      final oRecovered = AboutCard.fromJson(oJson);

      expect(cardType, oRecovered.type);
      expect(o.type, oRecovered.type);
      expect(cardId, oRecovered.id);
      expect(o.id, oRecovered.id);
      expect(o.originalSize, oRecovered.originalSize);
      expect(o.compositions, oRecovered.compositions);
      expect(o.elements, oRecovered.elements);
    });

    test('PictureAboutCard Full', () async {
      final jsonPictureAboutCard = jsonBase
        ..addAll(<String, dynamic>{
          'name': 'Лисичка и рыбка',
          'masterminds': ['Илона Литвин'],
          'artists': ['Полина Лебедева'],
          'animators': ['Дмитрий Родионов'],
          'thanks': <String>[]
        });

      final o = PictureAboutCard.fromJson(jsonPictureAboutCard);
      final oJson = o.toJson();

      final oRecovered = PictureAboutCard.fromJson(oJson);

      expect(o.name, oRecovered.name);
      expect(o.masterminds, oRecovered.masterminds);
      expect(o.artists, oRecovered.artists);
      expect(o.animators, oRecovered.animators);
      expect(o.thanks, oRecovered.thanks);
    });

    test('WelcomeAboutCard Full', () async {
      final jsonWelcomeAboutCard = jsonBase
        ..addAll(<String, dynamic>{
          'title1': 'Щастя',
          'title2': 'Happiness',
          'subtitle': 'просто для задоволення',
          'privacy': {
            'type': 'link',
            'text': 'Політика конфіденційності',
            'link': 'https://noisy.studio/privacy.html'
          },
          'terms': {
            'type': 'link',
            'text': 'Умови використання',
            'link': 'https://noisy.studio/terms.html'
          }
        });

      final o = WelcomeAboutCard.fromJson(jsonWelcomeAboutCard);
      final oJson = o.toJson();

      final oRecovered = WelcomeAboutCard.fromJson(oJson);

      expect(o.title1, oRecovered.title1);
      expect(o.title2, oRecovered.title2);
      expect(o.subtitle, oRecovered.subtitle);
      expect(o.privacy, oRecovered.privacy);
      expect(o.terms, oRecovered.terms);
    });

    test('LaterAboutCard Full', () async {
      final jsonLaterAboutCard = jsonBase
        ..addAll(<String, dynamic>{
          'sequence': {
            'list': [
              'its_all',
              'announce',
              'thanks',
              'about_app',
              'rate_app',
              'bottom'
            ],
            'map': {
              'its_all': {'type': 'text', 'text': "That's all ☺ for now"},
              'announce': {'type': 'text', 'text': 'Animation coming soon!'},
              'thanks': {
                'type': 'text',
                'text': 'Thank You \uD83D\uDE4F for sharing Your support'
              },
              'about_app': {
                'type': 'text',
                'text':
                    "\nWe're gathering in one App the stories\nthat show the elusive… happiness"
              },
              'rate_app': {'type': 'rate'},
              'bottom': {
                'type': 'text',
                'text':
                    'Please rate the App ❤\nIt will help other families to enjoy\nPictures of Happiness and/or keep your child occupied and\nhopefully captivated… with beauty'
              }
            }
          }
        });

      final o = LaterAboutCard.fromJson(jsonLaterAboutCard);
      final oJson = o.toJson();

      final oRecovered = LaterAboutCard.fromJson(oJson);

      expect(o.sequence, oRecovered.sequence);
    });
  });
}
