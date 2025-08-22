CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE IF NOT EXISTS Users (
    username text NOT NULL PRIMARY KEY,
    email text NOT NULL UNIQUE,
    password text NOT NULL,
    bio text NULL,
    image text NULL
);

CREATE TABLE IF NOT EXISTS Follows (
    follower text NOT NULL REFERENCES Users(username) ON DELETE CASCADE ON UPDATE CASCADE,
    influencer text NOT NULL REFERENCES Users(username) ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY (follower, influencer)
);

CREATE TABLE IF NOT EXISTS Articles (
    slug text NOT NULL PRIMARY KEY,
    author text NOT NULL REFERENCES Users(username) ON DELETE CASCADE ON UPDATE CASCADE,
    title text NOT NULL,
    description text NOT NULL,
    body text NOT NULL,
    created_at TIMESTAMPTZ NOT NULL default NOW(),
    updated_at TIMESTAMPTZ NOT NULL default NOW(),
    fts_document tsvector
);

CREATE OR REPLACE FUNCTION articles_tsvector_trigger() RETURNS trigger AS $$
BEGIN
    new.fts_document :=
        setweight(to_tsvector('english', coalesce(new.title, '')), 'A') ||
        setweight(to_tsvector('english', coalesce(new.description, '')), 'B') ||
        setweight(to_tsvector('english', coalesce(new.body, '')), 'C');
    RETURN new;
END
$$ LANGUAGE plpgsql;

-- Trigger for INSERT/UPDATE
CREATE TRIGGER articles_tsvector_update
BEFORE INSERT OR UPDATE ON Articles
FOR EACH ROW EXECUTE FUNCTION articles_tsvector_trigger();

-- GIN index for full-text search
CREATE INDEX IF NOT EXISTS articles_tsvector_idx ON Articles USING GIN (fts_document);


CREATE TABLE IF NOT EXISTS ArticleTags (
    article text NOT NULL REFERENCES Articles(slug) ON DELETE CASCADE ON UPDATE CASCADE,
    tag text NOT NULL,
    PRIMARY KEY (article, tag)
);

CREATE INDEX IF NOT EXISTS tags ON ArticleTags (tag);

CREATE TABLE IF NOT EXISTS FavArticles (
    article text NOT NULL REFERENCES Articles(slug) ON DELETE CASCADE ON UPDATE CASCADE,
    username text NOT NULL REFERENCES Users(username) ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY (article, username)
);

CREATE TABLE IF NOT EXISTS Comments (
    id int PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    article text NOT NULL REFERENCES Articles(slug) ON DELETE CASCADE ON UPDATE CASCADE,
    username text NOT NULL REFERENCES Users(username) ON DELETE CASCADE ON UPDATE CASCADE,
    body text NOT NULL,
    created_at TIMESTAMPTZ NOT NULL default NOW()
);

-- SELECT * FROM Articles WHERE search_doc @@ plainto_tsquery('english', 'your search text');
-- SELECT id, title, ts_rank(fts_document, to_tsquery('english', 'quantum & computing')) AS rank
-- FROM documents
-- WHERE fts_document @@ to_tsquery('english', 'quantum & computing')
-- ORDER BY rank DESC;


-- Rank boost: last 7 days = 3x, next 30 days = 2x, else normal
-- SELECT
--     *,
--     ts_rank(fts_document, plainto_tsquery('english', $1)) *
--     CASE
--         WHEN created_at >= NOW() - INTERVAL '7 days' THEN 3
--         WHEN created_at >= NOW() - INTERVAL '30 days' THEN 2
--         ELSE 1
--     END AS boosted_rank
-- FROM Articles
-- WHERE fts_document @@ plainto_tsquery('english', $1)
-- ORDER BY boosted_rank DESC, created_at DESC;


-- SELECT
--     slug,title,description,body,
--     ts_rank(fts_document, plainto_tsquery('english', 'ethics')) *
--     CASE
--         WHEN created_at >= NOW() - INTERVAL '7 days' THEN 3
--         WHEN updated_at >= NOW() - INTERVAL '7 days' THEN 3
--         WHEN created_at >= NOW() - INTERVAL '30 days' THEN 2
--         WHEN updated_at >= NOW() - INTERVAL '30 days' THEN 2
--         ELSE 1
--     END AS boosted_rank
-- FROM Articles
-- WHERE fts_document @@ plainto_tsquery('english', 'ethics')
-- ORDER BY boosted_rank DESC, created_at DESC;


-- SELECT
--     slug,
--     ts_headline(
--         'english',
--         title,
--         plainto_tsquery('english', $3),
--         'StartSel=''<span class="bg-yellow-300">'',StopSel=</span>,MinWords=10,MaxWords=20,MaxFragments=2'
        
--     ) AS title,
--     ts_headline(
--         'english',
--         description,
--         plainto_tsquery('english', $3),
--         'StartSel=''<span class="bg-yellow-300">'',StopSel=</span>,MinWords=10,MaxWords=20,MaxFragments=2'
--     ) AS description,
--     ts_headline(
--         'english',
--         body,
--         plainto_tsquery('english', $3),
--         'StartSel=''<span class="bg-yellow-300">'',StopSel=</span>,MinWords=10,MaxWords=20,MaxFragments=2'
--     ) AS body,
--     ts_rank(fts_document, plainto_tsquery('english', $3)) *
--     CASE
--         WHEN created_at >= NOW() - INTERVAL '7 days' THEN 3
--         WHEN updated_at >= NOW() - INTERVAL '7 days' THEN 3
--         WHEN created_at >= NOW() - INTERVAL '30 days' THEN 2
--         WHEN updated_at >= NOW() - INTERVAL '30 days' THEN 2
--         ELSE 1
--     END AS boosted_rank
-- FROM Articles
-- WHERE fts_document @@ plainto_tsquery('english', $3)
-- ORDER BY boosted_rank DESC, created_at DESC
-- LIMIT $1 OFFSET $2


-- SELECT
--     count(slug)
-- FROM Articles
-- WHERE fts_document @@ plainto_tsquery('english', 'ethics')
-- ORDER BY boosted_rank DESC, created_at DESC;