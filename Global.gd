extends Node

var score = 0
var lives = 5
var health = 100
var level = 1
var max_health = 100
var max_lives = 5
var menu = null

func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS

func _unhandled_input(_event):
	if Input.is_action_just_pressed("menu"):
		if menu == null:
			menu = get_node_or_null("/root/Game/UI/In_Game_Menu")
		if menu != null:
			if not menu.visible:
				get_tree().paused = true
				menu.show()
			else:
				get_tree().paused = false
				menu.hide()

func increase_score(s):
	score += s

func decrease_health(h):
	health -= h
	
func decrease_lives(l):
	lives -= l
	health = max_health
	if lives <= 0:
		get_tree().change_scene("res://Levels/Game_Over.tscn")
