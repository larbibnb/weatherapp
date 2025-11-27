import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class LlmService {
  final String _apiKey = dotenv.env['Gemini_Api_Key']!;

  late final GenerativeModel _model = GenerativeModel(
    model: 'gemini-2.0-flash',
    apiKey: _apiKey,
  );

  Future<String> generate(String prompt) async {
    final response = await _model.generateContent([Content.text(prompt)]);

    return response.text ?? '';
  }
}
