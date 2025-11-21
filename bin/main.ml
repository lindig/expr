(* SPDX-FileCopyrightText: 2025 Christian Lindig <lindig@gmail.com>
 * SPDX-License-Identifier: Unlicense
 *)
module C = Cmdliner

let build =
  Printf.sprintf "Commit: %s Built on: %s" Build.git_revision Build.build_time

let help =
  [
    `P "These options are common to all commands."
  ; `S "MORE HELP"
  ; `P "Use `$(mname) $(i,COMMAND) --help' for help on a single command."
  ; `S "BUGS"
  ; `P "Check bug reports at https://github.com/lindig/expr/issues"
  ; `S "BUILD DETAILS"
  ; `P build
  ]

(* small example how to add expressions to Cmdliner such that we can
   accept them as arguments. *)
module CmdlinerExpr = struct
  let error fmt = Printf.ksprintf (fun msg -> Error (`Msg msg)) fmt
  let env = Expr.Eval.env [ ("pi", Float.pi); ("e", Float.exp 1.0) ]

  let of_string s =
    match Expr.Eval.string env s with
    | Expr.Eval.Float x -> Ok x
    | _ | (exception _) -> error "%S is not a float expression" s

  let to_string pp x = Format.pp_print_float pp x
  let t = C.Arg.conv (of_string, to_string)
end

let float =
  C.Arg.(
    value & pos 0 CmdlinerExpr.t 0.0
    & info [] ~docv:"EXPR" ~doc:"Numerical expression")

let emit x =
  Printf.printf "%f\n" x;
  Ok ()

let expr =
  let doc = "Evaluate an expression" in
  let info = C.Cmd.info "expr" ~doc ~man:help in
  C.Cmd.v info @@ C.Term.(const emit $ float)

let main () = C.Cmd.eval_result expr
let () = if !Sys.interactive then () else main () |> exit
