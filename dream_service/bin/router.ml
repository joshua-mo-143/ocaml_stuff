open Types_j

let hello_world _req = (Dream.respond "Hello world!")

let return_json _req = (
  let memes = [ { id = 1; message = "Hello world from Shuttle!" };
    { id = 2; message = "Hello world!" }] in
    string_of_memes { title = "My List"; memes = memes }
    |> Dream.json

)
