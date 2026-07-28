-- ═════════════════════════════════════════════════════════════
-- 0006 — the parts a household is actually made of
--
--   `unit_type` listed units of property: house, apartment, plot, garage,
--   office. That covers what an object *is* at an address, and nothing of what
--   is inside one — so an owner keeping a record of their own house had
--   nothing to file a room, a cellar or a summer kitchen under.
--
--   The object's name is free text and always was; the type is what gives it an
--   icon and, later, a way to group and total ("every room", "the area of the
--   outbuildings"). That is why this stays an enum instead of becoming a text
--   column: four spellings of "room" cannot be grouped, counted or translated.
--   Anything unforeseen still goes under 'custom'.
--
--   Added as one statement per value because Postgres takes them that way.
-- ═════════════════════════════════════════════════════════════

-- Inside a flat.
alter type unit_type add value if not exists 'room';
alter type unit_type add value if not exists 'balcony';
alter type unit_type add value if not exists 'loggia';
alter type unit_type add value if not exists 'bathroom';
alter type unit_type add value if not exists 'corridor';
alter type unit_type add value if not exists 'storeroom';

-- On a private plot.
alter type unit_type add value if not exists 'basement';
alter type unit_type add value if not exists 'summer_kitchen';
alter type unit_type add value if not exists 'summer_house';
alter type unit_type add value if not exists 'shed';
alter type unit_type add value if not exists 'pool';
