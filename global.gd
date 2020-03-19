extends Node

var send_port = 0
var get_port = 0
var send_ip = ""
var player = 0
var player_name=""
var peer_name = ""
const fake_mario = "fake_mario"
const Mario = "Mario"
var canMove = true

var initOK = false #set this to true when initialization is done
#(as in, the players already know each others nicks and whatnot)
var peer_initOK = true #set this to true when peer tells they already
#initialized

var level_index = 0
var worlds = [
"res://worlds/world1-1.tscn",
"res://worlds/world1-2.tscn"
]
