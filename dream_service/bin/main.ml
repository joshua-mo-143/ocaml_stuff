let () =
  Dream.run
  @@ Dream.router [
    Dream.get "/"  Router.hello_world;
    Dream.get "/meme" Router.return_json
  ]
