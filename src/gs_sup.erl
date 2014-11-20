-module(gs_sup).

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
  net_kernel:monitor_nodes(true),

  start_my_worker(),

  Node = node(),
  Msg = "gs_sup " ++ atom_to_list(Node),
  {ok, Tref} = timer:apply_interval(5000, ?MODULE, log, [Msg]),
  {ok, Tref}.



handle_call(_Request, _From, State) ->
  {reply, ok, State}.



handle_cast(can_stop, State) ->
  stop_my_worker(),
  {noreply, State};


handle_cast(_Request, State) ->
  {noreply, State}.


handle_info({nodedown, Node}, State) ->
  log({nodedown, Node}),

  case Node of
    a@localhost ->
      start_my_worker(),
      {noreply, State};
    _ ->
      {noreply, State}
  end;


handle_info({nodeup, Node}, State) ->
  log({nodeup, Node}),

  notify_others(node()),
  {noreply, State};



handle_info(Info, State) ->
  log(Info),
  {noreply, State}.


terminate(_Reason, Tref) ->
  timer:cancel(Tref),
  ok.


code_change(_OldVsn, State, _Extra) ->
  {ok, State}.



start_my_worker() ->
  log("start app:"),
  Result = application:ensure_started(app),
  case Result of
    ok -> notify_others(node());
    _ -> error
  end,
  log(Result).




stop_my_worker() ->
  log("stop app:"),
  Result = application:stop(app),
  log(Result).



notify_others(a@localhost) ->
  gen_server:abcast([b@localhost], gs_sup, can_stop);

notify_others(_) -> ok.


log(Msg) -> io:format("~p~n", [Msg]).