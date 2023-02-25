extends Node

export(PackedScene) var dialogBoxScene : PackedScene

onready var controller = $ControllerEntrance/PathFollow2D/Path2D/PathFollow2D/BossController
onready var player = $Player
onready var coots = $Coots 

var fight_started : bool = false 

func _ready():
	OS.set_window_maximized(true)
	$PlayerDetectionBox.connect("area_entered", self, "_start_cutscene")
	controller.connect("update_stage", self, "_update_stage")

func play_dialog(dialogPath):
	var dialog = dialogBoxScene.instance()
	dialog.set("dialogPath", dialogPath)
	$UI.add_child(dialog)
	return dialog

func _start_cutscene(hitbox):
	if fight_started:
		return
	$PlayerDetectionBox/CollisionShape2D.set_deferred("disabled", true)
	fight_started = true
	
	#Ludwig finds coots
	player.states.force_idle()
	$camera_transition.transition_camera2D($Player.get_camera(), $BossFightCamera)
	yield($camera_transition, "finished_transition")
	yield(play_dialog("res://UI/Dialog/bossFight1.json"), "dialog_finished")
	
	#Coots Shoots Ludwig
	coots.turn_and_shoot()
	yield(player,"hit")
	player.states.force_idle()
	
	
	controller.idle()
	$Cutscenes.play("ControllerEntry")
	yield($Cutscenes, "animation_finished")
	$Cutscenes.play("ControllerFloat")
	coots.walk_left_and_sit()
	yield(coots, "sat_down")
	coots.can_paw = true
	coots._on_paw_timer_timeout()
	
	#TESTING CODE
	yield($Player, "progress")
	player.states.idle_right()
	controller.fight_stage = 1
	_update_stage(1)
	player.states.force_idle()
	yield($Cutscenes,"animation_finished")
	yield($Cutscenes,"animation_finished")
	controller.fight_stage = 2
	_update_stage(2)
	yield(get_tree().create_timer(1),"timeout")
	controller.emit_signal("destroyed")
	player.states.idle_right()

func _update_stage(stage: int) -> void:
	match stage:
		1: 
			coots.can_paw = false
			coots.can_shoot = true
			$Cutscenes.play("stage2")
			yield($Cutscenes, "animation_finished")
			$ControllerFloat.play("ControllerFloat")
			$Cutscenes.play("smilebot_entry")
			yield($Cutscenes, "animation_finished")
			$Platform1/LULW.CAN_SHOOT = true 
			$Platform2/LULW.CAN_SHOOT = true
			$Platform4/LULW.CAN_SHOOT = true
			$Platform5/LULW.CAN_SHOOT = true
			coots.animations.play_backwards("Sitting_down")
			yield(coots.animations, "animation_finished")
			coots.start_walking_turned()
			coots._on_laser_timer_timeout()
		2:
			coots.can_shoot = false
			controller.falling()
			$ControllerFloat.play("ControllerFall")
			yield($ControllerFloat,"animation_finished")
			coots.animations.play("Sitting_down")
		3:
			controller.animations.play("Falling")
			yield(controller.animations, "animation_finished")
			
			
		
