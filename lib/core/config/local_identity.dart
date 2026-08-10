/// Who everything belongs to when there is no account to belong to.
///
/// A constant rather than an empty string, so that a row carrying it reads as a
/// deliberate answer. Kept out of any one feature because two of them invent the
/// same person: the home list, which has to name whose scope it is, and the
/// residents list, which has to have somebody in it.
const String localUserId = 'local';
