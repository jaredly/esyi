
module MenhirBasics = struct
  
  exception Error
  
  type token = 
    | TILDE
    | STAR
    | PLUS
    | PART of (
# 2 "lib/NpmParser.mly"
       (string)
# 14 "lib/NpmParser.ml"
  )
    | OR
    | NUM of (
# 1 "lib/NpmParser.mly"
       (int)
# 20 "lib/NpmParser.ml"
  )
    | LTE
    | LT
    | HYPHEN
    | GTE
    | GT
    | EOF
    | DOT
    | CARET
  
end

include MenhirBasics

let _eRR =
  MenhirBasics.Error

type _menhir_env = {
  _menhir_lexer: Lexing.lexbuf -> token;
  _menhir_lexbuf: Lexing.lexbuf;
  _menhir_token: token;
  mutable _menhir_error: bool
}

and _menhir_state = 
  | MenhirState66
  | MenhirState62
  | MenhirState55
  | MenhirState52
  | MenhirState49
  | MenhirState47
  | MenhirState45
  | MenhirState43
  | MenhirState39
  | MenhirState37
  | MenhirState35
  | MenhirState33
  | MenhirState31
  | MenhirState25
  | MenhirState23
  | MenhirState21
  | MenhirState18
  | MenhirState15
  | MenhirState13
  | MenhirState11
  | MenhirState8
  | MenhirState3
  | MenhirState2
  | MenhirState1
  | MenhirState0

