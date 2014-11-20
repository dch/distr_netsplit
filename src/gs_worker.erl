-module(gs_worker).

-behaviour(gen_server).

%% API
-export([start_link/0, log/1]).

%% gen_server callbacks
-export([init/1,
  handle_call/3,
  handle_cast/2,
  handle_info/2,
  terminate/2,
  code_change/3]).

-define(SERVER, ?MODULE).


start_link() ->
  gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).


init([]) ->
  Node = node(),
  Msg = "gs_worker " ++ atom_to_list(Node),
  {ok, Tref} = timer:apply_interval(5000, ?MODULE, log, [Msg]),
  {ok, Tref}.



handle_call(_Request, _From, State) ->
  {reply, ok, State}.



handle_cast(_Request, State) ->
  {noreply, State}.


handle_info(Info, State) ->
  log(Info),
  {noreply, State}.


terminate(_Reason, Tref) ->
  timer:cancel(Tref),
  ok.


code_change(_OldVsn, State, _Extra) ->
  {ok, State}.


log(Msg) -> io:format("~p~n", [Msg]).