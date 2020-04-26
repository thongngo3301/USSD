%%%-------------------------------------------------------------------
%%% @author ThongND
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 26. Apr 2020 8:58 PM
%%%-------------------------------------------------------------------
-module(ussd).
-author("ThongND").

%% API
-export([start/0]).

get_dict() ->
  Dict = [
    {40,  <<0,1,0,1,0,0,0>>},   % (
    {56,  <<0,1,1,1,0,0,0>>},   % 8
    {72,  <<1,0,0,1,0,0,0>>},   % H
    {88,  <<1,0,1,1,0,0,0>>},   % X
    {104, <<1,1,0,1,0,0,0>>},   % h
    {120, <<1,1,1,1,0,0,0>>}    % x
  ],
  Dict.

map_from_dict(Char) ->
  Dict = get_dict(),
  Word = lists:keyfind(Char, 1, Dict),
  Code = element(2, Word),
  Code.

encoding(Str) ->
  encoding(Str, []).

encoding([H|T], Res) ->
  Code = map_from_dict(H),
  encoding(T, lists:append(Res,[Code]));
encoding([], Res) ->
  Res.

%construct_octets(List) ->
%  Len = length(List),
%  construct_octets(List, [], Len, 1).

%construct_octets([H1,H2|T], Res, Len, Octet_Index) when length(T) > 0 ->


start() ->
  Str = "8Hx",
  Res = encoding(Str),
  io:format("~p~n", [Res]).
