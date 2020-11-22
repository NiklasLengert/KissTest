import 'dart:io';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';

class FirebaseMLApi {
  static Future<String> recogniseText(File imageFile) async {
    if (imageFile == null) {
      return 'No selected image';
    } else {
      final visionImage = FirebaseVisionImage.fromFile(imageFile);
      final textRecognizer = FirebaseVision.instance.textRecognizer();
      try {
        final visionText = await textRecognizer.processImage(visionImage);
        await textRecognizer.close();

        final text = extractText(visionText);
        return text.isEmpty ? 'No text found in the image' : text;
      } catch (error) {
        return error.toString();
      }
    }
  }

  static extractText(VisionText visionText) {
    String text = '';

    for (TextBlock block in visionText.blocks) {
      for (TextLine line in block.lines) {
        for (TextElement word in line.elements){
          text = text + word.text + '';
        }
        text = text + '\n';
      }
    }

    String pattern = r'INGREDIENTS[\s\S]*ml';
    //String bigWords = r'(\b[A-Z0-9][A-Z0-9]+|\b[A-Z]\b)[\A-Z0-9]';

    RegExp re = new RegExp(pattern, caseSensitive: false);
    //RegExp cL = new RegExp(bigWords);

    Match match = re.firstMatch(text);
    String finale = text.substring(match.start, match.end);


    //String finale = cL.s(ingredientsListe); // aus der Ingredientsliste nur die großgeschriebenen Worte nehmen.

    text = finale;
    return text;
  }
}