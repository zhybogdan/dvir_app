/// The columns of `units` the app reads, spelled out instead of `*`.
///
/// `invite_code` is deliberately missing. `0005` revoked it from
/// `authenticated`, so asking for it is now an error rather than a leak — and
/// asking for `*` would mean relying on how PostgREST reacts to a column the
/// caller may not read. The owner gets the code from `unit_invite_code()`.
///
/// Kept in one place because three queries read units — the object list, its
/// children, and the scope list on the home screen — and a column added to one
/// of them belongs in all three.
const String unitColumns =
    'id,community_id,parent_id,type,label,address,city,area_m2';
