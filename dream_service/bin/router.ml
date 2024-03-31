open Types_j

let hello_world _req = (Dream.respond "Hello world!")

let return_json _req = (
  let json = [string_of_meme { id = 1; message = "Hello world from Shuttle!" };
   string_of_meme { id = 2; message = "Hello world!" }] in
  let concatted_string = String.concat "," json in
    Printf.sprintf "[%s]" concatted_string
    |> Dream.json

)
