type my_json_record = { id : int; message : string } [@@deriving yojson]

exception InvalidArgument of string

let input_filename = ref ""
let output_filename = ref ""

let anon_fun filename =
  match Filename.check_suffix filename ".json" with
  | true -> input_filename := filename
  | false -> raise (InvalidArgument "That's not a JSON file!")

let speclist = [ ("-o", Arg.Set_string output_filename, "Output filename") ]
let usage_msg = "Usage: <input-file> -o <output-file>"
let () = Arg.parse speclist anon_fun usage_msg

let () =
  match !output_filename with
  | "" -> output_filename := "messages.json"
  | _ -> ()

let () =
  match Filename.check_suffix !output_filename ".json" with
  | false -> raise (InvalidArgument "That's not a JSON file!")
  | true -> ()

let () =
  let oc = open_in !input_filename in
  let lines = In_channel.input_lines oc in
  match lines with
  | [] -> ()
  | _ :: t ->
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
            my_json_record_to_yojson res)
          csvrow
      in
      let rows = make_row t in

      List.iter
        (fun row ->
          Yojson.Safe.pretty_to_channel
            (open_out_gen [ Open_append; Open_creat ] 0o777 !output_filename)
            row)
        rows
