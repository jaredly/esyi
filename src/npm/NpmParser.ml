
module MenhirBasics = struct
  
  exception Error
  
  type token = 
    | WHITE
    | TILDE
    | STAR
    | PLUS
    | PART of (
# 2 "src/npm/NpmParser.mly"
       (string)
# 15 "src/npm/NpmParser.ml"
  )
    | OR
    | NUM of (
# 1 "src/npm/NpmParser.mly"
       (int)
# 21 "src/npm/NpmParser.ml"
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
  | MenhirState70
  | MenhirState65
  | MenhirState56
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
    | MenhirState65 | MenhirState0 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv273) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let (_v : 'tv_simples) = _v in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv271) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let ((s : 'tv_simples) : 'tv_simples) = _v in
        ((let _v : 'tv_range = 
# 32 "src/npm/NpmParser.mly"
                ( s )
# 88 "src/npm/NpmParser.ml"
         in
        _menhir_goto_range _menhir_env _menhir_stack _menhir_s _v) : 'freshtv272)) : 'freshtv274)
    | MenhirState56 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv277 * _menhir_state * 'tv_simple)) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let (_v : 'tv_simples) = _v in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv275 * _menhir_state * 'tv_simple)) = Obj.magic _menhir_stack in
        let (_ : _menhir_state) = _menhir_s in
        let ((tl : 'tv_simples) : 'tv_simples) = _v in
        ((let (_menhir_stack, _menhir_s, (s : 'tv_simple)) = _menhir_stack in
        let _2 = () in
        let _v : 'tv_simples = 
# 35 "src/npm/NpmParser.mly"
                                     ( `And(s, tl) )
# 105 "src/npm/NpmParser.ml"
         in
        _menhir_goto_simples _menhir_env _menhir_stack _menhir_s _v) : 'freshtv276)) : 'freshtv278)
    | _ ->
        _menhir_fail ()

and _menhir_goto_parts : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_parts -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    match _menhir_s with
    | MenhirState3 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv249 * _menhir_state) * _menhir_state * 'tv_parts) = Obj.magic _menhir_stack in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv247 * _menhir_state) * _menhir_state * 'tv_parts) = Obj.magic _menhir_stack in
        ((let ((_menhir_stack, _menhir_s), _, (p : 'tv_parts)) = _menhir_stack in
        let _1 = () in
        let _v : 'tv_suffix = 
# 82 "src/npm/NpmParser.mly"
                    ( Some(String.concat "."  p ) )
# 125 "src/npm/NpmParser.ml"
         in
        _menhir_goto_suffix _menhir_env _menhir_stack _menhir_s _v) : 'freshtv248)) : 'freshtv250)
    | MenhirState8 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : (('freshtv253 * _menhir_state * 'tv_part)) * _menhir_state * 'tv_parts) = Obj.magic _menhir_stack in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : (('freshtv251 * _menhir_state * 'tv_part)) * _menhir_state * 'tv_parts) = Obj.magic _menhir_stack in
        ((let ((_menhir_stack, _menhir_s, (p : 'tv_part)), _, (p2 : 'tv_parts)) = _menhir_stack in
        let _2 = () in
        let _v : 'tv_parts = 
# 87 "src/npm/NpmParser.mly"
                              ( p :: p2 )
# 138 "src/npm/NpmParser.ml"
         in
        _menhir_goto_parts _menhir_env _menhir_stack _menhir_s _v) : 'freshtv252)) : 'freshtv254)
    | MenhirState11 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : (('freshtv257 * _menhir_state * (
# 2 "src/npm/NpmParser.mly"
       (string)
# 146 "src/npm/NpmParser.ml"
        ))) * _menhir_state * 'tv_parts) = Obj.magic _menhir_stack in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : (('freshtv255 * _menhir_state * (
# 2 "src/npm/NpmParser.mly"
       (string)
# 152 "src/npm/NpmParser.ml"
        ))) * _menhir_state * 'tv_parts) = Obj.magic _menhir_stack in
        ((let ((_menhir_stack, _menhir_s, (p : (
# 2 "src/npm/NpmParser.mly"
       (string)
# 157 "src/npm/NpmParser.ml"
        ))), _, (p2 : 'tv_parts)) = _menhir_stack in
        let _2 = () in
        let _v : 'tv_wordParts = 
# 91 "src/npm/NpmParser.mly"
                              ( p :: p2 )
# 163 "src/npm/NpmParser.ml"
         in
        _menhir_goto_wordParts _menhir_env _menhir_stack _menhir_s _v) : 'freshtv256)) : 'freshtv258)
    | MenhirState13 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv265 * _menhir_state) * _menhir_state * 'tv_parts) = Obj.magic _menhir_stack in
        ((assert (not _menhir_env._menhir_error);
        let _tok = _menhir_env._menhir_token in
        match _tok with
        | PLUS ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv259 * _menhir_state) * _menhir_state * 'tv_parts) = Obj.magic _menhir_stack in
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
                _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState15) : 'freshtv260)
        | EOF | WHITE ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv261 * _menhir_state) * _menhir_state * 'tv_parts) = Obj.magic _menhir_stack in
            ((let ((_menhir_stack, _menhir_s), _, (p : 'tv_parts)) = _menhir_stack in
            let _1 = () in
            let _v : 'tv_suffix = 
# 81 "src/npm/NpmParser.mly"
                      ( Some(String.concat "." p) )
# 194 "src/npm/NpmParser.ml"
             in
            _menhir_goto_suffix _menhir_env _menhir_stack _menhir_s _v) : 'freshtv262)
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv263 * _menhir_state) * _menhir_state * 'tv_parts) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv264)) : 'freshtv266)
    | MenhirState15 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ((('freshtv269 * _menhir_state) * _menhir_state * 'tv_parts)) * _menhir_state * 'tv_parts) = Obj.magic _menhir_stack in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ((('freshtv267 * _menhir_state) * _menhir_state * 'tv_parts)) * _menhir_state * 'tv_parts) = Obj.magic _menhir_stack in
        ((let (((_menhir_stack, _menhir_s), _, (p : 'tv_parts)), _, (p2 : 'tv_parts)) = _menhir_stack in
        let _3 = () in
        let _1 = () in
        let _v : 'tv_suffix = 
# 80 "src/npm/NpmParser.mly"
                                        ( Some(String.concat "."  (p @ p2)) )
# 215 "src/npm/NpmParser.ml"
         in
        _menhir_goto_suffix _menhir_env _menhir_stack _menhir_s _v) : 'freshtv268)) : 'freshtv270)
    | _ ->
        _menhir_fail ()

and _menhir_goto_ranges : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_ranges -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    match _menhir_s with
    | MenhirState0 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv241 * _menhir_state * 'tv_ranges) = Obj.magic _menhir_stack in
        ((assert (not _menhir_env._menhir_error);
        let _tok = _menhir_env._menhir_token in
        match _tok with
        | EOF ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv237 * _menhir_state * 'tv_ranges) = Obj.magic _menhir_stack in
            ((let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv235 * _menhir_state * 'tv_ranges) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _menhir_s, (v : 'tv_ranges)) = _menhir_stack in
            let _2 = () in
            let _v : (
# 18 "src/npm/NpmParser.mly"
       (NpmTypes.raw)
# 241 "src/npm/NpmParser.ml"
            ) = 
# 23 "src/npm/NpmParser.mly"
                    ( v )
# 245 "src/npm/NpmParser.ml"
             in
            _menhir_goto_prog _menhir_env _menhir_stack _menhir_s _v) : 'freshtv236)) : 'freshtv238)
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv239 * _menhir_state * 'tv_ranges) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv240)) : 'freshtv242)
    | MenhirState65 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : (((('freshtv245 * _menhir_state * 'tv_range)))) * _menhir_state * 'tv_ranges) = Obj.magic _menhir_stack in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : (((('freshtv243 * _menhir_state * 'tv_range)))) * _menhir_state * 'tv_ranges) = Obj.magic _menhir_stack in
        ((let ((_menhir_stack, _menhir_s, (r : 'tv_range)), _, (r2 : 'tv_ranges)) = _menhir_stack in
        let _4 = () in
        let _3 = () in
        let _2 = () in
        let _v : 'tv_ranges = 
# 27 "src/npm/NpmParser.mly"
                                             ( `Or(r, r2) )
# 267 "src/npm/NpmParser.ml"
         in
        _menhir_goto_ranges _menhir_env _menhir_stack _menhir_s _v) : 'freshtv244)) : 'freshtv246)
    | _ ->
        _menhir_fail ()

and _menhir_goto_simple : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_simple -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv233 * _menhir_state * 'tv_simple) = Obj.magic _menhir_stack in
    ((assert (not _menhir_env._menhir_error);
    let _tok = _menhir_env._menhir_token in
    match _tok with
    | WHITE ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv227 * _menhir_state * 'tv_simple) = Obj.magic _menhir_stack in
        ((let _menhir_env = _menhir_discard _menhir_env in
        let _tok = _menhir_env._menhir_token in
        match _tok with
        | CARET ->
            _menhir_run52 _menhir_env (Obj.magic _menhir_stack) MenhirState56
        | GT ->
            _menhir_run49 _menhir_env (Obj.magic _menhir_stack) MenhirState56
        | GTE ->
            _menhir_run47 _menhir_env (Obj.magic _menhir_stack) MenhirState56
        | LT ->
            _menhir_run45 _menhir_env (Obj.magic _menhir_stack) MenhirState56
        | LTE ->
            _menhir_run43 _menhir_env (Obj.magic _menhir_stack) MenhirState56
        | NUM _v ->
            _menhir_run31 _menhir_env (Obj.magic _menhir_stack) MenhirState56 _v
        | STAR ->
            _menhir_run30 _menhir_env (Obj.magic _menhir_stack) MenhirState56
        | TILDE ->
            _menhir_run1 _menhir_env (Obj.magic _menhir_stack) MenhirState56
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState56) : 'freshtv228)
    | EOF ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv229 * _menhir_state * 'tv_simple) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, (s : 'tv_simple)) = _menhir_stack in
        let _v : 'tv_simples = 
# 36 "src/npm/NpmParser.mly"
               ( s )
# 314 "src/npm/NpmParser.ml"
         in
        _menhir_goto_simples _menhir_env _menhir_stack _menhir_s _v) : 'freshtv230)
    | _ ->
        assert (not _menhir_env._menhir_error);
        _menhir_env._menhir_error <- true;
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv231 * _menhir_state * 'tv_simple) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv232)) : 'freshtv234)

and _menhir_goto_partial_tilde : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_partial_tilde -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    match _menhir_s with
    | MenhirState1 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv221 * _menhir_state) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let (_v : 'tv_partial_tilde) = _v in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv219 * _menhir_state) = Obj.magic _menhir_stack in
        let (_ : _menhir_state) = _menhir_s in
        let ((p : 'tv_partial_tilde) : 'tv_partial_tilde) = _v in
        ((let (_menhir_stack, _menhir_s) = _menhir_stack in
        let _1 = () in
        let _v : 'tv_simple = 
# 43 "src/npm/NpmParser.mly"
                             ( `UpToMajor(p) )
# 342 "src/npm/NpmParser.ml"
         in
        _menhir_goto_simple _menhir_env _menhir_stack _menhir_s _v) : 'freshtv220)) : 'freshtv222)
    | MenhirState52 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv225 * _menhir_state) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let (_v : 'tv_partial_tilde) = _v in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv223 * _menhir_state) = Obj.magic _menhir_stack in
        let (_ : _menhir_state) = _menhir_s in
        let ((p : 'tv_partial_tilde) : 'tv_partial_tilde) = _v in
        ((let (_menhir_stack, _menhir_s) = _menhir_stack in
        let _1 = () in
        let _v : 'tv_simple = 
# 44 "src/npm/NpmParser.mly"
                             ( `UpToMinor(p) )
# 359 "src/npm/NpmParser.ml"
         in
        _menhir_goto_simple _menhir_env _menhir_stack _menhir_s _v) : 'freshtv224)) : 'freshtv226)
    | _ ->
        _menhir_fail ()

and _menhir_goto_part : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_part -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv217 * _menhir_state * 'tv_part) = Obj.magic _menhir_stack in
    ((assert (not _menhir_env._menhir_error);
    let _tok = _menhir_env._menhir_token in
    match _tok with
    | DOT ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv211 * _menhir_state * 'tv_part) = Obj.magic _menhir_stack in
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
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState8) : 'freshtv212)
    | EOF | PLUS | WHITE ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv213 * _menhir_state * 'tv_part) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, (p : 'tv_part)) = _menhir_stack in
        let _v : 'tv_parts = 
# 88 "src/npm/NpmParser.mly"
             ( p :: [] )
# 394 "src/npm/NpmParser.ml"
         in
        _menhir_goto_parts _menhir_env _menhir_stack _menhir_s _v) : 'freshtv214)
    | _ ->
        assert (not _menhir_env._menhir_error);
        _menhir_env._menhir_error <- true;
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv215 * _menhir_state * 'tv_part) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv216)) : 'freshtv218)

