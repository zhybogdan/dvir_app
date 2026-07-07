import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Typed access to values loaded from the `.env` file at startup.
///
/// The Supabase anon key is safe to ship in the client - it only works within
/// the boundaries of our Row Level Security policies. The service_role key must
/// never live here.
class Env {
  const Env._();

  static String get supabaseUrl => dotenv.get('SUPABASE_URL');
  static String get supabaseAnonKey => dotenv.get('SUPABASE_ANON_KEY');
}
