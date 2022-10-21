use warp::{http::StatusCode, reject, reply::json, Reply};

use crate::{
    data::{TodoRequest, TodoResponse},
    db,
    error::Error::DBQueryError,
    DBPool, Result,
};

pub async fn health_handler(db_pool: DBPool) -> Result<impl Reply> {
    let db = db::get_db_con(&db_pool)
        .await
        .map_err(|e| reject::custom(e))?;

    db.execute("SELECT 1", &[])
        .await
        .map_err(|e| reject::custom(DBQueryError(e)))?;

    Ok(StatusCode::OK)
}

pub async fn create_todo_handler(body: TodoRequest, db_pool: DBPool) -> Result<impl Reply> {
    Ok(json(&TodoResponse::of(
        db::create_todo(&db_pool, body)
            .await
            .map_err(|e| reject::custom(e))?,
    )))
}
