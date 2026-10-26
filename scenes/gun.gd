extends Node3D

@export var max_size: Vector3 = Vector3(0.5,0.5,0.5)
var index: int 

func _ready() -> void:
	for sprite in $NozzleBurst.get_children():
		sprite.scale = Vector3.ZERO

func nozzle_burst():
	$AudioStreamPlayer3D.play()
	index = posmod(index+1,$NozzleBurst.get_child_count())
	var tween = create_tween()
	tween.tween_property($NozzleBurst.get_child(index),"scale",max_size,0.1).from(Vector3.ZERO)
	tween.tween_property($NozzleBurst.get_child(index),"scale",Vector3.ZERO,0.2).from(max_size)
