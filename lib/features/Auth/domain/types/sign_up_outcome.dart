/// What happened after a successful sign-up.
///
/// Whether a session exists depends on the "confirm email" setting in Supabase,
/// so the UI cannot assume registration means "signed in".
enum SignUpOutcome {
  /// A session was created — the router redirect takes over from here.
  signedIn,

  /// Account created, but the user must open the confirmation link first.
  confirmationRequired,
}