and _menhir_fail : unit -> 'a =
  fun () ->
    Printf.fprintf Pervasives.stderr "Internal failure -- please contact the parser generator's developers.\n%!";
    assert false

and _menhir_goto_range : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_range -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv209 * _menhir_state * 'tv_range) = Obj.magic _menhir_stack in
    ((assert (not _menhir_env._menhir_error);
    let _tok = _menhir_env._menhir_token in
    match _tok with
    | WHITE ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv203 * _menhir_state * 'tv_range) = Obj.magic _menhir_stack in
        ((let _menhir_env = _menhir_discard _menhir_env in
        let _tok = _menhir_env._menhir_token in
        match _tok with
        | OR ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv199 * _menhir_state * 'tv_range)) = Obj.magic _menhir_stack in
            ((let _menhir_env = _menhir_discard _menhir_env in
            let _tok = _menhir_env._menhir_token in
            match _tok with
            | WHITE ->
                let (_menhir_env : _menhir_env) = _menhir_env in
                let (_menhir_stack : (('freshtv195 * _menhir_state * 'tv_range))) = Obj.magic _menhir_stack in
                ((let _menhir_env = _menhir_discard _menhir_env in
                let _tok = _menhir_env._menhir_token in
                match _tok with
                | CARET ->
                    _menhir_run52 _menhir_env (Obj.magic _menhir_stack) MenhirState65
                | GT ->
                    _menhir_run49 _menhir_env (Obj.magic _menhir_stack) MenhirState65
                | GTE ->
                    _menhir_run47 _menhir_env (Obj.magic _menhir_stack) MenhirState65
                | LT ->
                    _menhir_run45 _menhir_env (Obj.magic _menhir_stack) MenhirState65
                | LTE ->
                    _menhir_run43 _menhir_env (Obj.magic _menhir_stack) MenhirState65
                | NUM _v ->
                    _menhir_run31 _menhir_env (Obj.magic _menhir_stack) MenhirState65 _v
                | STAR ->
                    _menhir_run30 _menhir_env (Obj.magic _menhir_stack) MenhirState65
                | TILDE ->
                    _menhir_run1 _menhir_env (Obj.magic _menhir_stack) MenhirState65
                | _ ->
                    assert (not _menhir_env._menhir_error);
                    _menhir_env._menhir_error <- true;
                    _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState65) : 'freshtv196)
            | _ ->
                assert (not _menhir_env._menhir_error);
                _menhir_env._menhir_error <- true;
                let (_menhir_env : _menhir_env) = _menhir_env in
                let (_menhir_stack : (('freshtv197 * _menhir_state * 'tv_range))) = Obj.magic _menhir_stack in
                ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
                _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv198)) : 'freshtv200)
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv201 * _menhir_state * 'tv_range)) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv202)) : 'freshtv204)
    | EOF ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv205 * _menhir_state * 'tv_range) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, (r : 'tv_range)) = _menhir_stack in
        let _v : 'tv_ranges = 
# 28 "src/npm/NpmParser.mly"
              ( r )
# 477 "src/npm/NpmParser.ml"
         in
        _menhir_goto_ranges _menhir_env _menhir_stack _menhir_s _v) : 'freshtv206)
    | _ ->
        assert (not _menhir_env._menhir_error);
        _menhir_env._menhir_error <- true;
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv207 * _menhir_state * 'tv_range) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv208)) : 'freshtv210)

