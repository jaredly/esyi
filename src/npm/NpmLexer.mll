{
  open NpmParser

  exception Error of string
}

rule token = parse
(* add the semicolon as a new token *)
| ' ' { token lexbuf }
| ['0'-'9']+ as i
    { NUM (int_of_string i) }
| 'x'
    { STAR }
| 'X'
    { STAR }
| '*'
    { STAR }
| '+'
    { PLUS }
| '-'
    { HYPHEN }
| '>' '='
    { GTE }
| '>'
    { GT }
| '<' '='
    { LTE }
| '<'
    { LT }
| '~'
    { TILDE }
| '^'
    { CARET }
| eof
    { EOF }
| _
{ raise (Error (Printf.sprintf "At offset %d: unexpected character.\n" (Lexing.lexeme_start lexbuf))) }