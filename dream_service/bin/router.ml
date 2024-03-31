open Types_j

let hello_world _req = (Dream.respond "Hello world!")

let return_json _req = (
  let memes = [ { id = 1; message = "Hello world from Shuttle!" };
    { id = 2; message = "Hello world!" }] in
    string_of_meme_list { title = "My List"; page = 1; memes = memes }
    |> Dream.json
)

let return_comment_list req =
  let page = match Dream.query req "page" with
    | Some page -> int_of_string page
    | None -> 1
      in
  let offset = (page - 1) * 10 in
  let%lwt comments = Dream.sql req (Database.get_comments_all offset) in
    let it = List.map (fun row -> { id = fst row; message = snd row }) comments in
     string_of_meme_list { title = "Comment list"; page = page;  memes = it }
  |> Dream.json

let return_comment_by_id req =
  let id = int_of_string (Dream.param req "id") in
  let%lwt comment = Dream.sql req (Database.get_comments_by_id id) in
    let it = { id = fst comment; message = snd comment } in
     string_of_meme_single { title = "Comment list"; meme = it }
  |> Dream.json

let create_comment req =
  let%lwt body = Dream.body req in
  let submission = body |> meme_submission_of_string in
    let%lwt _ = Dream.sql req (Database.add_comment submission.message) in
    (Dream.respond "Comment created!")

let delete_comment_by_id req =
  let id = int_of_string (Dream.param req "id") in
    let%lwt _ = Dream.sql req (Database.delete_comment_by_id id) in
     Printf.sprintf "Comment with ID %i deleted" id
   |> Dream.respond
