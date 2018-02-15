{
  open NpmParser

  exception Error of string
}

rule token = parse
| ' '+ { WHITE }
| ['a'-'z']+ as i
    { PART (i) }
| ['0'-'9']+ as i
    { NUM (int_of_string i) }
| '.'
    { DOT }
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