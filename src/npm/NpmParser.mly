%token <int> NUM
%token <string> PART
%token STAR
%token DOT
%token GT
%token GTE
%token LT
%token LTE
%token HYPHEN
%token OR
%token TILDE
%token CARET
%token PLUS
%token EOF

(* part 1 *)
%start <NpmTypes.raw> prog
%%
(* part 2 *)
prog:
  | EOF       { `Any }
  | v = ranges; EOF { v }
  | r = range; EOF { r }
  ;

ranges: r = range; OR; r2 = ranges { `Or(r, r2) };

range:
  | h = hyphenated { h }
  | s = simples { s };

simples:
  | s = simple; tl = simples; { `And(s, tl) }
  | s = simple { s };

hyphenated: fr = partial; HYPHEN; t = partial { `Between(fr, t) };

simple:
  | p = primitive { p }
  | p = partial { p }
  | TILDE; p = partial_tilde { `UpToMajor(p) }
  | CARET; p = partial_tilde { `UpToMinor(p) };

primitive:
  | LT; p = partial { `LessThan(p) }
  | GT; p = partial { `GreaterThan(p) }
  | LTE; p = partial { `AtMost(p) }
  | GTE; p = partial { `AtLeast(p) };

partial:
  | major = NUM; DOT; minor = NUM; DOT; patch = NUM; s = suffix
  { `Exactly(major, minor, patch, s) };
  | major = NUM; DOT; minor = NUM; DOT; STAR; s = suffix
  { `UpToMinor((major, minor, 0, s)) };
  | major = NUM; DOT; minor = NUM; s = suffix
  { `Exactly(major, minor, 0, s) }
  | major = NUM; DOT; STAR; s = suffix
  { `UpToMajor((major, 0, 0, s)) }
  | major = NUM; s = suffix
  { `Exactly(major, 0, 0, s) }
  | STAR { `Any }
  ;

partial_tilde:
  | major = NUM; DOT; minor = NUM; DOT; patch = NUM; s = suffix
  { (major, minor, patch, s) };
  | major = NUM; DOT; minor = NUM; DOT; STAR; s = suffix
  { (major, minor, 0, s) };
  | major = NUM; DOT; minor = NUM; s = suffix
  { (major, minor, 0, s) }
  | major = NUM; DOT; STAR; s = suffix
  { (major, 0, 0, s) }
  | major = NUM; s = suffix
  { (major, 0, 0, s) }
  ;

suffix:
  | HYPHEN; p = parts; PLUS; p2 = parts { Some(String.concat "."  (p @ p2)) }
  | HYPHEN; p = parts { Some(String.concat "." p) }
  | PLUS; p = parts { Some(String.concat "."  p ) }
  | p = wordParts { Some(String.concat "."  p ) }
  | { None }

parts:
  | p = part; DOT; p2 = parts { p :: p2 }
  | p = part { p :: [] };

wordParts:
  | p = PART; DOT; p2 = parts { p :: p2 }
  | p = PART { p :: [] };

part:
  | n = NUM { string_of_int(n) }
  | p = PART { p };
