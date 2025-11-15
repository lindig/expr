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

let expression =
  C.Arg.(
    value & pos 0 string "" & info [] ~docv:"EXPR" ~doc:"Expression to evaluate")

let evaluate string =
  let env = Expr.Eval.env [ ("pi", Float.pi); ("e", Float.exp 1.0) ] in
  match Expr.Eval.string env string with
  | Expr.Eval.Float x -> Printf.printf "%f\n" x
  | Expr.Eval.Bool b -> Printf.printf "%b\n" b
  | exception Expr.Eval.Failure msg -> Printf.printf "%s\n" msg

let expr =
  let doc = "Evaluate an expression" in
  let info = C.Cmd.info "expr" ~doc ~man:help in
  C.Cmd.v info @@ C.Term.(const evaluate $ expression)

let main () = C.Cmd.eval expr
let () = if !Sys.interactive then () else main () |> exit
