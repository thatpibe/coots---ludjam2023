extends Control

func _ready():
	OS.set_window_maximized(true)
	


func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		get_tree().change_scene("res://Cutscenes/Abduction.tscn")


func _on_Tutorial_pressed():
	get_tree().change_scene("res://Stages/Tutorial.tscn")