and _menhir_reduce28 : _menhir_env -> 'ttv_tail * _menhir_state * 'tv_partial -> 'ttv_return =
  fun _menhir_env _menhir_stack ->
    let (_menhir_stack, _menhir_s, (p : 'tv_partial)) = _menhir_stack in
    let _v : 'tv_simple = 
# 42 "src/npm/NpmParser.mly"
                ( p )
# 494 "src/npm/NpmParser.ml"
     in
    _menhir_goto_simple _menhir_env _menhir_stack _menhir_s _v

and _menhir_goto_primitive : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_primitive -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv193) = Obj.magic _menhir_stack in
    let (_menhir_s : _menhir_state) = _menhir_s in
    let (_v : 'tv_primitive) = _v in
    ((let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv191) = Obj.magic _menhir_stack in
    let (_menhir_s : _menhir_state) = _menhir_s in
    let ((p : 'tv_primitive) : 'tv_primitive) = _v in
    ((let _v : 'tv_simple = 
# 41 "src/npm/NpmParser.mly"
                  ( p )
# 511 "src/npm/NpmParser.ml"
     in
    _menhir_goto_simple _menhir_env _menhir_stack _menhir_s _v) : 'freshtv192)) : 'freshtv194)

and _menhir_goto_suffix : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_suffix -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    match _menhir_s with
    | MenhirState18 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : (('freshtv153 * _menhir_state * (
# 1 "src/npm/NpmParser.mly"
       (int)
# 523 "src/npm/NpmParser.ml"
        )) * _menhir_state)) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let (_v : 'tv_suffix) = _v in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : (('freshtv151 * _menhir_state * (
# 1 "src/npm/NpmParser.mly"
       (int)
# 531 "src/npm/NpmParser.ml"
        )) * _menhir_state)) = Obj.magic _menhir_stack in
        let (_ : _menhir_state) = _menhir_s in
        let ((s : 'tv_suffix) : 'tv_suffix) = _v in
        ((let ((_menhir_stack, _menhir_s, (major : (
# 1 "src/npm/NpmParser.mly"
       (int)
# 538 "src/npm/NpmParser.ml"
        ))), _) = _menhir_stack in
        let _3 = () in
        let _2 = () in
        let _v : 'tv_partial_tilde = 
# 74 "src/npm/NpmParser.mly"
  ( (major, 0, 0, s) )
# 545 "src/npm/NpmParser.ml"
         in
        _menhir_goto_partial_tilde _menhir_env _menhir_stack _menhir_s _v) : 'freshtv152)) : 'freshtv154)
    | MenhirState23 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : (((('freshtv157 * _menhir_state * (
# 1 "src/npm/NpmParser.mly"
       (int)
# 553 "src/npm/NpmParser.ml"
        )) * _menhir_state) * (
# 1 "src/npm/NpmParser.mly"
       (int)
# 557 "src/npm/NpmParser.ml"
        )) * _menhir_state)) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let (_v : 'tv_suffix) = _v in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : (((('freshtv155 * _menhir_state * (
# 1 "src/npm/NpmParser.mly"
       (int)
# 565 "src/npm/NpmParser.ml"
        )) * _menhir_state) * (
# 1 "src/npm/NpmParser.mly"
       (int)
# 569 "src/npm/NpmParser.ml"
        )) * _menhir_state)) = Obj.magic _menhir_stack in
        let (_ : _menhir_state) = _menhir_s in
        let ((s : 'tv_suffix) : 'tv_suffix) = _v in
        ((let ((((_menhir_stack, _menhir_s, (major : (
# 1 "src/npm/NpmParser.mly"
       (int)
# 576 "src/npm/NpmParser.ml"
        ))), _), (minor : (
# 1 "src/npm/NpmParser.mly"
       (int)
# 580 "src/npm/NpmParser.ml"
        ))), _) = _menhir_stack in
        let _5 = () in
        let _4 = () in
        let _2 = () in
        let _v : 'tv_partial_tilde = 
# 70 "src/npm/NpmParser.mly"
  ( (major, minor, 0, s) )
# 588 "src/npm/NpmParser.ml"
         in
        _menhir_goto_partial_tilde _menhir_env _menhir_stack _menhir_s _v) : 'freshtv156)) : 'freshtv158)
    | MenhirState25 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : (((('freshtv161 * _menhir_state * (
# 1 "src/npm/NpmParser.mly"
       (int)
# 596 "src/npm/NpmParser.ml"
        )) * _menhir_state) * (
# 1 "src/npm/NpmParser.mly"
       (int)
# 600 "src/npm/NpmParser.ml"
        )) * _menhir_state) * (
# 1 "src/npm/NpmParser.mly"
       (int)
# 604 "src/npm/NpmParser.ml"
        )) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let (_v : 'tv_suffix) = _v in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : (((('freshtv159 * _menhir_state * (
# 1 "src/npm/NpmParser.mly"
       (int)
# 612 "src/npm/NpmParser.ml"
        )) * _menhir_state) * (
# 1 "src/npm/NpmParser.mly"
       (int)
# 616 "src/npm/NpmParser.ml"
        )) * _menhir_state) * (
# 1 "src/npm/NpmParser.mly"
       (int)
# 620 "src/npm/NpmParser.ml"
        )) = Obj.magic _menhir_stack in
        let (_ : _menhir_state) = _menhir_s in
        let ((s : 'tv_suffix) : 'tv_suffix) = _v in
        ((let (((((_menhir_stack, _menhir_s, (major : (
# 1 "src/npm/NpmParser.mly"
       (int)
# 627 "src/npm/NpmParser.ml"
        ))), _), (minor : (
# 1 "src/npm/NpmParser.mly"
       (int)
# 631 "src/npm/NpmParser.ml"
        ))), _), (patch : (
# 1 "src/npm/NpmParser.mly"
       (int)
# 635 "src/npm/NpmParser.ml"
        ))) = _menhir_stack in
        let _4 = () in
        let _2 = () in
        let _v : 'tv_partial_tilde = 
# 68 "src/npm/NpmParser.mly"
  ( (major, minor, patch, s) )
# 642 "src/npm/NpmParser.ml"
         in
        _menhir_goto_partial_tilde _menhir_env _menhir_stack _menhir_s _v) : 'freshtv160)) : 'freshtv162)
    | MenhirState21 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : (('freshtv165 * _menhir_state * (
# 1 "src/npm/NpmParser.mly"
       (int)
# 650 "src/npm/NpmParser.ml"
        )) * _menhir_state) * (
# 1 "src/npm/NpmParser.mly"
       (int)
# 654 "src/npm/NpmParser.ml"
        )) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let (_v : 'tv_suffix) = _v in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : (('freshtv163 * _menhir_state * (
# 1 "src/npm/NpmParser.mly"
       (int)
# 662 "src/npm/NpmParser.ml"
        )) * _menhir_state) * (
# 1 "src/npm/NpmParser.mly"
       (int)
# 666 "src/npm/NpmParser.ml"
        )) = Obj.magic _menhir_stack in
        let (_ : _menhir_state) = _menhir_s in
        let ((s : 'tv_suffix) : 'tv_suffix) = _v in
        ((let (((_menhir_stack, _menhir_s, (major : (
# 1 "src/npm/NpmParser.mly"
       (int)
# 673 "src/npm/NpmParser.ml"
        ))), _), (minor : (
# 1 "src/npm/NpmParser.mly"
       (int)
# 677 "src/npm/NpmParser.ml"
        ))) = _menhir_stack in
        let _2 = () in
        let _v : 'tv_partial_tilde = 
# 72 "src/npm/NpmParser.mly"
  ( (major, minor, 0, s) )
# 683 "src/npm/NpmParser.ml"
         in
        _menhir_goto_partial_tilde _menhir_env _menhir_stack _menhir_s _v) : 'freshtv164)) : 'freshtv166)
    | MenhirState2 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv169 * _menhir_state * (
# 1 "src/npm/NpmParser.mly"
       (int)
# 691 "src/npm/NpmParser.ml"
        )) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let (_v : 'tv_suffix) = _v in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv167 * _menhir_state * (
# 1 "src/npm/NpmParser.mly"
       (int)
# 699 "src/npm/NpmParser.ml"
        )) = Obj.magic _menhir_stack in
        let (_ : _menhir_state) = _menhir_s in
        let ((s : 'tv_suffix) : 'tv_suffix) = _v in
        ((let (_menhir_stack, _menhir_s, (major : (
# 1 "src/npm/NpmParser.mly"
       (int)
# 706 "src/npm/NpmParser.ml"
        ))) = _menhir_stack in
        let _v : 'tv_partial_tilde = 
# 76 "src/npm/NpmParser.mly"
  ( (major, 0, 0, s) )
# 711 "src/npm/NpmParser.ml"
         in
        _menhir_goto_partial_tilde _menhir_env _menhir_stack _menhir_s _v) : 'freshtv168)) : 'freshtv170)
    | MenhirState33 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : (('freshtv173 * _menhir_state * (
# 1 "src/npm/NpmParser.mly"
       (int)
# 719 "src/npm/NpmParser.ml"
        )) * _menhir_state)) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let (_v : 'tv_suffix) = _v in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : (('freshtv171 * _menhir_state * (
# 1 "src/npm/NpmParser.mly"
       (int)
# 727 "src/npm/NpmParser.ml"
        )) * _menhir_state)) = Obj.magic _menhir_stack in
        let (_ : _menhir_state) = _menhir_s in
        let ((s : 'tv_suffix) : 'tv_suffix) = _v in
        ((let ((_menhir_stack, _menhir_s, (major : (
# 1 "src/npm/NpmParser.mly"
       (int)
# 734 "src/npm/NpmParser.ml"
        ))), _) = _menhir_stack in
        let _3 = () in
        let _2 = () in
        let _v : 'tv_partial = 
# 60 "src/npm/NpmParser.mly"
  ( `UpToMajor((major, 0, 0, s)) )
# 741 "src/npm/NpmParser.ml"
         in
        _menhir_goto_partial _menhir_env _menhir_stack _menhir_s _v) : 'freshtv172)) : 'freshtv174)
    | MenhirState37 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : (((('freshtv177 * _menhir_state * (
# 1 "src/npm/NpmParser.mly"
       (int)
# 749 "src/npm/NpmParser.ml"
        )) * _menhir_state) * (
# 1 "src/npm/NpmParser.mly"
       (int)
# 753 "src/npm/NpmParser.ml"
        )) * _menhir_state)) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let (_v : 'tv_suffix) = _v in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : (((('freshtv175 * _menhir_state * (
# 1 "src/npm/NpmParser.mly"
       (int)
# 761 "src/npm/NpmParser.ml"
        )) * _menhir_state) * (
# 1 "src/npm/NpmParser.mly"
       (int)
# 765 "src/npm/NpmParser.ml"
        )) * _menhir_state)) = Obj.magic _menhir_stack in
        let (_ : _menhir_state) = _menhir_s in
        let ((s : 'tv_suffix) : 'tv_suffix) = _v in
        ((let ((((_menhir_stack, _menhir_s, (major : (
# 1 "src/npm/NpmParser.mly"
       (int)
# 772 "src/npm/NpmParser.ml"
        ))), _), (minor : (
# 1 "src/npm/NpmParser.mly"
       (int)
# 776 "src/npm/NpmParser.ml"
        ))), _) = _menhir_stack in
        let _5 = () in
        let _4 = () in
        let _2 = () in
        let _v : 'tv_partial = 
# 56 "src/npm/NpmParser.mly"
  ( `UpToMinor((major, minor, 0, s)) )
# 784 "src/npm/NpmParser.ml"
         in
        _menhir_goto_partial _menhir_env _menhir_stack _menhir_s _v) : 'freshtv176)) : 'freshtv178)
    | MenhirState39 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : (((('freshtv181 * _menhir_state * (
# 1 "src/npm/NpmParser.mly"
       (int)
# 792 "src/npm/NpmParser.ml"
        )) * _menhir_state) * (
# 1 "src/npm/NpmParser.mly"
       (int)
# 796 "src/npm/NpmParser.ml"
        )) * _menhir_state) * (
# 1 "src/npm/NpmParser.mly"
       (int)
# 800 "src/npm/NpmParser.ml"
        )) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let (_v : 'tv_suffix) = _v in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : (((('freshtv179 * _menhir_state * (
# 1 "src/npm/NpmParser.mly"
       (int)
# 808 "src/npm/NpmParser.ml"
        )) * _menhir_state) * (
# 1 "src/npm/NpmParser.mly"
       (int)
# 812 "src/npm/NpmParser.ml"
        )) * _menhir_state) * (
# 1 "src/npm/NpmParser.mly"
       (int)
# 816 "src/npm/NpmParser.ml"
        )) = Obj.magic _menhir_stack in
        let (_ : _menhir_state) = _menhir_s in
        let ((s : 'tv_suffix) : 'tv_suffix) = _v in
        ((let (((((_menhir_stack, _menhir_s, (major : (
# 1 "src/npm/NpmParser.mly"
       (int)
# 823 "src/npm/NpmParser.ml"
        ))), _), (minor : (
# 1 "src/npm/NpmParser.mly"
       (int)
# 827 "src/npm/NpmParser.ml"
        ))), _), (patch : (
# 1 "src/npm/NpmParser.mly"
       (int)
# 831 "src/npm/NpmParser.ml"
        ))) = _menhir_stack in
        let _4 = () in
        let _2 = () in
        let _v : 'tv_partial = 
# 54 "src/npm/NpmParser.mly"
  ( `Exactly(major, minor, patch, s) )
# 838 "src/npm/NpmParser.ml"
         in
        _menhir_goto_partial _menhir_env _menhir_stack _menhir_s _v) : 'freshtv180)) : 'freshtv182)
    | MenhirState35 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : (('freshtv185 * _menhir_state * (
# 1 "src/npm/NpmParser.mly"
       (int)
# 846 "src/npm/NpmParser.ml"
        )) * _menhir_state) * (
# 1 "src/npm/NpmParser.mly"
       (int)
# 850 "src/npm/NpmParser.ml"
        )) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let (_v : 'tv_suffix) = _v in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : (('freshtv183 * _menhir_state * (
# 1 "src/npm/NpmParser.mly"
       (int)
# 858 "src/npm/NpmParser.ml"
        )) * _menhir_state) * (
# 1 "src/npm/NpmParser.mly"
       (int)
# 862 "src/npm/NpmParser.ml"
        )) = Obj.magic _menhir_stack in
        let (_ : _menhir_state) = _menhir_s in
        let ((s : 'tv_suffix) : 'tv_suffix) = _v in
        ((let (((_menhir_stack, _menhir_s, (major : (
# 1 "src/npm/NpmParser.mly"
       (int)
# 869 "src/npm/NpmParser.ml"
        ))), _), (minor : (
# 1 "src/npm/NpmParser.mly"
       (int)
# 873 "src/npm/NpmParser.ml"
        ))) = _menhir_stack in
        let _2 = () in
        let _v : 'tv_partial = 
# 58 "src/npm/NpmParser.mly"
  ( `Exactly(major, minor, 0, s) )
# 879 "src/npm/NpmParser.ml"
         in
        _menhir_goto_partial _menhir_env _menhir_stack _menhir_s _v) : 'freshtv184)) : 'freshtv186)
    | MenhirState31 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv189 * _menhir_state * (
# 1 "src/npm/NpmParser.mly"
       (int)
# 887 "src/npm/NpmParser.ml"
        )) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let (_v : 'tv_suffix) = _v in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv187 * _menhir_state * (
# 1 "src/npm/NpmParser.mly"
       (int)
# 895 "src/npm/NpmParser.ml"
        )) = Obj.magic _menhir_stack in
        let (_ : _menhir_state) = _menhir_s in
        let ((s : 'tv_suffix) : 'tv_suffix) = _v in
        ((let (_menhir_stack, _menhir_s, (major : (
# 1 "src/npm/NpmParser.mly"
       (int)
# 902 "src/npm/NpmParser.ml"
        ))) = _menhir_stack in
        let _v : 'tv_partial = 
# 62 "src/npm/NpmParser.mly"
  ( `Exactly(major, 0, 0, s) )
# 907 "src/npm/NpmParser.ml"
         in
        _menhir_goto_partial _menhir_env _menhir_stack _menhir_s _v) : 'freshtv188)) : 'freshtv190)
    | _ ->
        _menhir_fail ()

and _menhir_goto_wordParts : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_wordParts -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv149) = Obj.magic _menhir_stack in
    let (_menhir_s : _menhir_state) = _menhir_s in
    let (_v : 'tv_wordParts) = _v in
    ((let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv147) = Obj.magic _menhir_stack in
    let (_menhir_s : _menhir_state) = _menhir_s in
    let ((p : 'tv_wordParts) : 'tv_wordParts) = _v in
    ((let _v : 'tv_suffix = 
# 83 "src/npm/NpmParser.mly"
                  ( Some(String.concat "."  p ) )
# 926 "src/npm/NpmParser.ml"
     in
    _menhir_goto_suffix _menhir_env _menhir_stack _menhir_s _v) : 'freshtv148)) : 'freshtv150)

and _menhir_run4 : _menhir_env -> 'ttv_tail -> _menhir_state -> (
# 2 "src/npm/NpmParser.mly"
       (string)
# 933 "src/npm/NpmParser.ml"
) -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_env = _menhir_discard _menhir_env in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv145) = Obj.magic _menhir_stack in
    let (_menhir_s : _menhir_state) = _menhir_s in
    let ((p : (
# 2 "src/npm/NpmParser.mly"
       (string)
# 943 "src/npm/NpmParser.ml"
    )) : (
# 2 "src/npm/NpmParser.mly"
       (string)
# 947 "src/npm/NpmParser.ml"
    )) = _v in
    ((let _v : 'tv_part = 
# 96 "src/npm/NpmParser.mly"
             ( p )
# 952 "src/npm/NpmParser.ml"
     in
    _menhir_goto_part _menhir_env _menhir_stack _menhir_s _v) : 'freshtv146)

and _menhir_run5 : _menhir_env -> 'ttv_tail -> _menhir_state -> (
# 1 "src/npm/NpmParser.mly"
       (int)
# 959 "src/npm/NpmParser.ml"
) -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_env = _menhir_discard _menhir_env in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv143) = Obj.magic _menhir_stack in
    let (_menhir_s : _menhir_state) = _menhir_s in
    let ((n : (
# 1 "src/npm/NpmParser.mly"
       (int)
# 969 "src/npm/NpmParser.ml"
    )) : (
# 1 "src/npm/NpmParser.mly"
       (int)
# 973 "src/npm/NpmParser.ml"
    )) = _v in
    ((let _v : 'tv_part = 
# 95 "src/npm/NpmParser.mly"
            ( string_of_int(n) )
# 978 "src/npm/NpmParser.ml"
     in
    _menhir_goto_part _menhir_env _menhir_stack _menhir_s _v) : 'freshtv144)

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
# 49 "src/npm/NpmParser.mly"
                     ( `AtMost(p) )
# 996 "src/npm/NpmParser.ml"
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
# 47 "src/npm/NpmParser.mly"
                    ( `LessThan(p) )
# 1009 "src/npm/NpmParser.ml"
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
# 50 "src/npm/NpmParser.mly"
                     ( `AtLeast(p) )
# 1022 "src/npm/NpmParser.ml"
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
# 48 "src/npm/NpmParser.mly"
                    ( `GreaterThan(p) )
# 1035 "src/npm/NpmParser.ml"
         in
        _menhir_goto_primitive _menhir_env _menhir_stack _menhir_s _v) : 'freshtv114)) : 'freshtv116)
    | MenhirState56 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv117 * _menhir_state * 'tv_partial) = Obj.magic _menhir_stack in
        (_menhir_reduce28 _menhir_env (Obj.magic _menhir_stack) : 'freshtv118)
    | MenhirState0 | MenhirState65 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv131 * _menhir_state * 'tv_partial) = Obj.magic _menhir_stack in
        ((assert (not _menhir_env._menhir_error);
        let _tok = _menhir_env._menhir_token in
        match _tok with
        | WHITE ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv127 * _menhir_state * 'tv_partial) = Obj.magic _menhir_stack in
            ((let _menhir_env = _menhir_discard _menhir_env in
            let _tok = _menhir_env._menhir_token in
            match _tok with
            | HYPHEN ->
                let (_menhir_env : _menhir_env) = _menhir_env in
                let (_menhir_stack : ('freshtv123 * _menhir_state * 'tv_partial)) = Obj.magic _menhir_stack in
                ((let _menhir_env = _menhir_discard _menhir_env in
                let _tok = _menhir_env._menhir_token in
                match _tok with
                | WHITE ->
                    let (_menhir_env : _menhir_env) = _menhir_env in
                    let (_menhir_stack : (('freshtv119 * _menhir_state * 'tv_partial))) = Obj.magic _menhir_stack in
                    ((let _menhir_env = _menhir_discard _menhir_env in
                    let _tok = _menhir_env._menhir_token in
                    match _tok with
                    | NUM _v ->
                        _menhir_run31 _menhir_env (Obj.magic _menhir_stack) MenhirState70 _v
                    | STAR ->
                        _menhir_run30 _menhir_env (Obj.magic _menhir_stack) MenhirState70
                    | _ ->
                        assert (not _menhir_env._menhir_error);
                        _menhir_env._menhir_error <- true;
                        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState70) : 'freshtv120)
                | _ ->
                    assert (not _menhir_env._menhir_error);
                    _menhir_env._menhir_error <- true;
                    let (_menhir_env : _menhir_env) = _menhir_env in
                    let (_menhir_stack : (('freshtv121 * _menhir_state * 'tv_partial))) = Obj.magic _menhir_stack in
                    ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
                    _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv122)) : 'freshtv124)
            | _ ->
                assert (not _menhir_env._menhir_error);
                _menhir_env._menhir_error <- true;
                let (_menhir_env : _menhir_env) = _menhir_env in
                let (_menhir_stack : ('freshtv125 * _menhir_state * 'tv_partial)) = Obj.magic _menhir_stack in
                ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
                _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv126)) : 'freshtv128)
        | EOF ->
            _menhir_reduce28 _menhir_env (Obj.magic _menhir_stack)
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv129 * _menhir_state * 'tv_partial) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv130)) : 'freshtv132)
    | MenhirState70 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : (((('freshtv141 * _menhir_state * 'tv_partial)))) * _menhir_state * 'tv_partial) = Obj.magic _menhir_stack in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : (((('freshtv139 * _menhir_state * 'tv_partial)))) * _menhir_state * 'tv_partial) = Obj.magic _menhir_stack in
        ((let ((_menhir_stack, _menhir_s, (fr : 'tv_partial)), _, (t : 'tv_partial)) = _menhir_stack in
        let _4 = () in
        let _3 = () in
        let _2 = () in
        let _v : 'tv_hyphenated = 
# 38 "src/npm/NpmParser.mly"
                                                            ( `Between(fr, t) )
# 1109 "src/npm/NpmParser.ml"
         in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv137) = _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let (_v : 'tv_hyphenated) = _v in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv135) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let (_v : 'tv_hyphenated) = _v in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv133) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let ((h : 'tv_hyphenated) : 'tv_hyphenated) = _v in
        ((let _v : 'tv_range = 
# 31 "src/npm/NpmParser.mly"
                   ( h )
# 1126 "src/npm/NpmParser.ml"
         in
        _menhir_goto_range _menhir_env _menhir_stack _menhir_s _v) : 'freshtv134)) : 'freshtv136)) : 'freshtv138)) : 'freshtv140)) : 'freshtv142)
    | _ ->
        _menhir_fail ()

