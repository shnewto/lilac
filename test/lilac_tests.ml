open OUnit2
open Lilac
open Base

let ae exp got _test_ctxt =
  assert_equal exp got ~printer:(fun x -> "|" ^ x ^ "|")

let yaml =
  let y = read_config "res/config.yaml" in
  fun () ->
    y

let config = yaml () |> create_config

let none = "None"

let all_none = (none, none, none)

let or_none v =
  Option.value ~default:none v


let (source_url, source_user, source_cred) =
  match config.source with
  | Some source -> (or_none source.url, or_none source.user, or_none source.cred)
  | _ -> all_none

let (dest_url, dest_user, dest_cred) =
  match config.dest with
  | Some dest -> (or_none dest.url, or_none dest.user, or_none dest.cred)
  | _ -> all_none

let lilac_test = [
  "Invite" >:: ae "Come on. I'll open the wall for you." invite;

  "Look at the stars" >:: ae "\n\n\n         ✧\n       ✧\n                    ✧\n  ✧\n     ✧\n          ✧\n  ✧\n          ✧\n                   ✧\n           ✧\n   ✧\n                ✧\n                 ✧\n\n\n\n\n\n\n\n\n" constellation;

  "Source url was written as" >:: ae "https://ttaw.dev" source_url;
  "Source user can be found" >:: ae "lilac+source@ttaw.dev" source_user;
  "Source cred is all around us" >:: ae "${LILAC_SOURCE_CRED}" source_cred;

  "Dest url was" >:: ae "https://walkandtalk.dev" dest_url;
  "Dest user can be" >:: ae "lilac+dest@walkandtalk.dev" dest_user;
  "Just dest of cred" >:: ae "${LILAC_DEST_CRED}" dest_cred;
]

let () =
  run_test_tt_main ("Lilac tests" >::: lilac_test)