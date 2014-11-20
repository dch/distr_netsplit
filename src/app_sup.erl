-module(app_sup).

-behaviour(application).

-export([start/2,
  stop/1]).



start(_StartType, _StartArgs) ->

  gs_sup:log(_StartType),

  case sup_sup:start_link() of
    {ok, Pid} ->
      {ok, Pid};
    Error ->
      Error
  end.


stop(_State) ->
  ok.
