#!/bin/bash

#	terminal a:
 erl -sname a -config app -setcookie cookie1

#	terminal  b:
# erl -sname b -config app -setcookie cookie1

#	terminal a:
#  	application:load(app_sup,{app_sup,[a@localhost,b@localhost]}).
#		application:start(app_sup).

#	terminal b:
#  	application:load(app_sup,{app_sup,[a@localhost,b@localhost]}).
#		application:start(app_sup).


#	terminal a:
#	erlang:disconnect_node(b@localhost).


#	terminal a:
# 	net_adm:ping(b@localhost)