let rec _menhir_goto_simples : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_simples -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    match _menhir_s with
    | MenhirState62 | MenhirState0 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv245) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let (_v : 'tv_simples) = _v in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv243) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let ((s : 'tv_simples) : 'tv_simples) = _v in
        ((let _v : 'tv_range = 
# 30 "lib/NpmParser.mly"
                ( s )
# 87 "lib/NpmParser.ml"
         in
        _menhir_goto_range _menhir_env _menhir_stack _menhir_s _v) : 'freshtv244)) : 'freshtv246)
    | MenhirState55 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv249 * _menhir_state * 'tv_simple) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let (_v : 'tv_simples) = _v in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv247 * _menhir_state * 'tv_simple) = Obj.magic _menhir_stack in
        let (_ : _menhir_state) = _menhir_s in
        let ((tl : 'tv_simples) : 'tv_simples) = _v in
        ((let (_menhir_stack, _menhir_s, (s : 'tv_simple)) = _menhir_stack in
        let _v : 'tv_simples = 
# 33 "lib/NpmParser.mly"
                              ( `And(s, tl) )
# 103 "lib/NpmParser.ml"
         in
        _menhir_goto_simples _menhir_env _menhir_stack _menhir_s _v) : 'freshtv248)) : 'freshtv250)
    | _ ->
        _menhir_fail ()

and _menhir_goto_parts : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_parts -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    match _menhir_s with
    | MenhirState3 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv221 * _menhir_state) * _menhir_state * 'tv_parts) = Obj.magic _menhir_stack in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv219 * _menhir_state) * _menhir_state * 'tv_parts) = Obj.magic _menhir_stack in
        ((let ((_menhir_stack, _menhir_s), _, (p : 'tv_parts)) = _menhir_stack in
        let _1 = () in
        let _v : 'tv_suffix = 
# 80 "lib/NpmParser.mly"
                    ( Some(String.concat "."  p ) )
# 123 "lib/NpmParser.ml"
         in
        _menhir_goto_suffix _menhir_env _menhir_stack _menhir_s _v) : 'freshtv220)) : 'freshtv222)
    | MenhirState8 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : (('freshtv225 * _menhir_state * 'tv_part)) * _menhir_state * 'tv_parts) = Obj.magic _menhir_stack in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : (('freshtv223 * _menhir_state * 'tv_part)) * _menhir_state * 'tv_parts) = Obj.magic _menhir_stack in
        ((let ((_menhir_stack, _menhir_s, (p : 'tv_part)), _, (p2 : 'tv_parts)) = _menhir_stack in
        let _2 = () in
        let _v : 'tv_parts = 
# 85 "lib/NpmParser.mly"
                              ( p :: p2 )
# 136 "lib/NpmParser.ml"
         in
        _menhir_goto_parts _menhir_env _menhir_stack _menhir_s _v) : 'freshtv224)) : 'freshtv226)
    | MenhirState11 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : (('freshtv229 * _menhir_state * (
# 2 "lib/NpmParser.mly"
       (string)
# 144 "lib/NpmParser.ml"
        ))) * _menhir_state * 'tv_parts) = Obj.magic _menhir_stack in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : (('freshtv227 * _menhir_state * (
# 2 "lib/NpmParser.mly"
       (string)
# 150 "lib/NpmParser.ml"
        ))) * _menhir_state * 'tv_parts) = Obj.magic _menhir_stack in
        ((let ((_menhir_stack, _menhir_s, (p : (
# 2 "lib/NpmParser.mly"
       (string)
# 155 "lib/NpmParser.ml"
        ))), _, (p2 : 'tv_parts)) = _menhir_stack in
        let _2 = () in
        let _v : 'tv_wordParts = 
# 89 "lib/NpmParser.mly"
                              ( p :: p2 )
# 161 "lib/NpmParser.ml"
         in
        _menhir_goto_wordParts _menhir_env _menhir_stack _menhir_s _v) : 'freshtv228)) : 'freshtv230)
    | MenhirState13 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv237 * _menhir_state) * _menhir_state * 'tv_parts) = Obj.magic _menhir_stack in
        ((assert (not _menhir_env._menhir_error);
        let _tok = _menhir_env._menhir_token in
        match _tok with
        | PLUS ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv231 * _menhir_state) * _menhir_state * 'tv_parts) = Obj.magic _menhir_stack in
            ((let _menhir_env = _menhir_discard _menhir_env in
            let _tok = _menhir_env._menhir_token in
            match _tok with
            | NUM _v ->
                _menhir_run5 _menhir_env (Obj.magic _menhir_stack) MenhirState15 _v
            | PART _v ->
                _menhir_run4 _menhir_env (Obj.magic _menhir_stack) MenhirState15 _v
            | _ ->
                assert (not _menhir_env._menhir_error);
                _menhir_env._menhir_error <- true;
                _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState15) : 'freshtv232)
        | CARET | EOF | GT | GTE | HYPHEN | LT | LTE | NUM _ | OR | STAR | TILDE ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv233 * _menhir_state) * _menhir_state * 'tv_parts) = Obj.magic _menhir_stack in
            ((let ((_menhir_stack, _menhir_s), _, (p : 'tv_parts)) = _menhir_stack in
            let _1 = () in
            let _v : 'tv_suffix = 
# 79 "lib/NpmParser.mly"
                      ( Some(String.concat "." p) )
# 192 "lib/NpmParser.ml"
             in
            _menhir_goto_suffix _menhir_env _menhir_stack _menhir_s _v) : 'freshtv234)
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv235 * _menhir_state) * _menhir_state * 'tv_parts) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv236)) : 'freshtv238)
    | MenhirState15 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ((('freshtv241 * _menhir_state) * _menhir_state * 'tv_parts)) * _menhir_state * 'tv_parts) = Obj.magic _menhir_stack in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ((('freshtv239 * _menhir_state) * _menhir_state * 'tv_parts)) * _menhir_state * 'tv_parts) = Obj.magic _menhir_stack in
        ((let (((_menhir_stack, _menhir_s), _, (p : 'tv_parts)), _, (p2 : 'tv_parts)) = _menhir_stack in
        let _3 = () in
        let _1 = () in
        let _v : 'tv_suffix = 
# 78 "lib/NpmParser.mly"
                                        ( Some(String.concat "."  (p @ p2)) )
# 213 "lib/NpmParser.ml"
         in
        _menhir_goto_suffix _menhir_env _menhir_stack _menhir_s _v) : 'freshtv240)) : 'freshtv242)
    | _ ->
        _menhir_fail ()

and _menhir_run62 : _menhir_env -> 'ttv_tail * _menhir_state * 'tv_range -> 'ttv_return =
  fun _menhir_env _menhir_stack ->
    let _menhir_env = _menhir_discard _menhir_env in
    let _tok = _menhir_env._menhir_token in
    match _tok with
    | CARET ->
        _menhir_run52 _menhir_env (Obj.magic _menhir_stack) MenhirState62
    | GT ->
        _menhir_run49 _menhir_env (Obj.magic _menhir_stack) MenhirState62
    | GTE ->
        _menhir_run47 _menhir_env (Obj.magic _menhir_stack) MenhirState62
    | LT ->
        _menhir_run45 _menhir_env (Obj.magic _menhir_stack) MenhirState62
    | LTE ->
        _menhir_run43 _menhir_env (Obj.magic _menhir_stack) MenhirState62
    | NUM _v ->
        _menhir_run31 _menhir_env (Obj.magic _menhir_stack) MenhirState62 _v
    | STAR ->
        _menhir_run30 _menhir_env (Obj.magic _menhir_stack) MenhirState62
    | TILDE ->
        _menhir_run1 _menhir_env (Obj.magic _menhir_stack) MenhirState62
    | _ ->
        assert (not _menhir_env._menhir_error);
        _menhir_env._menhir_error <- true;
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState62

and _menhir_goto_simple : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_simple -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv217 * _menhir_state * 'tv_simple) = Obj.magic _menhir_stack in
    ((assert (not _menhir_env._menhir_error);
    let _tok = _menhir_env._menhir_token in
    match _tok with
    | CARET ->
        _menhir_run52 _menhir_env (Obj.magic _menhir_stack) MenhirState55
    | GT ->
        _menhir_run49 _menhir_env (Obj.magic _menhir_stack) MenhirState55
    | GTE ->
        _menhir_run47 _menhir_env (Obj.magic _menhir_stack) MenhirState55
    | LT ->
        _menhir_run45 _menhir_env (Obj.magic _menhir_stack) MenhirState55
    | LTE ->
        _menhir_run43 _menhir_env (Obj.magic _menhir_stack) MenhirState55
    | NUM _v ->
        _menhir_run31 _menhir_env (Obj.magic _menhir_stack) MenhirState55 _v
    | STAR ->
        _menhir_run30 _menhir_env (Obj.magic _menhir_stack) MenhirState55
    | TILDE ->
        _menhir_run1 _menhir_env (Obj.magic _menhir_stack) MenhirState55
    | EOF | OR ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv215 * _menhir_state * 'tv_simple) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, (s : 'tv_simple)) = _menhir_stack in
        let _v : 'tv_simples = 
# 34 "lib/NpmParser.mly"
               ( s )
# 276 "lib/NpmParser.ml"
         in
        _menhir_goto_simples _menhir_env _menhir_stack _menhir_s _v) : 'freshtv216)
    | _ ->
        assert (not _menhir_env._menhir_error);
        _menhir_env._menhir_error <- true;
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState55) : 'freshtv218)

and _menhir_goto_partial_tilde : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_partial_tilde -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    match _menhir_s with
    | MenhirState1 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv209 * _menhir_state) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let (_v : 'tv_partial_tilde) = _v in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv207 * _menhir_state) = Obj.magic _menhir_stack in
        let (_ : _menhir_state) = _menhir_s in
        let ((p : 'tv_partial_tilde) : 'tv_partial_tilde) = _v in
        ((let (_menhir_stack, _menhir_s) = _menhir_stack in
        let _1 = () in
        let _v : 'tv_simple = 
# 41 "lib/NpmParser.mly"
                             ( `UpToMajor(p) )
# 301 "lib/NpmParser.ml"
         in
        _menhir_goto_simple _menhir_env _menhir_stack _menhir_s _v) : 'freshtv208)) : 'freshtv210)
    | MenhirState52 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv213 * _menhir_state) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let (_v : 'tv_partial_tilde) = _v in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv211 * _menhir_state) = Obj.magic _menhir_stack in
        let (_ : _menhir_state) = _menhir_s in
        let ((p : 'tv_partial_tilde) : 'tv_partial_tilde) = _v in
        ((let (_menhir_stack, _menhir_s) = _menhir_stack in
        let _1 = () in
        let _v : 'tv_simple = 
# 42 "lib/NpmParser.mly"
                             ( `UpToMinor(p) )
# 318 "lib/NpmParser.ml"
         in
        _menhir_goto_simple _menhir_env _menhir_stack _menhir_s _v) : 'freshtv212)) : 'freshtv214)
    | _ ->
        _menhir_fail ()

and _menhir_goto_part : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_part -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv205 * _menhir_state * 'tv_part) = Obj.magic _menhir_stack in
    ((assert (not _menhir_env._menhir_error);
    let _tok = _menhir_env._menhir_token in
    match _tok with
    | DOT ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv199 * _menhir_state * 'tv_part) = Obj.magic _menhir_stack in
        ((let _menhir_env = _menhir_discard _menhir_env in
        let _tok = _menhir_env._menhir_token in
        match _tok with
        | NUM _v ->
            _menhir_run5 _menhir_env (Obj.magic _menhir_stack) MenhirState8 _v
        | PART _v ->
            _menhir_run4 _menhir_env (Obj.magic _menhir_stack) MenhirState8 _v
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState8) : 'freshtv200)
    | CARET | EOF | GT | GTE | HYPHEN | LT | LTE | NUM _ | OR | PLUS | STAR | TILDE ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv201 * _menhir_state * 'tv_part) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, (p : 'tv_part)) = _menhir_stack in
        let _v : 'tv_parts = 
# 86 "lib/NpmParser.mly"
             ( p :: [] )
# 353 "lib/NpmParser.ml"
         in
        _menhir_goto_parts _menhir_env _menhir_stack _menhir_s _v) : 'freshtv202)
    | _ ->
        assert (not _menhir_env._menhir_error);
        _menhir_env._menhir_error <- true;
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv203 * _menhir_state * 'tv_part) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv204)) : 'freshtv206)

and _menhir_fail : unit -> 'a =
  fun () ->
    Printf.fprintf Pervasives.stderr "Internal failure -- please contact the parser generator's developers.\n%!";
    assert false

and _menhir_goto_range : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_range -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    match _menhir_s with
    | MenhirState0 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv193 * _menhir_state * 'tv_range) = Obj.magic _menhir_stack in
        ((assert (not _menhir_env._menhir_error);
        let _tok = _menhir_env._menhir_token in
        match _tok with
        | EOF ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv189 * _menhir_state * 'tv_range) = Obj.magic _menhir_stack in
            ((let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv187 * _menhir_state * 'tv_range) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _menhir_s, (r : 'tv_range)) = _menhir_stack in
            let _2 = () in
            let _v : (
# 17 "lib/NpmParser.mly"
       (NpmTypes.raw)
# 389 "lib/NpmParser.ml"
            ) = 
# 23 "lib/NpmParser.mly"
                   ( r )
# 393 "lib/NpmParser.ml"
             in
            _menhir_goto_prog _menhir_env _menhir_stack _menhir_s _v) : 'freshtv188)) : 'freshtv190)
        | OR ->
            _menhir_run62 _menhir_env (Obj.magic _menhir_stack)
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv191 * _menhir_state * 'tv_range) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv192)) : 'freshtv194)
    | MenhirState62 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv197 * _menhir_state * 'tv_range) = Obj.magic _menhir_stack in
        ((assert (not _menhir_env._menhir_error);
        let _tok = _menhir_env._menhir_token in
        match _tok with
        | OR ->
            _menhir_run62 _menhir_env (Obj.magic _menhir_stack)
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv195 * _menhir_state * 'tv_range) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv196)) : 'freshtv198)
    | _ ->
        _menhir_fail ()

and _menhir_reduce28 : _menhir_env -> 'ttv_tail * _menhir_state * 'tv_partial -> 'ttv_return =
  fun _menhir_env _menhir_stack ->
    let (_menhir_stack, _menhir_s, (p : 'tv_partial)) = _menhir_stack in
    let _v : 'tv_simple = 
# 40 "lib/NpmParser.mly"
                ( p )
# 429 "lib/NpmParser.ml"
     in
    _menhir_goto_simple _menhir_env _menhir_stack _menhir_s _v

and _menhir_goto_primitive : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_primitive -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv185) = Obj.magic _menhir_stack in
    let (_menhir_s : _menhir_state) = _menhir_s in
    let (_v : 'tv_primitive) = _v in
    ((let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv183) = Obj.magic _menhir_stack in
    let (_menhir_s : _menhir_state) = _menhir_s in
    let ((p : 'tv_primitive) : 'tv_primitive) = _v in
    ((let _v : 'tv_simple = 
# 39 "lib/NpmParser.mly"
                  ( p )
# 446 "lib/NpmParser.ml"
     in
    _menhir_goto_simple _menhir_env _menhir_stack _menhir_s _v) : 'freshtv184)) : 'freshtv186)

and _menhir_goto_suffix : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_suffix -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    match _menhir_s with
    | MenhirState18 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : (('freshtv145 * _menhir_state * (
# 1 "lib/NpmParser.mly"
       (int)
# 458 "lib/NpmParser.ml"
        )) * _menhir_state)) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let (_v : 'tv_suffix) = _v in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : (('freshtv143 * _menhir_state * (
# 1 "lib/NpmParser.mly"
       (int)
# 466 "lib/NpmParser.ml"
        )) * _menhir_state)) = Obj.magic _menhir_stack in
        let (_ : _menhir_state) = _menhir_s in
        let ((s : 'tv_suffix) : 'tv_suffix) = _v in
        ((let ((_menhir_stack, _menhir_s, (major : (
# 1 "lib/NpmParser.mly"
       (int)
# 473 "lib/NpmParser.ml"
        ))), _) = _menhir_stack in
        let _3 = () in
        let _2 = () in
        let _v : 'tv_partial_tilde = 
# 72 "lib/NpmParser.mly"
  ( (major, 0, 0, s) )
# 480 "lib/NpmParser.ml"
         in
        _menhir_goto_partial_tilde _menhir_env _menhir_stack _menhir_s _v) : 'freshtv144)) : 'freshtv146)
    | MenhirState23 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : (((('freshtv149 * _menhir_state * (
# 1 "lib/NpmParser.mly"
       (int)
# 488 "lib/NpmParser.ml"
        )) * _menhir_state) * (
# 1 "lib/NpmParser.mly"
       (int)
# 492 "lib/NpmParser.ml"
        )) * _menhir_state)) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let (_v : 'tv_suffix) = _v in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : (((('freshtv147 * _menhir_state * (
# 1 "lib/NpmParser.mly"
       (int)
# 500 "lib/NpmParser.ml"
        )) * _menhir_state) * (
# 1 "lib/NpmParser.mly"
       (int)
# 504 "lib/NpmParser.ml"
        )) * _menhir_state)) = Obj.magic _menhir_stack in
        let (_ : _menhir_state) = _menhir_s in
        let ((s : 'tv_suffix) : 'tv_suffix) = _v in
        ((let ((((_menhir_stack, _menhir_s, (major : (
# 1 "lib/NpmParser.mly"
       (int)
# 511 "lib/NpmParser.ml"
        ))), _), (minor : (
# 1 "lib/NpmParser.mly"
       (int)
# 515 "lib/NpmParser.ml"
        ))), _) = _menhir_stack in
        let _5 = () in
        let _4 = () in
        let _2 = () in
        let _v : 'tv_partial_tilde = 
# 68 "lib/NpmParser.mly"
  ( (major, minor, 0, s) )
# 523 "lib/NpmParser.ml"
         in
        _menhir_goto_partial_tilde _menhir_env _menhir_stack _menhir_s _v) : 'freshtv148)) : 'freshtv150)
    | MenhirState25 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : (((('freshtv153 * _menhir_state * (
# 1 "lib/NpmParser.mly"
       (int)
# 531 "lib/NpmParser.ml"
        )) * _menhir_state) * (
# 1 "lib/NpmParser.mly"
       (int)
# 535 "lib/NpmParser.ml"
        )) * _menhir_state) * (
# 1 "lib/NpmParser.mly"
       (int)
# 539 "lib/NpmParser.ml"
        )) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let (_v : 'tv_suffix) = _v in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : (((('freshtv151 * _menhir_state * (
# 1 "lib/NpmParser.mly"
       (int)
# 547 "lib/NpmParser.ml"
        )) * _menhir_state) * (
# 1 "lib/NpmParser.mly"
       (int)
# 551 "lib/NpmParser.ml"
        )) * _menhir_state) * (
# 1 "lib/NpmParser.mly"
       (int)
# 555 "lib/NpmParser.ml"
        )) = Obj.magic _menhir_stack in
        let (_ : _menhir_state) = _menhir_s in
        let ((s : 'tv_suffix) : 'tv_suffix) = _v in
        ((let (((((_menhir_stack, _menhir_s, (major : (
# 1 "lib/NpmParser.mly"
       (int)
# 562 "lib/NpmParser.ml"
        ))), _), (minor : (
# 1 "lib/NpmParser.mly"
       (int)
# 566 "lib/NpmParser.ml"
        ))), _), (patch : (
# 1 "lib/NpmParser.mly"
       (int)
# 570 "lib/NpmParser.ml"
        ))) = _menhir_stack in
        let _4 = () in
        let _2 = () in
        let _v : 'tv_partial_tilde = 
# 66 "lib/NpmParser.mly"
  ( (major, minor, patch, s) )
# 577 "lib/NpmParser.ml"
         in
        _menhir_goto_partial_tilde _menhir_env _menhir_stack _menhir_s _v) : 'freshtv152)) : 'freshtv154)
    | MenhirState21 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : (('freshtv157 * _menhir_state * (
# 1 "lib/NpmParser.mly"
       (int)
# 585 "lib/NpmParser.ml"
        )) * _menhir_state) * (
# 1 "lib/NpmParser.mly"
       (int)
# 589 "lib/NpmParser.ml"
        )) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let (_v : 'tv_suffix) = _v in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : (('freshtv155 * _menhir_state * (
# 1 "lib/NpmParser.mly"
       (int)
# 597 "lib/NpmParser.ml"
        )) * _menhir_state) * (
# 1 "lib/NpmParser.mly"
       (int)
# 601 "lib/NpmParser.ml"
        )) = Obj.magic _menhir_stack in
        let (_ : _menhir_state) = _menhir_s in
        let ((s : 'tv_suffix) : 'tv_suffix) = _v in
        ((let (((_menhir_stack, _menhir_s, (major : (
# 1 "lib/NpmParser.mly"
       (int)
# 608 "lib/NpmParser.ml"
        ))), _), (minor : (
# 1 "lib/NpmParser.mly"
       (int)
# 612 "lib/NpmParser.ml"
        ))) = _menhir_stack in
        let _2 = () in
        let _v : 'tv_partial_tilde = 
# 70 "lib/NpmParser.mly"
  ( (major, minor, 0, s) )
# 618 "lib/NpmParser.ml"
         in
        _menhir_goto_partial_tilde _menhir_env _menhir_stack _menhir_s _v) : 'freshtv156)) : 'freshtv158)
    | MenhirState2 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv161 * _menhir_state * (
# 1 "lib/NpmParser.mly"
       (int)
# 626 "lib/NpmParser.ml"
        )) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let (_v : 'tv_suffix) = _v in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv159 * _menhir_state * (
# 1 "lib/NpmParser.mly"
       (int)
# 634 "lib/NpmParser.ml"
        )) = Obj.magic _menhir_stack in
        let (_ : _menhir_state) = _menhir_s in
        let ((s : 'tv_suffix) : 'tv_suffix) = _v in
        ((let (_menhir_stack, _menhir_s, (major : (
# 1 "lib/NpmParser.mly"
       (int)
# 641 "lib/NpmParser.ml"
        ))) = _menhir_stack in
        let _v : 'tv_partial_tilde = 
# 74 "lib/NpmParser.mly"
  ( (major, 0, 0, s) )
# 646 "lib/NpmParser.ml"
         in
        _menhir_goto_partial_tilde _menhir_env _menhir_stack _menhir_s _v) : 'freshtv160)) : 'freshtv162)
    | MenhirState33 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : (('freshtv165 * _menhir_state * (
# 1 "lib/NpmParser.mly"
       (int)
# 654 "lib/NpmParser.ml"
        )) * _menhir_state)) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let (_v : 'tv_suffix) = _v in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : (('freshtv163 * _menhir_state * (
# 1 "lib/NpmParser.mly"
       (int)
# 662 "lib/NpmParser.ml"
        )) * _menhir_state)) = Obj.magic _menhir_stack in
        let (_ : _menhir_state) = _menhir_s in
        let ((s : 'tv_suffix) : 'tv_suffix) = _v in
        ((let ((_menhir_stack, _menhir_s, (major : (
# 1 "lib/NpmParser.mly"
       (int)
# 669 "lib/NpmParser.ml"
        ))), _) = _menhir_stack in
        let _3 = () in
        let _2 = () in
        let _v : 'tv_partial = 
# 58 "lib/NpmParser.mly"
  ( `UpToMajor((major, 0, 0, s)) )
# 676 "lib/NpmParser.ml"
         in
        _menhir_goto_partial _menhir_env _menhir_stack _menhir_s _v) : 'freshtv164)) : 'freshtv166)
    | MenhirState37 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : (((('freshtv169 * _menhir_state * (
# 1 "lib/NpmParser.mly"
       (int)
# 684 "lib/NpmParser.ml"
        )) * _menhir_state) * (
# 1 "lib/NpmParser.mly"
       (int)
# 688 "lib/NpmParser.ml"
        )) * _menhir_state)) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let (_v : 'tv_suffix) = _v in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : (((('freshtv167 * _menhir_state * (
# 1 "lib/NpmParser.mly"
       (int)
# 696 "lib/NpmParser.ml"
        )) * _menhir_state) * (
# 1 "lib/NpmParser.mly"
       (int)
# 700 "lib/NpmParser.ml"
        )) * _menhir_state)) = Obj.magic _menhir_stack in
        let (_ : _menhir_state) = _menhir_s in
        let ((s : 'tv_suffix) : 'tv_suffix) = _v in
        ((let ((((_menhir_stack, _menhir_s, (major : (
# 1 "lib/NpmParser.mly"
       (int)
# 707 "lib/NpmParser.ml"
        ))), _), (minor : (
# 1 "lib/NpmParser.mly"
       (int)
# 711 "lib/NpmParser.ml"
        ))), _) = _menhir_stack in
        let _5 = () in
        let _4 = () in
        let _2 = () in
        let _v : 'tv_partial = 
# 54 "lib/NpmParser.mly"
  ( `UpToMinor((major, minor, 0, s)) )
# 719 "lib/NpmParser.ml"
         in
        _menhir_goto_partial _menhir_env _menhir_stack _menhir_s _v) : 'freshtv168)) : 'freshtv170)
    | MenhirState39 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : (((('freshtv173 * _menhir_state * (
# 1 "lib/NpmParser.mly"
       (int)
# 727 "lib/NpmParser.ml"
        )) * _menhir_state) * (
# 1 "lib/NpmParser.mly"
       (int)
# 731 "lib/NpmParser.ml"
        )) * _menhir_state) * (
# 1 "lib/NpmParser.mly"
       (int)
# 735 "lib/NpmParser.ml"
        )) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let (_v : 'tv_suffix) = _v in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : (((('freshtv171 * _menhir_state * (
# 1 "lib/NpmParser.mly"
       (int)
# 743 "lib/NpmParser.ml"
        )) * _menhir_state) * (
# 1 "lib/NpmParser.mly"
       (int)
# 747 "lib/NpmParser.ml"
        )) * _menhir_state) * (
# 1 "lib/NpmParser.mly"
       (int)
# 751 "lib/NpmParser.ml"
        )) = Obj.magic _menhir_stack in
        let (_ : _menhir_state) = _menhir_s in
        let ((s : 'tv_suffix) : 'tv_suffix) = _v in
        ((let (((((_menhir_stack, _menhir_s, (major : (
# 1 "lib/NpmParser.mly"
       (int)
# 758 "lib/NpmParser.ml"
        ))), _), (minor : (
# 1 "lib/NpmParser.mly"
       (int)
# 762 "lib/NpmParser.ml"
        ))), _), (patch : (
# 1 "lib/NpmParser.mly"
       (int)
# 766 "lib/NpmParser.ml"
        ))) = _menhir_stack in
        let _4 = () in
        let _2 = () in
        let _v : 'tv_partial = 
# 52 "lib/NpmParser.mly"
  ( `Exactly(major, minor, patch, s) )
# 773 "lib/NpmParser.ml"
         in
        _menhir_goto_partial _menhir_env _menhir_stack _menhir_s _v) : 'freshtv172)) : 'freshtv174)
    | MenhirState35 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : (('freshtv177 * _menhir_state * (
# 1 "lib/NpmParser.mly"
       (int)
# 781 "lib/NpmParser.ml"
        )) * _menhir_state) * (
# 1 "lib/NpmParser.mly"
       (int)
# 785 "lib/NpmParser.ml"
        )) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let (_v : 'tv_suffix) = _v in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : (('freshtv175 * _menhir_state * (
# 1 "lib/NpmParser.mly"
       (int)
# 793 "lib/NpmParser.ml"
        )) * _menhir_state) * (
# 1 "lib/NpmParser.mly"
       (int)
# 797 "lib/NpmParser.ml"
        )) = Obj.magic _menhir_stack in
        let (_ : _menhir_state) = _menhir_s in
        let ((s : 'tv_suffix) : 'tv_suffix) = _v in
        ((let (((_menhir_stack, _menhir_s, (major : (
# 1 "lib/NpmParser.mly"
       (int)
# 804 "lib/NpmParser.ml"
        ))), _), (minor : (
# 1 "lib/NpmParser.mly"
       (int)
# 808 "lib/NpmParser.ml"
        ))) = _menhir_stack in
        let _2 = () in
        let _v : 'tv_partial = 
# 56 "lib/NpmParser.mly"
  ( `Exactly(major, minor, 0, s) )
# 814 "lib/NpmParser.ml"
         in
        _menhir_goto_partial _menhir_env _menhir_stack _menhir_s _v) : 'freshtv176)) : 'freshtv178)
    | MenhirState31 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv181 * _menhir_state * (
# 1 "lib/NpmParser.mly"
       (int)
# 822 "lib/NpmParser.ml"
        )) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let (_v : 'tv_suffix) = _v in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv179 * _menhir_state * (
# 1 "lib/NpmParser.mly"
       (int)
# 830 "lib/NpmParser.ml"
        )) = Obj.magic _menhir_stack in
        let (_ : _menhir_state) = _menhir_s in
        let ((s : 'tv_suffix) : 'tv_suffix) = _v in
        ((let (_menhir_stack, _menhir_s, (major : (
# 1 "lib/NpmParser.mly"
       (int)
# 837 "lib/NpmParser.ml"
        ))) = _menhir_stack in
        let _v : 'tv_partial = 
# 60 "lib/NpmParser.mly"
  ( `Exactly(major, 0, 0, s) )
# 842 "lib/NpmParser.ml"
         in
        _menhir_goto_partial _menhir_env _menhir_stack _menhir_s _v) : 'freshtv180)) : 'freshtv182)
    | _ ->
        _menhir_fail ()

and _menhir_goto_wordParts : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_wordParts -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv141) = Obj.magic _menhir_stack in
    let (_menhir_s : _menhir_state) = _menhir_s in
    let (_v : 'tv_wordParts) = _v in
    ((let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv139) = Obj.magic _menhir_stack in
    let (_menhir_s : _menhir_state) = _menhir_s in
    let ((p : 'tv_wordParts) : 'tv_wordParts) = _v in
    ((let _v : 'tv_suffix = 
# 81 "lib/NpmParser.mly"
                  ( Some(String.concat "."  p ) )
# 861 "lib/NpmParser.ml"
     in
    _menhir_goto_suffix _menhir_env _menhir_stack _menhir_s _v) : 'freshtv140)) : 'freshtv142)

and _menhir_run4 : _menhir_env -> 'ttv_tail -> _menhir_state -> (
# 2 "lib/NpmParser.mly"
       (string)
# 868 "lib/NpmParser.ml"
) -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_env = _menhir_discard _menhir_env in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv137) = Obj.magic _menhir_stack in
    let (_menhir_s : _menhir_state) = _menhir_s in
    let ((p : (
# 2 "lib/NpmParser.mly"
       (string)
# 878 "lib/NpmParser.ml"
    )) : (
# 2 "lib/NpmParser.mly"
       (string)
# 882 "lib/NpmParser.ml"
    )) = _v in
    ((let _v : 'tv_part = 
# 94 "lib/NpmParser.mly"
             ( p )
# 887 "lib/NpmParser.ml"
     in
    _menhir_goto_part _menhir_env _menhir_stack _menhir_s _v) : 'freshtv138)

and _menhir_run5 : _menhir_env -> 'ttv_tail -> _menhir_state -> (
# 1 "lib/NpmParser.mly"
       (int)
# 894 "lib/NpmParser.ml"
) -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_env = _menhir_discard _menhir_env in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv135) = Obj.magic _menhir_stack in
    let (_menhir_s : _menhir_state) = _menhir_s in
    let ((n : (
# 1 "lib/NpmParser.mly"
       (int)
# 904 "lib/NpmParser.ml"
    )) : (
# 1 "lib/NpmParser.mly"
       (int)
# 908 "lib/NpmParser.ml"
    )) = _v in
    ((let _v : 'tv_part = 
# 93 "lib/NpmParser.mly"
            ( string_of_int(n) )
# 913 "lib/NpmParser.ml"
     in
    _menhir_goto_part _menhir_env _menhir_stack _menhir_s _v) : 'freshtv136)

and _menhir_goto_partial : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_partial -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    match _menhir_s with
    | MenhirState43 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv103 * _menhir_state) * _menhir_state * 'tv_partial) = Obj.magic _menhir_stack in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv101 * _menhir_state) * _menhir_state * 'tv_partial) = Obj.magic _menhir_stack in
        ((let ((_menhir_stack, _menhir_s), _, (p : 'tv_partial)) = _menhir_stack in
        let _1 = () in
        let _v : 'tv_primitive = 
# 47 "lib/NpmParser.mly"
                     ( `AtMost(p) )
# 931 "lib/NpmParser.ml"
         in
        _menhir_goto_primitive _menhir_env _menhir_stack _menhir_s _v) : 'freshtv102)) : 'freshtv104)
    | MenhirState45 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv107 * _menhir_state) * _menhir_state * 'tv_partial) = Obj.magic _menhir_stack in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv105 * _menhir_state) * _menhir_state * 'tv_partial) = Obj.magic _menhir_stack in
        ((let ((_menhir_stack, _menhir_s), _, (p : 'tv_partial)) = _menhir_stack in
        let _1 = () in
        let _v : 'tv_primitive = 
# 45 "lib/NpmParser.mly"
                    ( `LessThan(p) )
# 944 "lib/NpmParser.ml"
         in
        _menhir_goto_primitive _menhir_env _menhir_stack _menhir_s _v) : 'freshtv106)) : 'freshtv108)
    | MenhirState47 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv111 * _menhir_state) * _menhir_state * 'tv_partial) = Obj.magic _menhir_stack in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv109 * _menhir_state) * _menhir_state * 'tv_partial) = Obj.magic _menhir_stack in
        ((let ((_menhir_stack, _menhir_s), _, (p : 'tv_partial)) = _menhir_stack in
        let _1 = () in
        let _v : 'tv_primitive = 
# 48 "lib/NpmParser.mly"
                     ( `AtLeast(p) )
# 957 "lib/NpmParser.ml"
         in
        _menhir_goto_primitive _menhir_env _menhir_stack _menhir_s _v) : 'freshtv110)) : 'freshtv112)
    | MenhirState49 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv115 * _menhir_state) * _menhir_state * 'tv_partial) = Obj.magic _menhir_stack in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv113 * _menhir_state) * _menhir_state * 'tv_partial) = Obj.magic _menhir_stack in
        ((let ((_menhir_stack, _menhir_s), _, (p : 'tv_partial)) = _menhir_stack in
        let _1 = () in
        let _v : 'tv_primitive = 
# 46 "lib/NpmParser.mly"
                    ( `GreaterThan(p) )
# 970 "lib/NpmParser.ml"
         in
        _menhir_goto_primitive _menhir_env _menhir_stack _menhir_s _v) : 'freshtv114)) : 'freshtv116)
    | MenhirState55 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv117 * _menhir_state * 'tv_partial) = Obj.magic _menhir_stack in
        (_menhir_reduce28 _menhir_env (Obj.magic _menhir_stack) : 'freshtv118)
    | MenhirState0 | MenhirState62 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv123 * _menhir_state * 'tv_partial) = Obj.magic _menhir_stack in
        ((assert (not _menhir_env._menhir_error);
        let _tok = _menhir_env._menhir_token in
        match _tok with
        | HYPHEN ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv119 * _menhir_state * 'tv_partial) = Obj.magic _menhir_stack in
            ((let _menhir_env = _menhir_discard _menhir_env in
            let _tok = _menhir_env._menhir_token in
            match _tok with
            | NUM _v ->
                _menhir_run31 _menhir_env (Obj.magic _menhir_stack) MenhirState66 _v
            | STAR ->
                _menhir_run30 _menhir_env (Obj.magic _menhir_stack) MenhirState66
            | _ ->
                assert (not _menhir_env._menhir_error);
                _menhir_env._menhir_error <- true;
                _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState66) : 'freshtv120)
        | CARET | EOF | GT | GTE | LT | LTE | NUM _ | OR | STAR | TILDE ->
            _menhir_reduce28 _menhir_env (Obj.magic _menhir_stack)
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv121 * _menhir_state * 'tv_partial) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv122)) : 'freshtv124)
    | MenhirState66 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : (('freshtv133 * _menhir_state * 'tv_partial)) * _menhir_state * 'tv_partial) = Obj.magic _menhir_stack in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : (('freshtv131 * _menhir_state * 'tv_partial)) * _menhir_state * 'tv_partial) = Obj.magic _menhir_stack in
        ((let ((_menhir_stack, _menhir_s, (fr : 'tv_partial)), _, (t : 'tv_partial)) = _menhir_stack in
        let _2 = () in
        let _v : 'tv_hyphenated = 
# 36 "lib/NpmParser.mly"
                                              ( `Between(fr, t) )
# 1016 "lib/NpmParser.ml"
         in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv129) = _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let (_v : 'tv_hyphenated) = _v in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv127) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let (_v : 'tv_hyphenated) = _v in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv125) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let ((h : 'tv_hyphenated) : 'tv_hyphenated) = _v in
        ((let _v : 'tv_range = 
# 29 "lib/NpmParser.mly"
                   ( h )
# 1033 "lib/NpmParser.ml"
         in
        _menhir_goto_range _menhir_env _menhir_stack _menhir_s _v) : 'freshtv126)) : 'freshtv128)) : 'freshtv130)) : 'freshtv132)) : 'freshtv134)
    | _ ->
        _menhir_fail ()

and _menhir_reduce37 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _v : 'tv_suffix = 
# 82 "lib/NpmParser.mly"
    ( None )
# 1044 "lib/NpmParser.ml"
     in
    _menhir_goto_suffix _menhir_env _menhir_stack _menhir_s _v

and _menhir_run3 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _menhir_stack = (_menhir_stack, _menhir_s) in
    let _menhir_env = _menhir_discard _menhir_env in
    let _tok = _menhir_env._menhir_token in
    match _tok with
    | NUM _v ->
        _menhir_run5 _menhir_env (Obj.magic _menhir_stack) MenhirState3 _v
    | PART _v ->
        _menhir_run4 _menhir_env (Obj.magic _menhir_stack) MenhirState3 _v
    | _ ->
        assert (not _menhir_env._menhir_error);
        _menhir_env._menhir_error <- true;
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState3

and _menhir_run10 : _menhir_env -> 'ttv_tail -> _menhir_state -> (
# 2 "lib/NpmParser.mly"
       (string)
# 1066 "lib/NpmParser.ml"
) -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    let _menhir_env = _menhir_discard _menhir_env in
    let _tok = _menhir_env._menhir_token in
    match _tok with
    | DOT ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv95 * _menhir_state * (
# 2 "lib/NpmParser.mly"
       (string)
# 1078 "lib/NpmParser.ml"
        )) = Obj.magic _menhir_stack in
        ((let _menhir_env = _menhir_discard _menhir_env in
        let _tok = _menhir_env._menhir_token in
        match _tok with
        | NUM _v ->
            _menhir_run5 _menhir_env (Obj.magic _menhir_stack) MenhirState11 _v
        | PART _v ->
            _menhir_run4 _menhir_env (Obj.magic _menhir_stack) MenhirState11 _v
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState11) : 'freshtv96)
    | CARET | EOF | GT | GTE | HYPHEN | LT | LTE | NUM _ | OR | STAR | TILDE ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv97 * _menhir_state * (
# 2 "lib/NpmParser.mly"
       (string)
# 1096 "lib/NpmParser.ml"
        )) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, (p : (
# 2 "lib/NpmParser.mly"
       (string)
# 1101 "lib/NpmParser.ml"
        ))) = _menhir_stack in
        let _v : 'tv_wordParts = 
# 90 "lib/NpmParser.mly"
             ( p :: [] )
# 1106 "lib/NpmParser.ml"
         in
        _menhir_goto_wordParts _menhir_env _menhir_stack _menhir_s _v) : 'freshtv98)
    | _ ->
        assert (not _menhir_env._menhir_error);
        _menhir_env._menhir_error <- true;
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv99 * _menhir_state * (
# 2 "lib/NpmParser.mly"
       (string)
# 1116 "lib/NpmParser.ml"
        )) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv100)

and _menhir_run13 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _menhir_stack = (_menhir_stack, _menhir_s) in
    let _menhir_env = _menhir_discard _menhir_env in
    let _tok = _menhir_env._menhir_token in
    match _tok with
    | NUM _v ->
        _menhir_run5 _menhir_env (Obj.magic _menhir_stack) MenhirState13 _v
    | PART _v ->
        _menhir_run4 _menhir_env (Obj.magic _menhir_stack) MenhirState13 _v
    | _ ->
        assert (not _menhir_env._menhir_error);
        _menhir_env._menhir_error <- true;
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState13

and _menhir_run2 : _menhir_env -> 'ttv_tail -> _menhir_state -> (
# 1 "lib/NpmParser.mly"
       (int)
# 1139 "lib/NpmParser.ml"
) -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    let _menhir_env = _menhir_discard _menhir_env in
    let _tok = _menhir_env._menhir_token in
    match _tok with
    | DOT ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv93 * _menhir_state * (
# 1 "lib/NpmParser.mly"
       (int)
# 1151 "lib/NpmParser.ml"
        )) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = MenhirState2 in
        ((let _menhir_stack = (_menhir_stack, _menhir_s) in
        let _menhir_env = _menhir_discard _menhir_env in
        let _tok = _menhir_env._menhir_token in
        match _tok with
        | NUM _v ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv87 * _menhir_state * (
# 1 "lib/NpmParser.mly"
       (int)
# 1163 "lib/NpmParser.ml"
            )) * _menhir_state) = Obj.magic _menhir_stack in
            let (_v : (
# 1 "lib/NpmParser.mly"
       (int)
# 1168 "lib/NpmParser.ml"
            )) = _v in
            ((let _menhir_stack = (_menhir_stack, _v) in
            let _menhir_env = _menhir_discard _menhir_env in
            let _tok = _menhir_env._menhir_token in
            match _tok with
            | DOT ->
                let (_menhir_env : _menhir_env) = _menhir_env in
                let (_menhir_stack : (('freshtv85 * _menhir_state * (
# 1 "lib/NpmParser.mly"
       (int)
# 1179 "lib/NpmParser.ml"
                )) * _menhir_state) * (
# 1 "lib/NpmParser.mly"
       (int)
# 1183 "lib/NpmParser.ml"
                )) = Obj.magic _menhir_stack in
                let (_menhir_s : _menhir_state) = MenhirState21 in
                ((let _menhir_stack = (_menhir_stack, _menhir_s) in
                let _menhir_env = _menhir_discard _menhir_env in
                let _tok = _menhir_env._menhir_token in
                match _tok with
                | NUM _v ->
                    let (_menhir_env : _menhir_env) = _menhir_env in
                    let (_menhir_stack : ((('freshtv79 * _menhir_state * (
# 1 "lib/NpmParser.mly"
       (int)
# 1195 "lib/NpmParser.ml"
                    )) * _menhir_state) * (
# 1 "lib/NpmParser.mly"
       (int)
# 1199 "lib/NpmParser.ml"
                    )) * _menhir_state) = Obj.magic _menhir_stack in
                    let (_v : (
# 1 "lib/NpmParser.mly"
       (int)
# 1204 "lib/NpmParser.ml"
                    )) = _v in
                    ((let _menhir_stack = (_menhir_stack, _v) in
                    let _menhir_env = _menhir_discard _menhir_env in
                    let _tok = _menhir_env._menhir_token in
                    match _tok with
                    | HYPHEN ->
                        _menhir_run13 _menhir_env (Obj.magic _menhir_stack) MenhirState25
                    | PART _v ->
                        _menhir_run10 _menhir_env (Obj.magic _menhir_stack) MenhirState25 _v
                    | PLUS ->
                        _menhir_run3 _menhir_env (Obj.magic _menhir_stack) MenhirState25
                    | CARET | EOF | GT | GTE | LT | LTE | NUM _ | OR | STAR | TILDE ->
                        _menhir_reduce37 _menhir_env (Obj.magic _menhir_stack) MenhirState25
                    | _ ->
                        assert (not _menhir_env._menhir_error);
                        _menhir_env._menhir_error <- true;
                        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState25) : 'freshtv80)
                | STAR ->
                    let (_menhir_env : _menhir_env) = _menhir_env in
                    let (_menhir_stack : ((('freshtv81 * _menhir_state * (
# 1 "lib/NpmParser.mly"
       (int)
# 1227 "lib/NpmParser.ml"
                    )) * _menhir_state) * (
# 1 "lib/NpmParser.mly"
       (int)
# 1231 "lib/NpmParser.ml"
                    )) * _menhir_state) = Obj.magic _menhir_stack in
                    ((let _menhir_env = _menhir_discard _menhir_env in
                    let _tok = _menhir_env._menhir_token in
                    match _tok with
                    | HYPHEN ->
                        _menhir_run13 _menhir_env (Obj.magic _menhir_stack) MenhirState23
                    | PART _v ->
                        _menhir_run10 _menhir_env (Obj.magic _menhir_stack) MenhirState23 _v
                    | PLUS ->
                        _menhir_run3 _menhir_env (Obj.magic _menhir_stack) MenhirState23
                    | CARET | EOF | GT | GTE | LT | LTE | NUM _ | OR | STAR | TILDE ->
                        _menhir_reduce37 _menhir_env (Obj.magic _menhir_stack) MenhirState23
                    | _ ->
                        assert (not _menhir_env._menhir_error);
                        _menhir_env._menhir_error <- true;
                        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState23) : 'freshtv82)
                | _ ->
                    assert (not _menhir_env._menhir_error);
                    _menhir_env._menhir_error <- true;
                    let (_menhir_env : _menhir_env) = _menhir_env in
                    let (_menhir_stack : ((('freshtv83 * _menhir_state * (
# 1 "lib/NpmParser.mly"
       (int)
# 1255 "lib/NpmParser.ml"
                    )) * _menhir_state) * (
# 1 "lib/NpmParser.mly"
       (int)
# 1259 "lib/NpmParser.ml"
                    )) * _menhir_state) = Obj.magic _menhir_stack in
                    ((let (_menhir_stack, _menhir_s) = _menhir_stack in
                    _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv84)) : 'freshtv86)
            | HYPHEN ->
                _menhir_run13 _menhir_env (Obj.magic _menhir_stack) MenhirState21
            | PART _v ->
                _menhir_run10 _menhir_env (Obj.magic _menhir_stack) MenhirState21 _v
            | PLUS ->
                _menhir_run3 _menhir_env (Obj.magic _menhir_stack) MenhirState21
            | CARET | EOF | GT | GTE | LT | LTE | NUM _ | OR | STAR | TILDE ->
                _menhir_reduce37 _menhir_env (Obj.magic _menhir_stack) MenhirState21) : 'freshtv88)
        | STAR ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv89 * _menhir_state * (
# 1 "lib/NpmParser.mly"
       (int)
# 1276 "lib/NpmParser.ml"
            )) * _menhir_state) = Obj.magic _menhir_stack in
            ((let _menhir_env = _menhir_discard _menhir_env in
            let _tok = _menhir_env._menhir_token in
            match _tok with
            | HYPHEN ->
                _menhir_run13 _menhir_env (Obj.magic _menhir_stack) MenhirState18
            | PART _v ->
                _menhir_run10 _menhir_env (Obj.magic _menhir_stack) MenhirState18 _v
            | PLUS ->
                _menhir_run3 _menhir_env (Obj.magic _menhir_stack) MenhirState18
            | CARET | EOF | GT | GTE | LT | LTE | NUM _ | OR | STAR | TILDE ->
                _menhir_reduce37 _menhir_env (Obj.magic _menhir_stack) MenhirState18
            | _ ->
                assert (not _menhir_env._menhir_error);
                _menhir_env._menhir_error <- true;
                _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState18) : 'freshtv90)
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv91 * _menhir_state * (
# 1 "lib/NpmParser.mly"
       (int)
# 1300 "lib/NpmParser.ml"
            )) * _menhir_state) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _menhir_s) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv92)) : 'freshtv94)
    | HYPHEN ->
        _menhir_run13 _menhir_env (Obj.magic _menhir_stack) MenhirState2
    | PART _v ->
        _menhir_run10 _menhir_env (Obj.magic _menhir_stack) MenhirState2 _v
    | PLUS ->
        _menhir_run3 _menhir_env (Obj.magic _menhir_stack) MenhirState2
    | CARET | EOF | GT | GTE | LT | LTE | NUM _ | OR | STAR | TILDE ->
        _menhir_reduce37 _menhir_env (Obj.magic _menhir_stack) MenhirState2

and _menhir_errorcase : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    match _menhir_s with
    | MenhirState66 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv29 * _menhir_state * 'tv_partial)) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv30)
    | MenhirState62 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv31 * _menhir_state * 'tv_range)) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv32)
    | MenhirState55 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv33 * _menhir_state * 'tv_simple) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv34)
    | MenhirState52 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv35 * _menhir_state) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv36)
    | MenhirState49 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv37 * _menhir_state) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv38)
    | MenhirState47 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv39 * _menhir_state) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv40)
    | MenhirState45 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv41 * _menhir_state) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv42)
    | MenhirState43 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv43 * _menhir_state) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv44)
    | MenhirState39 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : (((('freshtv45 * _menhir_state * (
# 1 "lib/NpmParser.mly"
       (int)
# 1361 "lib/NpmParser.ml"
        )) * _menhir_state) * (
# 1 "lib/NpmParser.mly"
       (int)
# 1365 "lib/NpmParser.ml"
        )) * _menhir_state) * (
# 1 "lib/NpmParser.mly"
       (int)
# 1369 "lib/NpmParser.ml"
        )) = Obj.magic _menhir_stack in
        ((let ((_menhir_stack, _menhir_s), _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv46)
    | MenhirState37 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : (((('freshtv47 * _menhir_state * (
# 1 "lib/NpmParser.mly"
       (int)
# 1378 "lib/NpmParser.ml"
        )) * _menhir_state) * (
# 1 "lib/NpmParser.mly"
       (int)
# 1382 "lib/NpmParser.ml"
        )) * _menhir_state)) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv48)
    | MenhirState35 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : (('freshtv49 * _menhir_state * (
# 1 "lib/NpmParser.mly"
       (int)
# 1391 "lib/NpmParser.ml"
        )) * _menhir_state) * (
# 1 "lib/NpmParser.mly"
       (int)
# 1395 "lib/NpmParser.ml"
        )) = Obj.magic _menhir_stack in
        ((let ((_menhir_stack, _menhir_s), _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv50)
    | MenhirState33 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : (('freshtv51 * _menhir_state * (
# 1 "lib/NpmParser.mly"
       (int)
# 1404 "lib/NpmParser.ml"
        )) * _menhir_state)) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv52)
    | MenhirState31 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv53 * _menhir_state * (
# 1 "lib/NpmParser.mly"
       (int)
# 1413 "lib/NpmParser.ml"
        )) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv54)
    | MenhirState25 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : (((('freshtv55 * _menhir_state * (
# 1 "lib/NpmParser.mly"
       (int)
# 1422 "lib/NpmParser.ml"
        )) * _menhir_state) * (
# 1 "lib/NpmParser.mly"
       (int)
# 1426 "lib/NpmParser.ml"
        )) * _menhir_state) * (
# 1 "lib/NpmParser.mly"
       (int)
# 1430 "lib/NpmParser.ml"
        )) = Obj.magic _menhir_stack in
        ((let ((_menhir_stack, _menhir_s), _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv56)
    | MenhirState23 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : (((('freshtv57 * _menhir_state * (
# 1 "lib/NpmParser.mly"
       (int)
# 1439 "lib/NpmParser.ml"
        )) * _menhir_state) * (
# 1 "lib/NpmParser.mly"
       (int)
# 1443 "lib/NpmParser.ml"
        )) * _menhir_state)) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv58)
    | MenhirState21 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : (('freshtv59 * _menhir_state * (
# 1 "lib/NpmParser.mly"
       (int)
# 1452 "lib/NpmParser.ml"
        )) * _menhir_state) * (
# 1 "lib/NpmParser.mly"
       (int)
# 1456 "lib/NpmParser.ml"
        )) = Obj.magic _menhir_stack in
        ((let ((_menhir_stack, _menhir_s), _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv60)
    | MenhirState18 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : (('freshtv61 * _menhir_state * (
# 1 "lib/NpmParser.mly"
       (int)
# 1465 "lib/NpmParser.ml"
        )) * _menhir_state)) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv62)
    | MenhirState15 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : (('freshtv63 * _menhir_state) * _menhir_state * 'tv_parts)) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv64)
    | MenhirState13 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv65 * _menhir_state) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv66)
    | MenhirState11 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv67 * _menhir_state * (
# 2 "lib/NpmParser.mly"
       (string)
# 1484 "lib/NpmParser.ml"
        ))) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv68)
    | MenhirState8 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv69 * _menhir_state * 'tv_part)) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv70)
    | MenhirState3 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv71 * _menhir_state) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv72)
    | MenhirState2 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv73 * _menhir_state * (
# 1 "lib/NpmParser.mly"
       (int)
# 1503 "lib/NpmParser.ml"
        )) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv74)
    | MenhirState1 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv75 * _menhir_state) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv76)
    | MenhirState0 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv77) = Obj.magic _menhir_stack in
        (raise _eRR : 'freshtv78)

and _menhir_run1 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _menhir_stack = (_menhir_stack, _menhir_s) in
    let _menhir_env = _menhir_discard _menhir_env in
    let _tok = _menhir_env._menhir_token in
    match _tok with
    | NUM _v ->
        _menhir_run2 _menhir_env (Obj.magic _menhir_stack) MenhirState1 _v
    | _ ->
        assert (not _menhir_env._menhir_error);
        _menhir_env._menhir_error <- true;
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState1

and _menhir_run30 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _menhir_env = _menhir_discard _menhir_env in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv27) = Obj.magic _menhir_stack in
    let (_menhir_s : _menhir_state) = _menhir_s in
    ((let _1 = () in
    let _v : 'tv_partial = 
# 61 "lib/NpmParser.mly"
         ( `Any )
# 1540 "lib/NpmParser.ml"
     in
    _menhir_goto_partial _menhir_env _menhir_stack _menhir_s _v) : 'freshtv28)

and _menhir_run31 : _menhir_env -> 'ttv_tail -> _menhir_state -> (
# 1 "lib/NpmParser.mly"
       (int)
# 1547 "lib/NpmParser.ml"
) -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    let _menhir_env = _menhir_discard _menhir_env in
    let _tok = _menhir_env._menhir_token in
    match _tok with
    | DOT ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv25 * _menhir_state * (
# 1 "lib/NpmParser.mly"
       (int)
# 1559 "lib/NpmParser.ml"
        )) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = MenhirState31 in
        ((let _menhir_stack = (_menhir_stack, _menhir_s) in
        let _menhir_env = _menhir_discard _menhir_env in
        let _tok = _menhir_env._menhir_token in
        match _tok with
        | NUM _v ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv19 * _menhir_state * (
# 1 "lib/NpmParser.mly"
       (int)
# 1571 "lib/NpmParser.ml"
            )) * _menhir_state) = Obj.magic _menhir_stack in
            let (_v : (
# 1 "lib/NpmParser.mly"
       (int)
# 1576 "lib/NpmParser.ml"
            )) = _v in
            ((let _menhir_stack = (_menhir_stack, _v) in
            let _menhir_env = _menhir_discard _menhir_env in
            let _tok = _menhir_env._menhir_token in
            match _tok with
            | DOT ->
                let (_menhir_env : _menhir_env) = _menhir_env in
                let (_menhir_stack : (('freshtv17 * _menhir_state * (
# 1 "lib/NpmParser.mly"
       (int)
# 1587 "lib/NpmParser.ml"
                )) * _menhir_state) * (
# 1 "lib/NpmParser.mly"
       (int)
# 1591 "lib/NpmParser.ml"
                )) = Obj.magic _menhir_stack in
                let (_menhir_s : _menhir_state) = MenhirState35 in
                ((let _menhir_stack = (_menhir_stack, _menhir_s) in
                let _menhir_env = _menhir_discard _menhir_env in
                let _tok = _menhir_env._menhir_token in
                match _tok with
                | NUM _v ->
                    let (_menhir_env : _menhir_env) = _menhir_env in
                    let (_menhir_stack : ((('freshtv11 * _menhir_state * (
# 1 "lib/NpmParser.mly"
       (int)
# 1603 "lib/NpmParser.ml"
                    )) * _menhir_state) * (
# 1 "lib/NpmParser.mly"
       (int)
# 1607 "lib/NpmParser.ml"
                    )) * _menhir_state) = Obj.magic _menhir_stack in
                    let (_v : (
# 1 "lib/NpmParser.mly"
       (int)
# 1612 "lib/NpmParser.ml"
                    )) = _v in
                    ((let _menhir_stack = (_menhir_stack, _v) in
                    let _menhir_env = _menhir_discard _menhir_env in
                    let _tok = _menhir_env._menhir_token in
                    match _tok with
                    | HYPHEN ->
                        _menhir_run13 _menhir_env (Obj.magic _menhir_stack) MenhirState39
                    | PART _v ->
                        _menhir_run10 _menhir_env (Obj.magic _menhir_stack) MenhirState39 _v
                    | PLUS ->
                        _menhir_run3 _menhir_env (Obj.magic _menhir_stack) MenhirState39
                    | CARET | EOF | GT | GTE | LT | LTE | NUM _ | OR | STAR | TILDE ->
                        _menhir_reduce37 _menhir_env (Obj.magic _menhir_stack) MenhirState39
                    | _ ->
                        assert (not _menhir_env._menhir_error);
                        _menhir_env._menhir_error <- true;
                        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState39) : 'freshtv12)
                | STAR ->
                    let (_menhir_env : _menhir_env) = _menhir_env in
                    let (_menhir_stack : ((('freshtv13 * _menhir_state * (
# 1 "lib/NpmParser.mly"
       (int)
# 1635 "lib/NpmParser.ml"
                    )) * _menhir_state) * (
# 1 "lib/NpmParser.mly"
       (int)
# 1639 "lib/NpmParser.ml"
                    )) * _menhir_state) = Obj.magic _menhir_stack in
                    ((let _menhir_env = _menhir_discard _menhir_env in
                    let _tok = _menhir_env._menhir_token in
                    match _tok with
                    | HYPHEN ->
                        _menhir_run13 _menhir_env (Obj.magic _menhir_stack) MenhirState37
                    | PART _v ->
                        _menhir_run10 _menhir_env (Obj.magic _menhir_stack) MenhirState37 _v
                    | PLUS ->
                        _menhir_run3 _menhir_env (Obj.magic _menhir_stack) MenhirState37
                    | CARET | EOF | GT | GTE | LT | LTE | NUM _ | OR | STAR | TILDE ->
                        _menhir_reduce37 _menhir_env (Obj.magic _menhir_stack) MenhirState37
                    | _ ->
                        assert (not _menhir_env._menhir_error);
                        _menhir_env._menhir_error <- true;
                        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState37) : 'freshtv14)
                | _ ->
                    assert (not _menhir_env._menhir_error);
                    _menhir_env._menhir_error <- true;
                    let (_menhir_env : _menhir_env) = _menhir_env in
                    let (_menhir_stack : ((('freshtv15 * _menhir_state * (
# 1 "lib/NpmParser.mly"
       (int)
# 1663 "lib/NpmParser.ml"
                    )) * _menhir_state) * (
# 1 "lib/NpmParser.mly"
       (int)
# 1667 "lib/NpmParser.ml"
                    )) * _menhir_state) = Obj.magic _menhir_stack in
                    ((let (_menhir_stack, _menhir_s) = _menhir_stack in
                    _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv16)) : 'freshtv18)
            | HYPHEN ->
                _menhir_run13 _menhir_env (Obj.magic _menhir_stack) MenhirState35
            | PART _v ->
                _menhir_run10 _menhir_env (Obj.magic _menhir_stack) MenhirState35 _v
            | PLUS ->
                _menhir_run3 _menhir_env (Obj.magic _menhir_stack) MenhirState35
            | CARET | EOF | GT | GTE | LT | LTE | NUM _ | OR | STAR | TILDE ->
                _menhir_reduce37 _menhir_env (Obj.magic _menhir_stack) MenhirState35) : 'freshtv20)
        | STAR ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv21 * _menhir_state * (
# 1 "lib/NpmParser.mly"
       (int)
# 1684 "lib/NpmParser.ml"
            )) * _menhir_state) = Obj.magic _menhir_stack in
            ((let _menhir_env = _menhir_discard _menhir_env in
            let _tok = _menhir_env._menhir_token in
            match _tok with
            | HYPHEN ->
                _menhir_run13 _menhir_env (Obj.magic _menhir_stack) MenhirState33
            | PART _v ->
                _menhir_run10 _menhir_env (Obj.magic _menhir_stack) MenhirState33 _v
            | PLUS ->
                _menhir_run3 _menhir_env (Obj.magic _menhir_stack) MenhirState33
            | CARET | EOF | GT | GTE | LT | LTE | NUM _ | OR | STAR | TILDE ->
                _menhir_reduce37 _menhir_env (Obj.magic _menhir_stack) MenhirState33
            | _ ->
                assert (not _menhir_env._menhir_error);
                _menhir_env._menhir_error <- true;
                _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState33) : 'freshtv22)
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv23 * _menhir_state * (
# 1 "lib/NpmParser.mly"
       (int)
# 1708 "lib/NpmParser.ml"
            )) * _menhir_state) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _menhir_s) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv24)) : 'freshtv26)
    | HYPHEN ->
        _menhir_run13 _menhir_env (Obj.magic _menhir_stack) MenhirState31
    | PART _v ->
        _menhir_run10 _menhir_env (Obj.magic _menhir_stack) MenhirState31 _v
    | PLUS ->
        _menhir_run3 _menhir_env (Obj.magic _menhir_stack) MenhirState31
    | CARET | EOF | GT | GTE | LT | LTE | NUM _ | OR | STAR | TILDE ->
        _menhir_reduce37 _menhir_env (Obj.magic _menhir_stack) MenhirState31

