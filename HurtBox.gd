class_name HurtBox
extends Area2D

func _init() -> void:
	collision_layer = 8
	collision_mask = 4
	
func _ready() -> void:
	connect("area_entered", self, "_on_area_entered")

func _on_area_entered(hitbox: EnemyBox) -> void:
	if hitbox == null:
		return
	if owner.has_method("take_damage"):
		owner.take_damage(hitbox)
