(**************************************************************************)
(*                        Lem                                             *)
(*                                                                        *)
(*          Dominic Mulligan, University of Cambridge                     *)
(*          Francesco Zappa Nardelli, INRIA Paris-Rocquencourt            *)
(*          Gabriel Kerneis, University of Cambridge                      *)
(*          Kathy Gray, University of Cambridge                           *)
(*          Peter Boehm, University of Cambridge (while working on Lem)   *)
(*          Peter Sewell, University of Cambridge                         *)
(*          Scott Owens, University of Kent                               *)
(*          Thomas Tuerk, University of Cambridge                         *)
(*                                                                        *)
(*  The Lem sources are copyright 2010-2013                               *)
(*  by the UK authors above and Institut National de Recherche en         *)
(*  Informatique et en Automatique (INRIA).                               *)
(*                                                                        *)
(*  All files except ocaml-lib/pmap.{ml,mli} and ocaml-libpset.{ml,mli}   *)
(*  are distributed under the license below.  The former are distributed  *)
(*  under the LGPLv2, as in the LICENSE file.                             *)
(*                                                                        *)
(*                                                                        *)
(*  Redistribution and use in source and binary forms, with or without    *)
(*  modification, are permitted provided that the following conditions    *)
(*  are met:                                                              *)
(*  1. Redistributions of source code must retain the above copyright     *)
(*  notice, this list of conditions and the following disclaimer.         *)
(*  2. Redistributions in binary form must reproduce the above copyright  *)
(*  notice, this list of conditions and the following disclaimer in the   *)
(*  documentation and/or other materials provided with the distribution.  *)
(*  3. The names of the authors may not be used to endorse or promote     *)
(*  products derived from this software without specific prior written    *)
(*  permission.                                                           *)
(*                                                                        *)
(*  THIS SOFTWARE IS PROVIDED BY THE AUTHORS ``AS IS'' AND ANY EXPRESS    *)
(*  OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED     *)
(*  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE    *)
(*  ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY       *)
(*  DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL    *)
(*  DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE     *)
(*  GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS         *)
(*  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER  *)
(*  IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR       *)
(*  OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN   *)
(*  IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.                         *)
(**************************************************************************)

open Typed_ast

(** general functions about patterns *)

(** {2 Destructors and selector functions } *)

(** [is_var_wild_pat p] checks whether the pattern [p] is
    a wildcard or a variable pattern. Before checking
    type-annotations, parenthesis, etc. are removed. 
*)
val is_var_wild_pat : pat -> bool

(** [is_var_pat p] checks whether the pattern [p] is
    a variable pattern. *)
val is_var_pat : pat -> bool

(** [is_ext_var_pat p] checks whether the pattern [p] is
    a variable pattern in the broadest sense. In contrast
    to [is_var_pat p] also variables with type-annotations and
    parenthesis are accepted. [is_var_wild_pat p] additionally
    accepts wildcard patterns. *)
val is_ext_var_pat : pat -> bool


(** [is_var_tup_pat p] checks whether the pattern [p] consists only
    of variable and tuple patterns. *)
val is_var_tup_pat : pat -> bool

(** [is_var_wild_tup_pat p] checks whether the pattern [p] consists only
    of variable, wildcard and tuple patterns. *)
val is_var_wild_tup_pat : pat -> bool

val dest_var_pat : pat -> Name.t option
val dest_ext_var_pat : pat -> Name.t option

(** [is_wild_pat p] checks whether the pattern [p] is
    a wildcard pattern. *)
val is_wild_pat : pat -> bool

(** [dest_tup_pat lo p] destructs a tuple pattern. If
    [p] is no tuple pattern, [None] is returned. Otherwise,
    it destructs the tuple pattern into a list of patterns [pL].
    If [lo] is not [None], it checks whether the length of this
    list matches the length given by [lo]. If this is the case
    [Some pL] is returned, otherwise [None]. *)
val dest_tup_pat : int option -> pat -> pat list option

(** [mk_tup_pat [p1, ..., pn]] creates the pattern [(p1, ..., pn)]. *)
val mk_tup_pat : pat list -> pat 

(** [is_tup_pat lo p] checks whether [p] is a tuple pattern of the given length. 
    see [dest_tup_pat]*)
val is_tup_pat : int option -> pat -> bool

