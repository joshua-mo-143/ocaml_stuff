module type DB = Caqti_lwt.CONNECTION
module T = Caqti_type

let get_comments_all =
  let query =
    let open Caqti_request.Infix in
    (T.int ->* T.(tup2 int string))
    "SELECT id, message FROM messages LIMIT 10 OFFSET $1" in
  fun offset (module Db : DB) ->
    let%lwt comments_or_error = Db.collect_list query offset in
    Caqti_lwt.or_fail comments_or_error

let get_comments_by_id =
  let query =
    let open Caqti_request.Infix in
    (T.int ->! T.(tup2 int string))
    "SELECT id, message FROM messages WHERE id = $1 LIMIT 1" in
  fun id (module Db : DB) ->
    let%lwt comments_or_error = Db.find query id in
    Caqti_lwt.or_fail comments_or_error

let add_comment =
  let query =
    let open Caqti_request.Infix in
    (T.string ->. T.unit)
    "INSERT INTO messages (message) VALUES ($1)" in
  fun text (module Db : DB) ->
    let%lwt unit_or_error = Db.exec query text in
    Caqti_lwt.or_fail unit_or_error

let delete_comment_by_id =
  let query =
    let open Caqti_request.Infix in
    (T.int ->. T.unit)
    "DELETE FROM messages WHERE id = $1" in
  fun id (module Db : DB) ->
    let%lwt unit_or_error = Db.exec query id in
    Caqti_lwt.or_fail unit_or_error
