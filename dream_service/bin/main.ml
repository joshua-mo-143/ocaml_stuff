let () =
  Dream.run ~interface:"0.0.0.0" ~port:(8080)
  @@ Dream.sql_pool (Sys.getenv "DATABASE_URL")
  @@ Dream.router [
    Dream.get "/"  Router.hello_world;
    Dream.get "/meme" Router.return_json;
    Dream.get "/comments" Router.return_comment_list;
    Dream.get "/comments/:id" Router.return_comment_by_id;
    Dream.delete "/comments/:id" Router.delete_comment_by_id;
    Dream.post "/comments" Router.create_comment
  ]