(** [dest_tf_pat p] destructs boolean literal patterns,
 i.e. [true] and [false] patterns. *)
val dest_tf_pat : pat -> bool option

(** [if_tf_pat p] checks whether [p] is the [true] or [false] pattern. *)
val is_tf_pat : pat -> bool

(** [if_t_pat p] checks whether [p] is the [true] pattern. *)
val is_t_pat : pat -> bool

(** [if_f_pat p] checks whether [p] is the [false] pattern. *)
val is_f_pat : pat -> bool

(** [mk_tf_pat b] creates [true] or [false] pattern. *)
val mk_tf_pat : bool -> pat

(** adds parenthesis around a pattern *)
val mk_paren_pat : pat -> pat

(** adds parenthesis around a pattern, when needed*)
val mk_opt_paren_pat : pat -> pat

(** [dest_num_pat p] destructs number literal patterns *)
val dest_num_pat : pat -> int option

(** [is_num_pat p] checks whether [p] is a number pattern. *)
val is_num_pat : pat -> bool

(** [mk_num_pat i] makes a number pattern. *)
val mk_num_pat : int -> pat

(** [dest_num_add_pat p] destructs number addition literal patterns *)
val dest_num_add_pat : pat -> (Name.t * int) option

(** [mk_num_add_pat i] makes a number addition pattern. *)
val mk_num_add_pat : Name.t -> int -> pat

(** [is_num_add_pat p] checks whether [p] is a number addition pattern. *)
val is_num_add_pat : pat -> bool

(** [num_ty_pat_cases f_v f_i f_a f_w f_else p] performs case analysis for patterns of type num. Depending of which form the pattern [p] has, 
    different argument functions are called:
- v -> f_v v
- c (num constant) -> f_i i 
- v + 0 -> f_v v
- v + i (for i > 0) -> f_a v i
- _ -> f_w
- p (everything else) -> f_else p
*)
val num_ty_pat_cases : (Name.t -> 'a) -> (int -> 'a) -> (Name.t -> int -> 'a) -> 'a -> (pat -> 'a) -> pat -> 'a

(** [dest_string_pat p] destructs number literal patterns *)
val dest_string_pat : pat -> string option

(** [is_string_pat p] checks whether [p] is a number pattern. *)
val is_string_pat : pat -> bool

(** [dest_cons_pat p] destructs list-cons patterns. *)
val dest_cons_pat : pat -> (pat * pat) option
val is_cons_pat : pat -> bool

(** [dest_list_pat p] destructs list patterns. *)
val dest_list_pat : int option -> pat ->  pat list option
val is_list_pat : int option -> pat -> bool


(** [dest_contr_pat p] destructs constructor patterns. *)
val dest_const_pat : pat ->  (const_descr_ref id * pat list) option
val is_const_pat : pat -> bool


(** [dest_record_pat p] destructs record patterns. *)
val dest_record_pat : pat ->  (const_descr_ref id * pat) list option
val is_record_pat : pat -> bool


(** {2 Classification of Patterns } *)

(** [direct_subpats p] returns a list of all the direct subpatterns of [p]. *)
val direct_subpats : pat -> pat list

(** [subpats p] returns a list of all the subpatterns of [p]. 
    In contrast to [direct_subpats p] really all subpatterns are
    returned, not only direct ones. This means that the result of
    [direct_subpats p] is a subset of [subpats p]. *)
val subpats : pat -> pat list


(** [exists_pat cf p] checks whether [p] has a subpattern [p'] such that [cf p'] holds. *)
val exists_subpat : (pat -> bool) -> pat -> bool

(** [for_all_subpat cf p] checks whether all subpatterns [p'] of [p] satisfy [cf p']. *)
val for_all_subpat : (pat -> bool) -> pat -> bool

(** [single_pat_exhaustive p] checks whether the pattern [p] is exhaustive. *)
val single_pat_exhaustive : pat -> bool

val pat_vars_src : pat -> (Name.lskips_t, unit) annot list

(** {2 miscellaneous } *)

(** [pat_extract_lskips p] extracts all whitespace from a pattern *)
val pat_extract_lskips : pat -> Ast.lex_skips

(** [split_var_annot_pat p] splits annotated variable patterns in variable patterns + type annotation.
    All other patterns are returned unchanged. *)
val split_var_annot_pat : pat -> pat