and _menhir_reduce37 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _v : 'tv_suffix = 
# 84 "src/npm/NpmParser.mly"
    ( None )
# 1137 "src/npm/NpmParser.ml"
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
# 2 "src/npm/NpmParser.mly"
       (string)
# 1159 "src/npm/NpmParser.ml"
) -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    let _menhir_env = _menhir_discard _menhir_env in
    let _tok = _menhir_env._menhir_token in
    match _tok with
    | DOT ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv95 * _menhir_state * (
# 2 "src/npm/NpmParser.mly"
       (string)
# 1171 "src/npm/NpmParser.ml"
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
    | EOF | WHITE ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv97 * _menhir_state * (
# 2 "src/npm/NpmParser.mly"
       (string)
# 1189 "src/npm/NpmParser.ml"
        )) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, (p : (
# 2 "src/npm/NpmParser.mly"
       (string)
# 1194 "src/npm/NpmParser.ml"
        ))) = _menhir_stack in
        let _v : 'tv_wordParts = 
# 92 "src/npm/NpmParser.mly"
             ( p :: [] )
# 1199 "src/npm/NpmParser.ml"
         in
        _menhir_goto_wordParts _menhir_env _menhir_stack _menhir_s _v) : 'freshtv98)
    | _ ->
        assert (not _menhir_env._menhir_error);
        _menhir_env._menhir_error <- true;
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv99 * _menhir_state * (
# 2 "src/npm/NpmParser.mly"
       (string)
# 1209 "src/npm/NpmParser.ml"
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
# 1 "src/npm/NpmParser.mly"
       (int)
# 1232 "src/npm/NpmParser.ml"
) -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    let _menhir_env = _menhir_discard _menhir_env in
    let _tok = _menhir_env._menhir_token in
    match _tok with
    | DOT ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv93 * _menhir_state * (
# 1 "src/npm/NpmParser.mly"
       (int)
# 1244 "src/npm/NpmParser.ml"
        )) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = MenhirState2 in
        ((let _menhir_stack = (_menhir_stack, _menhir_s) in
        let _menhir_env = _menhir_discard _menhir_env in
        let _tok = _menhir_env._menhir_token in
        match _tok with
        | NUM _v ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv87 * _menhir_state * (
# 1 "src/npm/NpmParser.mly"
       (int)
# 1256 "src/npm/NpmParser.ml"
            )) * _menhir_state) = Obj.magic _menhir_stack in
            let (_v : (
# 1 "src/npm/NpmParser.mly"
       (int)
# 1261 "src/npm/NpmParser.ml"
            )) = _v in
            ((let _menhir_stack = (_menhir_stack, _v) in
            let _menhir_env = _menhir_discard _menhir_env in
            let _tok = _menhir_env._menhir_token in
            match _tok with
            | DOT ->
                let (_menhir_env : _menhir_env) = _menhir_env in
                let (_menhir_stack : (('freshtv85 * _menhir_state * (
# 1 "src/npm/NpmParser.mly"
       (int)
# 1272 "src/npm/NpmParser.ml"
                )) * _menhir_state) * (
# 1 "src/npm/NpmParser.mly"
       (int)
# 1276 "src/npm/NpmParser.ml"
                )) = Obj.magic _menhir_stack in
                let (_menhir_s : _menhir_state) = MenhirState21 in
                ((let _menhir_stack = (_menhir_stack, _menhir_s) in
                let _menhir_env = _menhir_discard _menhir_env in
                let _tok = _menhir_env._menhir_token in
                match _tok with
                | NUM _v ->
                    let (_menhir_env : _menhir_env) = _menhir_env in
                    let (_menhir_stack : ((('freshtv79 * _menhir_state * (
# 1 "src/npm/NpmParser.mly"
       (int)
# 1288 "src/npm/NpmParser.ml"
                    )) * _menhir_state) * (
# 1 "src/npm/NpmParser.mly"
       (int)
# 1292 "src/npm/NpmParser.ml"
                    )) * _menhir_state) = Obj.magic _menhir_stack in
                    let (_v : (
# 1 "src/npm/NpmParser.mly"
       (int)
# 1297 "src/npm/NpmParser.ml"
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
                    | EOF | WHITE ->
                        _menhir_reduce37 _menhir_env (Obj.magic _menhir_stack) MenhirState25
                    | _ ->
                        assert (not _menhir_env._menhir_error);
                        _menhir_env._menhir_error <- true;
                        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState25) : 'freshtv80)
                | STAR ->
                    let (_menhir_env : _menhir_env) = _menhir_env in
                    let (_menhir_stack : ((('freshtv81 * _menhir_state * (
# 1 "src/npm/NpmParser.mly"
       (int)
# 1320 "src/npm/NpmParser.ml"
                    )) * _menhir_state) * (
# 1 "src/npm/NpmParser.mly"
       (int)
# 1324 "src/npm/NpmParser.ml"
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
                    | EOF | WHITE ->
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
# 1 "src/npm/NpmParser.mly"
       (int)
# 1348 "src/npm/NpmParser.ml"
                    )) * _menhir_state) * (
# 1 "src/npm/NpmParser.mly"
       (int)
# 1352 "src/npm/NpmParser.ml"
                    )) * _menhir_state) = Obj.magic _menhir_stack in
                    ((let (_menhir_stack, _menhir_s) = _menhir_stack in
                    _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv84)) : 'freshtv86)
            | HYPHEN ->
                _menhir_run13 _menhir_env (Obj.magic _menhir_stack) MenhirState21
            | PART _v ->
                _menhir_run10 _menhir_env (Obj.magic _menhir_stack) MenhirState21 _v
            | PLUS ->
                _menhir_run3 _menhir_env (Obj.magic _menhir_stack) MenhirState21
            | EOF | WHITE ->
                _menhir_reduce37 _menhir_env (Obj.magic _menhir_stack) MenhirState21
            | _ ->
                assert (not _menhir_env._menhir_error);
                _menhir_env._menhir_error <- true;
                _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState21) : 'freshtv88)
        | STAR ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv89 * _menhir_state * (
# 1 "src/npm/NpmParser.mly"
       (int)
# 1373 "src/npm/NpmParser.ml"
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
            | EOF | WHITE ->
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
# 1 "src/npm/NpmParser.mly"
       (int)
# 1397 "src/npm/NpmParser.ml"
            )) * _menhir_state) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _menhir_s) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv92)) : 'freshtv94)
    | HYPHEN ->
        _menhir_run13 _menhir_env (Obj.magic _menhir_stack) MenhirState2
    | PART _v ->
        _menhir_run10 _menhir_env (Obj.magic _menhir_stack) MenhirState2 _v
    | PLUS ->
        _menhir_run3 _menhir_env (Obj.magic _menhir_stack) MenhirState2
    | EOF | WHITE ->
        _menhir_reduce37 _menhir_env (Obj.magic _menhir_stack) MenhirState2
    | _ ->
        assert (not _menhir_env._menhir_error);
        _menhir_env._menhir_error <- true;
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState2

