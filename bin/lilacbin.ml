open Lilac
open Base

let print_workspace_values ws prefix =
  let url = Option.value ~default:"" ws.url in
  let user = Option.value ~default:"" ws.user in
  let cred = Option.value ~default:"" ws.cred in
  prefix ^ "url: " ^ url |> Stdio.print_endline;
  prefix ^ "user: " ^ user |> Stdio.print_endline;
  prefix ^ "cred: " ^ cred |> Stdio.print_endline


let print_workspace ~n ws =
  n ^ ": \n" |> Stdio.print_endline;
  print_workspace_values ws "\t"

let debug fin =
  let cf = read_config fin |> create_config in
    Option.iter cf.source ~f:( fun ws -> print_workspace ~n:"source" ws);
    Option.iter cf.dest ~f:( fun ws -> print_workspace ~n:"dest" ws)

open Cmdliner

let config =
  let doc = "Path to YAML config file. See some examples here https://github.com/shnewto/lilac/tree/main/test/res" in
  Arg.(required & opt (some string) None & info ["i"; "input"] ~doc)

let lilac_t = Term.(const debug $ config)

let info =
  let doc = constellation in
  let man = [
    `S Manpage.s_synopsis;
    `P "lilac --input <path-to-a-config.yaml>";
    `S Manpage.s_name;
    `P "lilac";
    `S Manpage.s_bugs;
    `P "Report bugs by raising an issue at https://github.com/shnewto/lilac/issues";]
  in
  Term.info "lilac" ~version:"v0.1.0~dev" ~doc ~exits:Term.default_exits ~man

let () = Term.exit @@ Term.eval (lilac_t, info)