and _menhir_run43 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _menhir_stack = (_menhir_stack, _menhir_s) in
    let _menhir_env = _menhir_discard _menhir_env in
    let _tok = _menhir_env._menhir_token in
    match _tok with
    | NUM _v ->
        _menhir_run31 _menhir_env (Obj.magic _menhir_stack) MenhirState43 _v
    | STAR ->
        _menhir_run30 _menhir_env (Obj.magic _menhir_stack) MenhirState43
    | _ ->
        assert (not _menhir_env._menhir_error);
        _menhir_env._menhir_error <- true;
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState43

and _menhir_run45 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _menhir_stack = (_menhir_stack, _menhir_s) in
    let _menhir_env = _menhir_discard _menhir_env in
    let _tok = _menhir_env._menhir_token in
    match _tok with
    | NUM _v ->
        _menhir_run31 _menhir_env (Obj.magic _menhir_stack) MenhirState45 _v
    | STAR ->
        _menhir_run30 _menhir_env (Obj.magic _menhir_stack) MenhirState45
    | _ ->
        assert (not _menhir_env._menhir_error);
        _menhir_env._menhir_error <- true;
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState45

and _menhir_run47 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _menhir_stack = (_menhir_stack, _menhir_s) in
    let _menhir_env = _menhir_discard _menhir_env in
    let _tok = _menhir_env._menhir_token in
    match _tok with
    | NUM _v ->
        _menhir_run31 _menhir_env (Obj.magic _menhir_stack) MenhirState47 _v
    | STAR ->
        _menhir_run30 _menhir_env (Obj.magic _menhir_stack) MenhirState47
    | _ ->
        assert (not _menhir_env._menhir_error);
        _menhir_env._menhir_error <- true;
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState47

