type exe = { id : int; message : string } [@@deriving yojson]

exception InvalidArgument of string;;

if Array.length Sys.argv < 2 then raise (InvalidArgument "Usage: <input-file>")

let input_filename = Sys.argv.(1)

let output_filename =
  if Array.length Sys.argv = 3 then Sys.argv.(2) else "meme.json"
;;

let is_equal = Filename.check_suffix input_filename ".csv" in
match is_equal with
| false -> raise (InvalidArgument "That's not a CSV file!")
| true -> ()

let () = Printf.printf "Converting %s to JSON...\n" input_filename

let () =
  let oc = open_in input_filename in
  let lines = In_channel.input_lines oc in
  let make_row csvrow =
    List.map
      (fun row ->
        let exerow = String.split_on_char ',' row in
        let res =
          {
            id = int_of_string (List.nth exerow 0);
            message = List.nth exerow 1;
          }
        in
        exe_to_yojson res)
      csvrow
  in
  let t = make_row lines in

  List.iter
    (fun row ->
      Yojson.Safe.pretty_to_channel
        (open_out_gen [ Open_append; Open_creat ] 0o777 output_filename)
        row)
    t
