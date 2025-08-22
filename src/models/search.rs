// use leptos::prelude::*;
use serde::{Deserialize, Serialize};

#[derive(Serialize, Deserialize, Clone, Default, Debug)]
pub struct MatchedArticles {
    pub slug: String,
    pub title: Option<String>,
    pub description: Option<String>,
    pub body: Option<String>,
}

impl MatchedArticles {
    #[tracing::instrument]
    #[cfg(feature = "ssr")]
    pub async fn search_articles(
        query: String,
        page: i64,
        amount: i64,
    ) -> Result<Vec<Self>, sqlx::Error> {
        let offset = page * amount;
        sqlx::query!(
            // MatchedArticles,
            r#"
        SELECT
            slug,
            ts_headline(
                'english',
                title,
                plainto_tsquery('english', $3),
                'StartSel=''<span class="bg-yellow-300">'',StopSel=</span>,MinWords=10,MaxWords=20,MaxFragments=2'

            ) AS title,
            ts_headline(
                'english',
                description,
                plainto_tsquery('english', $3),
                'StartSel=''<span class="bg-yellow-300">'',StopSel=</span>,MinWords=10,MaxWords=20,MaxFragments=2'
            ) AS description,
            ts_headline(
                'english',
                body,
                plainto_tsquery('english', $3),
                'StartSel=''<span class="bg-yellow-300">'',StopSel=</span>,MinWords=10,MaxWords=20,MaxFragments=2,FragmentDelimiter=''<span class="bg-yellow-300">...</span>'''
            ) AS body,
            ts_rank(fts_document, plainto_tsquery('english', $3)) *
            CASE
                WHEN created_at >= NOW() - INTERVAL '7 days' THEN 3
                WHEN updated_at >= NOW() - INTERVAL '7 days' THEN 3
                WHEN created_at >= NOW() - INTERVAL '30 days' THEN 2
                WHEN updated_at >= NOW() - INTERVAL '30 days' THEN 2
                ELSE 1
            END AS boosted_rank
        FROM Articles
        WHERE fts_document @@ plainto_tsquery('english', $3)
        ORDER BY boosted_rank DESC, created_at DESC
        LIMIT $1 OFFSET $2
"#,
            amount,
            offset,
            query,
        )
        .map(|x| Self {
            slug: x.slug,
            title: x.title,
            description: x.description,
            body: x.body,
        })
        .fetch_all(crate::database::get_db())
        .await
    }
}
