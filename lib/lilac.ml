(** The `read_config` symbol takes a string file path and creates a `Yaml.value`. If you just need a data structure and a few convenience functions to juggle YAML yourself, this will do the trick! (though it'd likely be much more straight forward to just install the `yaml` package and make the call to `Yaml_unix.of_file_exn Fpath.(v path)` yourself and decide where you do and don't want `option` types haha).

The `create_config` symbol is really where the scope narrows to a particular use case. It takes a `Yaml.value` (returned by `read_config`) and creates a couple data structures.

There's an example YAML file in this repo's [test/res/ directory](https://github.com/shnewto/lilac/tree/main/test/res). *)
open Base

(** Attempt to find key ~k in the yml object *)
let yaml_get ~k (yml : Yaml.value) = match yml with
  | `O assoc -> Stdlib.List.assoc_opt k assoc
  | _ -> None

(** Data structure built from parsed YAML of the shape
    url:
    user: 
    cred:
*)
type 'a target = {
    url: string option;
    user: string option;
    cred: string option;
}

(** Container for YAML types/values in YAML of the shape
    lilac-params:
    source:
        url:
        user:
        cred:
    dest:
        url:
        user:
        cred:
 *)
type 'a config = {
    source: 'a target option;
    dest: 'a target option;
}

(** See if we can get a string from the object we have. Raises like the `to_string_exn` does if we fail. *)
let try_to_string (y: Yaml.value) =
    try
        Yaml.to_string_exn y
    with
    | Invalid_argument m -> Invalid_argument m |> raise
    | e -> raise e

(** The string values pulled from the YAML definition have `\n` characters at the end, this gets rid of them. *)
let to_string_trim y =
    y |> Yaml.to_string_exn |> String.strip

(** Takes a Yaml.value and tries to find "url", "user", and "cred" objects inside. *)
let create_target yaml =  {
    url = yaml_get ~k:"url" yaml |> Option.map ~f:to_string_trim;
    user = yaml_get ~k:"user" yaml |> Option.map ~f:to_string_trim;
    cred = yaml_get ~k:"cred" yaml |> Option.map ~f:to_string_trim;
}

(** The assoc list is what you end up with the key you were looking for was in the Yaml.value. This gets the 
YAML object associated with that key. *)
let assoc_get ~k assoc =
    List.find ~f:(fun (s, _) -> String.equal s k) assoc

(** Takes a Yaml.value and tries to find a "lilac-params" object inside. *)
let target_yaml ~k (yaml: Yaml.value) =
    let values = match yaml_get ~k:"lilac-params" yaml with
    | Some value -> yaml_get ~k:k value
    | None -> None
    in
    match values with
    | Some value -> Some(create_target value)
    | None -> None

(** Takes a Yaml.value and tries to find a "source" and "dest" objects inside. *)
let create_config (yaml: Yaml.value) = {
    source = target_yaml ~k:"source" yaml;
    dest = target_yaml ~k:"dest" yaml;
}

(** Takes a file path and builds a Yaml.value *)
let read_config path =
    Yaml_unix.of_file_exn Fpath.(v path)

(** Something nice to have around. *)
let invite =
    "Come on. I'll open the wall for you."

(** Something else nice to have around. *)
let constellation = "\n\n\n         ✧\n       ✧\n                    ✧\n  ✧\n     ✧\n          ✧\n  ✧\n          ✧\n                   ✧\n           ✧\n   ✧\n                ✧\n                 ✧\n\n\n\n\n\n\n\n\n"