and _menhir_run49 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _menhir_stack = (_menhir_stack, _menhir_s) in
    let _menhir_env = _menhir_discard _menhir_env in
    let _tok = _menhir_env._menhir_token in
    match _tok with
    | NUM _v ->
        _menhir_run31 _menhir_env (Obj.magic _menhir_stack) MenhirState49 _v
    | STAR ->
        _menhir_run30 _menhir_env (Obj.magic _menhir_stack) MenhirState49
    | _ ->
        assert (not _menhir_env._menhir_error);
        _menhir_env._menhir_error <- true;
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState49

and _menhir_goto_prog : _menhir_env -> 'ttv_tail -> _menhir_state -> (
# 17 "lib/NpmParser.mly"
       (NpmTypes.raw)
# 1784 "lib/NpmParser.ml"
) -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv9) = Obj.magic _menhir_stack in
    let (_menhir_s : _menhir_state) = _menhir_s in
    let (_v : (
# 17 "lib/NpmParser.mly"
       (NpmTypes.raw)
# 1793 "lib/NpmParser.ml"
    )) = _v in
    ((let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv7) = Obj.magic _menhir_stack in
    let (_menhir_s : _menhir_state) = _menhir_s in
    let ((_1 : (
# 17 "lib/NpmParser.mly"
       (NpmTypes.raw)
# 1801 "lib/NpmParser.ml"
    )) : (
# 17 "lib/NpmParser.mly"
       (NpmTypes.raw)
# 1805 "lib/NpmParser.ml"
    )) = _v in
    (Obj.magic _1 : 'freshtv8)) : 'freshtv10)

and _menhir_run52 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _menhir_stack = (_menhir_stack, _menhir_s) in
    let _menhir_env = _menhir_discard _menhir_env in
    let _tok = _menhir_env._menhir_token in
    match _tok with
    | NUM _v ->
        _menhir_run2 _menhir_env (Obj.magic _menhir_stack) MenhirState52 _v
    | _ ->
        assert (not _menhir_env._menhir_error);
        _menhir_env._menhir_error <- true;
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState52

and _menhir_discard : _menhir_env -> _menhir_env =
  fun _menhir_env ->
    let lexer = _menhir_env._menhir_lexer in
    let lexbuf = _menhir_env._menhir_lexbuf in
    let _tok = lexer lexbuf in
    {
      _menhir_lexer = lexer;
      _menhir_lexbuf = lexbuf;
      _menhir_token = _tok;
      _menhir_error = false;
    }

and prog : (Lexing.lexbuf -> token) -> Lexing.lexbuf -> (
# 17 "lib/NpmParser.mly"
       (NpmTypes.raw)
# 1837 "lib/NpmParser.ml"
) =
  fun lexer lexbuf ->
    let _menhir_env =
      let (lexer : Lexing.lexbuf -> token) = lexer in
      let (lexbuf : Lexing.lexbuf) = lexbuf in
      ((let _tok = Obj.magic () in
      {
        _menhir_lexer = lexer;
        _menhir_lexbuf = lexbuf;
        _menhir_token = _tok;
        _menhir_error = false;
      }) : _menhir_env)
    in
    Obj.magic (let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv5) = ((), _menhir_env._menhir_lexbuf.Lexing.lex_curr_p) in
    ((let _menhir_env = _menhir_discard _menhir_env in
    let _tok = _menhir_env._menhir_token in
    match _tok with
    | CARET ->
        _menhir_run52 _menhir_env (Obj.magic _menhir_stack) MenhirState0
    | EOF ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv3) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = MenhirState0 in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv1) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        ((let _1 = () in
        let _v : (
# 17 "lib/NpmParser.mly"
       (NpmTypes.raw)
# 1869 "lib/NpmParser.ml"
        ) = 
# 21 "lib/NpmParser.mly"
              ( `Any )
# 1873 "lib/NpmParser.ml"
         in
        _menhir_goto_prog _menhir_env _menhir_stack _menhir_s _v) : 'freshtv2)) : 'freshtv4)
    | GT ->
        _menhir_run49 _menhir_env (Obj.magic _menhir_stack) MenhirState0
    | GTE ->
        _menhir_run47 _menhir_env (Obj.magic _menhir_stack) MenhirState0
    | LT ->
        _menhir_run45 _menhir_env (Obj.magic _menhir_stack) MenhirState0
    | LTE ->
        _menhir_run43 _menhir_env (Obj.magic _menhir_stack) MenhirState0
    | NUM _v ->
        _menhir_run31 _menhir_env (Obj.magic _menhir_stack) MenhirState0 _v
    | STAR ->
        _menhir_run30 _menhir_env (Obj.magic _menhir_stack) MenhirState0
    | TILDE ->
        _menhir_run1 _menhir_env (Obj.magic _menhir_stack) MenhirState0
    | _ ->
        assert (not _menhir_env._menhir_error);
        _menhir_env._menhir_error <- true;
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState0) : 'freshtv6))

# 219 "/Users/jared/.esy/3___________________________________________________________________/i/opam__slash__menhir-20171013.0.0-32d1b066/lib/menhir/standard.mly"
  


# 1899 "lib/NpmParser.ml"
