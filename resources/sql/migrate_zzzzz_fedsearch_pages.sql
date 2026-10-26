-- Search everything: the module's page and its navbar link.
--
-- Runs once (it is a migration), after core's navbar layout, so the link
-- lands straight in the right pin. `tools/module.php purge fedsearch` forgets it,
-- so the next `tools/install.php --schema-only` puts everything back.
-- Its link goes in the public navbar.

INSERT IGNORE INTO `page` (url_id, i18n, file_name, template, controller, hidden, comments)
VALUES ('WORDING_FEDSEARCH', 1, 'federated_search', 1, 1, 0, 0);

UPDATE `page` SET `module` = 'fedsearch'
 WHERE `module` = '' AND `file_name` = 'federated_search';

INSERT IGNORE INTO `page_closure` (ancestor, descendant)
SELECT id, id FROM `page` WHERE url_id = 'WORDING_FEDSEARCH';

INSERT IGNORE INTO `page_meta` (page_id, title, description)
SELECT id, '', '' FROM `page` WHERE url_id = 'WORDING_FEDSEARCH';

INSERT IGNORE INTO `page_robots` (page_id, `index`, follow)
SELECT id, 1, 1 FROM `page` WHERE url_id = 'WORDING_FEDSEARCH';

-- ── Navbar link ──────────────────────────────────────────────────────────────
SET @fedsearch_page := (SELECT id FROM `page` WHERE url_id = 'WORDING_FEDSEARCH' LIMIT 1);
SET @fedsearch_navbar := (SELECT id FROM `navbar` WHERE name = 'public' LIMIT 1);
-- The alphabetical pin, where every module's public link goes.
SET @fedsearch_pin := (
    SELECT id FROM `navbar_pin` WHERE navbar_id = @fedsearch_navbar AND sort_mode = 0
     ORDER BY sort_order ASC, id ASC LIMIT 1
);
SET @fedsearch_existing := (
    SELECT ni.id FROM `navbar_internal` ni
      JOIN `navbar_entry` e  ON e.id = ni.id
      JOIN `navbar_pin`   np ON np.id = e.pin_id
     WHERE ni.page_id = @fedsearch_page AND np.navbar_id = @fedsearch_navbar LIMIT 1
);
INSERT INTO `navbar_entry_ids` (id)
SELECT NULL WHERE @fedsearch_page IS NOT NULL AND @fedsearch_pin IS NOT NULL AND @fedsearch_existing IS NULL;
SET @fedsearch_nav := COALESCE(@fedsearch_existing, LAST_INSERT_ID());
INSERT IGNORE INTO `navbar_entry` (id, pin_id, internal, name, i18n, active, sort_order)
SELECT @fedsearch_nav, @fedsearch_pin, 1, 'WORDING_FEDSEARCH', 1, 1, 0
 WHERE @fedsearch_page IS NOT NULL AND @fedsearch_pin IS NOT NULL AND @fedsearch_nav IS NOT NULL;
INSERT IGNORE INTO `navbar_internal` (id, page_id)
SELECT @fedsearch_nav, @fedsearch_page
 WHERE @fedsearch_page IS NOT NULL AND @fedsearch_nav IS NOT NULL;