and _menhir_errorcase : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    match _menhir_s with
    | MenhirState70 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ((('freshtv29 * _menhir_state * 'tv_partial)))) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv30)
    | MenhirState65 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ((('freshtv31 * _menhir_state * 'tv_range)))) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv32)
    | MenhirState56 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv33 * _menhir_state * 'tv_simple)) = Obj.magic _menhir_stack in
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
# 1 "src/npm/NpmParser.mly"
       (int)
# 1462 "src/npm/NpmParser.ml"
        )) * _menhir_state) * (
# 1 "src/npm/NpmParser.mly"
       (int)
# 1466 "src/npm/NpmParser.ml"
        )) * _menhir_state) * (
# 1 "src/npm/NpmParser.mly"
       (int)
# 1470 "src/npm/NpmParser.ml"
        )) = Obj.magic _menhir_stack in
        ((let ((_menhir_stack, _menhir_s), _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv46)
    | MenhirState37 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : (((('freshtv47 * _menhir_state * (
# 1 "src/npm/NpmParser.mly"
       (int)
# 1479 "src/npm/NpmParser.ml"
        )) * _menhir_state) * (
# 1 "src/npm/NpmParser.mly"
       (int)
# 1483 "src/npm/NpmParser.ml"
        )) * _menhir_state)) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv48)
    | MenhirState35 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : (('freshtv49 * _menhir_state * (
# 1 "src/npm/NpmParser.mly"
       (int)
# 1492 "src/npm/NpmParser.ml"
        )) * _menhir_state) * (
# 1 "src/npm/NpmParser.mly"
       (int)
# 1496 "src/npm/NpmParser.ml"
        )) = Obj.magic _menhir_stack in
        ((let ((_menhir_stack, _menhir_s), _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv50)
    | MenhirState33 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : (('freshtv51 * _menhir_state * (
# 1 "src/npm/NpmParser.mly"
       (int)
# 1505 "src/npm/NpmParser.ml"
        )) * _menhir_state)) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv52)
    | MenhirState31 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv53 * _menhir_state * (
# 1 "src/npm/NpmParser.mly"
       (int)
# 1514 "src/npm/NpmParser.ml"
        )) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv54)
    | MenhirState25 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : (((('freshtv55 * _menhir_state * (
# 1 "src/npm/NpmParser.mly"
       (int)
# 1523 "src/npm/NpmParser.ml"
        )) * _menhir_state) * (
# 1 "src/npm/NpmParser.mly"
       (int)
# 1527 "src/npm/NpmParser.ml"
        )) * _menhir_state) * (
# 1 "src/npm/NpmParser.mly"
       (int)
# 1531 "src/npm/NpmParser.ml"
        )) = Obj.magic _menhir_stack in
        ((let ((_menhir_stack, _menhir_s), _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv56)
    | MenhirState23 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : (((('freshtv57 * _menhir_state * (
# 1 "src/npm/NpmParser.mly"
       (int)
# 1540 "src/npm/NpmParser.ml"
        )) * _menhir_state) * (
# 1 "src/npm/NpmParser.mly"
       (int)
# 1544 "src/npm/NpmParser.ml"
        )) * _menhir_state)) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv58)
    | MenhirState21 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : (('freshtv59 * _menhir_state * (
# 1 "src/npm/NpmParser.mly"
       (int)
# 1553 "src/npm/NpmParser.ml"
        )) * _menhir_state) * (
# 1 "src/npm/NpmParser.mly"
       (int)
# 1557 "src/npm/NpmParser.ml"
        )) = Obj.magic _menhir_stack in
        ((let ((_menhir_stack, _menhir_s), _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv60)
    | MenhirState18 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : (('freshtv61 * _menhir_state * (
# 1 "src/npm/NpmParser.mly"
       (int)
# 1566 "src/npm/NpmParser.ml"
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
# 2 "src/npm/NpmParser.mly"
       (string)
# 1585 "src/npm/NpmParser.ml"
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
# 1 "src/npm/NpmParser.mly"
       (int)
# 1604 "src/npm/NpmParser.ml"
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
# 63 "src/npm/NpmParser.mly"
         ( `Any )
# 1641 "src/npm/NpmParser.ml"
     in
    _menhir_goto_partial _menhir_env _menhir_stack _menhir_s _v) : 'freshtv28)

and _menhir_run31 : _menhir_env -> 'ttv_tail -> _menhir_state -> (
# 1 "src/npm/NpmParser.mly"
       (int)
# 1648 "src/npm/NpmParser.ml"
) -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    let _menhir_env = _menhir_discard _menhir_env in
    let _tok = _menhir_env._menhir_token in
    match _tok with
    | DOT ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv25 * _menhir_state * (
# 1 "src/npm/NpmParser.mly"
       (int)
# 1660 "src/npm/NpmParser.ml"
        )) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = MenhirState31 in
        ((let _menhir_stack = (_menhir_stack, _menhir_s) in
        let _menhir_env = _menhir_discard _menhir_env in
        let _tok = _menhir_env._menhir_token in
        match _tok with
        | NUM _v ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv19 * _menhir_state * (
# 1 "src/npm/NpmParser.mly"
       (int)
# 1672 "src/npm/NpmParser.ml"
            )) * _menhir_state) = Obj.magic _menhir_stack in
            let (_v : (
# 1 "src/npm/NpmParser.mly"
       (int)
# 1677 "src/npm/NpmParser.ml"
            )) = _v in
            ((let _menhir_stack = (_menhir_stack, _v) in
            let _menhir_env = _menhir_discard _menhir_env in
            let _tok = _menhir_env._menhir_token in
            match _tok with
            | DOT ->
                let (_menhir_env : _menhir_env) = _menhir_env in
                let (_menhir_stack : (('freshtv17 * _menhir_state * (
# 1 "src/npm/NpmParser.mly"
       (int)
# 1688 "src/npm/NpmParser.ml"
                )) * _menhir_state) * (
# 1 "src/npm/NpmParser.mly"
       (int)
# 1692 "src/npm/NpmParser.ml"
                )) = Obj.magic _menhir_stack in
                let (_menhir_s : _menhir_state) = MenhirState35 in
                ((let _menhir_stack = (_menhir_stack, _menhir_s) in
                let _menhir_env = _menhir_discard _menhir_env in
                let _tok = _menhir_env._menhir_token in
                match _tok with
                | NUM _v ->
                    let (_menhir_env : _menhir_env) = _menhir_env in
                    let (_menhir_stack : ((('freshtv11 * _menhir_state * (
# 1 "src/npm/NpmParser.mly"
       (int)
# 1704 "src/npm/NpmParser.ml"
                    )) * _menhir_state) * (
# 1 "src/npm/NpmParser.mly"
       (int)
# 1708 "src/npm/NpmParser.ml"
                    )) * _menhir_state) = Obj.magic _menhir_stack in
                    let (_v : (
# 1 "src/npm/NpmParser.mly"
       (int)
# 1713 "src/npm/NpmParser.ml"
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
                    | EOF | WHITE ->
                        _menhir_reduce37 _menhir_env (Obj.magic _menhir_stack) MenhirState39
                    | _ ->
                        assert (not _menhir_env._menhir_error);
                        _menhir_env._menhir_error <- true;
                        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState39) : 'freshtv12)
                | STAR ->
                    let (_menhir_env : _menhir_env) = _menhir_env in
                    let (_menhir_stack : ((('freshtv13 * _menhir_state * (
# 1 "src/npm/NpmParser.mly"
       (int)
# 1736 "src/npm/NpmParser.ml"
                    )) * _menhir_state) * (
# 1 "src/npm/NpmParser.mly"
       (int)
# 1740 "src/npm/NpmParser.ml"
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
                    | EOF | WHITE ->
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
# 1 "src/npm/NpmParser.mly"
       (int)
# 1764 "src/npm/NpmParser.ml"
                    )) * _menhir_state) * (
# 1 "src/npm/NpmParser.mly"
       (int)
# 1768 "src/npm/NpmParser.ml"
                    )) * _menhir_state) = Obj.magic _menhir_stack in
                    ((let (_menhir_stack, _menhir_s) = _menhir_stack in
                    _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv16)) : 'freshtv18)
            | HYPHEN ->
                _menhir_run13 _menhir_env (Obj.magic _menhir_stack) MenhirState35
            | PART _v ->
                _menhir_run10 _menhir_env (Obj.magic _menhir_stack) MenhirState35 _v
            | PLUS ->
                _menhir_run3 _menhir_env (Obj.magic _menhir_stack) MenhirState35
            | EOF | WHITE ->
                _menhir_reduce37 _menhir_env (Obj.magic _menhir_stack) MenhirState35
            | _ ->
                assert (not _menhir_env._menhir_error);
                _menhir_env._menhir_error <- true;
                _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState35) : 'freshtv20)
        | STAR ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv21 * _menhir_state * (
# 1 "src/npm/NpmParser.mly"
       (int)
# 1789 "src/npm/NpmParser.ml"
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
            | EOF | WHITE ->
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
# 1 "src/npm/NpmParser.mly"
       (int)
# 1813 "src/npm/NpmParser.ml"
            )) * _menhir_state) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _menhir_s) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv24)) : 'freshtv26)
    | HYPHEN ->
        _menhir_run13 _menhir_env (Obj.magic _menhir_stack) MenhirState31
    | PART _v ->
        _menhir_run10 _menhir_env (Obj.magic _menhir_stack) MenhirState31 _v
    | PLUS ->
        _menhir_run3 _menhir_env (Obj.magic _menhir_stack) MenhirState31
    | EOF | WHITE ->
        _menhir_reduce37 _menhir_env (Obj.magic _menhir_stack) MenhirState31
    | _ ->
        assert (not _menhir_env._menhir_error);
        _menhir_env._menhir_error <- true;
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState31

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
# 18 "src/npm/NpmParser.mly"
       (NpmTypes.raw)
# 1893 "src/npm/NpmParser.ml"
) -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv9) = Obj.magic _menhir_stack in
    let (_menhir_s : _menhir_state) = _menhir_s in
    let (_v : (
# 18 "src/npm/NpmParser.mly"
       (NpmTypes.raw)
# 1902 "src/npm/NpmParser.ml"
    )) = _v in
    ((let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv7) = Obj.magic _menhir_stack in
    let (_menhir_s : _menhir_state) = _menhir_s in
    let ((_1 : (
# 18 "src/npm/NpmParser.mly"
       (NpmTypes.raw)
# 1910 "src/npm/NpmParser.ml"
    )) : (
# 18 "src/npm/NpmParser.mly"
       (NpmTypes.raw)
# 1914 "src/npm/NpmParser.ml"
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
# 18 "src/npm/NpmParser.mly"
       (NpmTypes.raw)
# 1946 "src/npm/NpmParser.ml"
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
# 18 "src/npm/NpmParser.mly"
       (NpmTypes.raw)
# 1978 "src/npm/NpmParser.ml"
        ) = 
# 22 "src/npm/NpmParser.mly"
              ( `Any )
# 1982 "src/npm/NpmParser.ml"
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
  


# 2008 "src/npm/NpmParser.ml"
