
(* The type of tokens. *)

type token = 
  | TILDE
  | STAR
  | PLUS
  | PART of (string)
  | OR
  | NUM of (int)
  | LTE
  | LT
  | HYPHEN
  | GTE
  | GT
  | EOF
  | DOT
  | CARET

(* This exception is raised by the monolithic API functions. *)

exception Error

(* The monolithic API. *)

val prog: (Lexing.lexbuf -> token) -> Lexing.lexbuf -> (NpmTypes.raw)
