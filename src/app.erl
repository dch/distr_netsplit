-module(app).

-behaviour(application).

-export([start/2,
  stop/1]).



start(_StartType, _StartArgs) ->

  gs_worker:log(_StartType),

  case sup_worker:start_link() of
    {ok, Pid} ->
      {ok, Pid};
    Error ->
      Error
  end.


stop(_State) ->
  ok.
