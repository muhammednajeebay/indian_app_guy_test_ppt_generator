import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  static const String baseUrl = 'https://api.magicslides.app/public/api';
  static const String pptFromTopicEndpoint = '/ppt_from_topic';

  static String get supabaseUrl => dotenv.env['SUPABASE_URL'] ?? '';
  static String get supabaseAnonKey => dotenv.env['SUPABASE_ANON_KEY'] ?? '';
  static String get magicSlidesAccessId =>
      dotenv.env['MAGIC_SLIDES_ACCESS_ID'] ?? '';
}
