open Base

let yaml_get ~k (yml : Yaml.value) = match yml with
  | `O assoc -> Stdlib.List.assoc_opt k assoc
  | _ -> None

type 'a workspace = {
    url: string option;
    user: string option;
    cred: string option;
}

type 'a config = {
    source: 'a workspace option;
    dest: 'a workspace option;
}

let try_to_string (y: Yaml.value) =
    try
        Yaml.to_string_exn y
    with
    | Invalid_argument m -> Invalid_argument m |> raise
    | e -> raise e

let to_string_trim y =
    y |> Yaml.to_string_exn |> String.strip

let create_workspace yaml =  {
    url = yaml_get ~k:"url" yaml |> Option.map ~f:to_string_trim;
    user = yaml_get ~k:"user" yaml |> Option.map ~f:to_string_trim;
    cred = yaml_get ~k:"cred" yaml |> Option.map ~f:to_string_trim;
}

let assoc_get ~k assoc =
    List.find ~f:(fun (s, _) -> String.equal s k) assoc


let workspace_yaml ~k (yaml: Yaml.value) =
    let values = match yaml_get ~k:"lilac-params" yaml with
    | Some value -> yaml_get ~k:k value
    | None -> None
    in
    match values with
    | Some value -> Some(create_workspace value)
    | None -> None

let create_config (yaml: Yaml.value) = {
    source = workspace_yaml ~k:"source" yaml;
    dest = workspace_yaml ~k:"dest" yaml;
}

let read_config path =
    Yaml_unix.of_file_exn Fpath.(v path)


let invite =
    "Come on. I'll open the wall for you."

let constellation = "\n\n\n         ✧\n       ✧\n                    ✧\n  ✧\n     ✧\n          ✧\n  ✧\n          ✧\n                   ✧\n           ✧\n   ✧\n                ✧\n                 ✧\n\n\n\n\n\n\n\n\n"
