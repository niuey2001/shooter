extends CharacterBody3D

var player: CharacterBody3D:
	set(value):
		player = value 
		print(player)
var index: int
var burst_size =Vector3(0.5,0.5,0.5)
var rotation_speed := 5
var health :=3
var fall_speed: float  


func _ready() -> void:
	for sprite in $Skin/NozzleBurst.get_children():
		sprite.scale = Vector3.ZERO

func _process(delta: float) -> void:
	if player:
		var target_dir = (player.position - position).normalized()
		var current_dir = -global_transform.basis.z
		var new_dir = current_dir.slerp(target_dir, rotation_speed * delta).normalized()
		look_at(global_transform.origin + new_dir)

func _physics_process(_delta: float) -> void:
	velocity.y  -= fall_speed
	move_and_slide()

func _on_player_detection_body_entered(body: CharacterBody3D) -> void:
	player = body 
	$shootTimer.start()


func _on_player_detection_body_exited(_body: CharacterBody3D) -> void:
	player = null 
	$shootTimer.stop()


func _on_shoot_timer_timeout() -> void:
	index = posmod(index + 1 ,$Skin/NozzleBurst.get_child_count())
	$AudioStreamPlayer3D.play()
	var tween = create_tween()
	tween.tween_property($Skin/NozzleBurst.get_child(index),"scale",burst_size,0.1).from(Vector3.ZERO)
	tween.tween_property($Skin/NozzleBurst.get_child(index),"scale",Vector3.ZERO,0.2).from(burst_size)
	if player:
		player.hit()
		
	
func hit():
	flash()
	health -= 1
	if health <= 0:
		player = null
		$shootTimer.stop()
		fall_speed = 0.2
		var tween = create_tween()
		var random_rotation = Vector3(randf_range(-1,1),randf_range(-1,1),randf_range(-1,1))
		tween.tween_property($Skin,"rotation",random_rotation,1.5)
		await  get_tree().create_timer(2).timeout
		queue_free()
		
		
	
func flash():
	var tween = create_tween()
	tween.set_parallel()
	for mesh in  $Skin.get_children():
		if mesh is MeshInstance3D:
			tween.tween_property(mesh.material_overlay,'shader_parameter/Progress', 2.0, 0.1)
	tween.set_parallel(false)
	tween.tween_interval(0.2)
	tween.set_parallel()
	for mesh in  $Skin.get_children():
		if mesh is MeshInstance3D:
			tween.tween_property(mesh.material_overlay,'shader_parameter/Progress', 0.0, 0.1)	
	
			
	
