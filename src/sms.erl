%%%-------------------------------------------------------------------
%%% @author ThongND
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 26. Apr 2020 8:58 PM
%%%-------------------------------------------------------------------
-module(sms).
-author("ThongND").

-define(DICT, [
  {$@, 0},    {$Δ, 16},   {$ , 32},   {$0, 48},   {$¡, 64},   {$P, 80},   {$¿, 96},   {$p, 112},
  {$£, 1},    {$_, 17},   {$!, 33},   {$1, 49},   {$A, 65},   {$Q, 81},   {$a, 97},   {$q, 113},
  {$$, 2},    {$Φ, 18},   {$", 34},   {$2, 50},   {$B, 66},   {$R, 82},   {$b, 98},   {$r, 114},
  {$¥, 3},    {$Γ, 19},   {$#, 35},   {$3, 51},   {$C, 67},   {$S, 83},   {$c, 99},   {$s, 115},
  {$è, 4},    {$Λ, 20},   {$¤, 36},   {$4, 52},   {$D, 68},   {$T, 84},   {$d, 100},  {$t, 116},
  {$é, 5},    {$Ω, 21},   {$%, 37},   {$5, 53},   {$E, 69},   {$U, 85},   {$e, 101},  {$u, 117},
  {$ù, 6},    {$Π, 22},   {$&, 38},   {$6, 54},   {$F, 70},   {$V, 86},   {$f, 102},  {$v, 118},
  {$ì, 7},    {$Ψ, 23},   {$', 39},   {$7, 55},   {$G, 71},   {$W, 87},   {$g, 103},  {$w, 119},
  {$ò, 8},    {$Σ, 24},   {$(, 40},   {$8, 56},   {$H, 72},   {$X, 88},   {$h, 104},  {$x, 120},
  {$Ç, 9},    {$Θ, 25},   {$), 41},   {$9, 57},   {$I, 73},   {$Y, 89},   {$i, 105},  {$y, 121},
  {$\n, 10},  {$Ξ, 26},   {$*, 42},   {$:, 58},   {$J, 74},   {$Z, 90},   {$j, 106},  {$z, 122},
  {$Ø, 11},   {$\e, 27},  {$+, 43},   {$;, 59},   {$K, 75},   {$Ä, 91},   {$k, 107},  {$ä, 123},
  {$ø, 12},   {$Æ, 28},   {$,, 44},   {$<, 60},   {$L, 76},   {$Ö, 92},   {$l, 108},  {$ö, 124},
  {$\r, 13},  {$æ, 29},   {$-, 45},   {$=, 61},   {$M, 77},   {$Ñ, 93},   {$m, 109},  {$ñ, 125},
  {$Å, 14},   {$ß, 30},   {$., 46},   {$>, 62},   {$N, 78},   {$Ü, 94},   {$n, 110},  {$ü, 126},
  {$å, 15},   {$É, 31},   {$/, 47},   {$?, 63},   {$O, 79},   {$§, 95},   {$o, 111},  {$à, 127}
]).
-define(USSD_7_SPARE, 13).

%% API
-export([start/1]).

map_from_dict(Char) ->
  Word = lists:keyfind(Char, 1, ?DICT),
  Code = element(2, Word),
  Code.

encoding(Str) ->
  encoding(Str, []).

encoding([H|T], Res) ->
  Code = map_from_dict(H),
  encoding(T, lists:append(Res,[Code]));
encoding([], Res) ->
  Res.

construct_octets(List) ->
  Len = length(List),
  Padd_Index = Len rem 8,
  Reverse_List = lists:reverse(List),
  construct_octets(Reverse_List, Padd_Index).

construct_octets([H|T], Padd_Index) when is_integer(Padd_Index) == true ->
  construct_octets(T, <<0:Padd_Index, H:7>>);
construct_octets([H|T], Res) ->
  construct_octets(T, <<Res/bitstring, H:7>>);
construct_octets([], Res) ->
  binary:encode_unsigned(binary:decode_unsigned(Res, little)).

start({Type, Str}) ->
  io:format("String (~p): ~p~n", [length(Str), Str]),
  Encoded_Str = encoding(Str),
  io:format("Encoded: ~w~n", [Encoded_Str]),
  SMS = construct_octets(Encoded_Str),
  Len_SMS = length(binary:bin_to_list(SMS)),
  Num_Of_Spare = length(Str) rem 8,
  io:format("SMS (length ~p - spare ~p): ~w~n", [Len_SMS, Num_Of_Spare, SMS]),
  {Num_Of_Spare, SMS}.
