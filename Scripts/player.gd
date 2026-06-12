extends CharacterBody2D

@export var speed = 100
@export var current_weapon: WeaponData
@export var bullet_scene: PackedScene

@onready var _animated_sprite = $AnimatedSprite2D
@onready var gun = $Gun
@onready var gun_sprite = $Gun/Sprite2D

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed

func _physics_process(delta):
	get_input()
	move_and_slide()
	update_juice_animation(delta)
	position_gun()

func position_gun() -> void:
	if not current_weapon:
		return
		
	var mouse_pos = get_global_mouse_position()
	
	var gun_center = global_position + Vector2(0, -4)
	var angle = gun_center.angle_to_point(mouse_pos)
	
	gun.global_position = gun_center
	gun.global_rotation = angle
	
	gun_sprite.texture = current_weapon.texture
	gun_sprite.position.x = current_weapon.player_distance
	
	if mouse_pos.x < gun_center.x:
		gun_sprite.flip_v = true
		gun_sprite.offset.y = -6.0 
	else:
		gun_sprite.flip_v = false
		gun_sprite.offset.y = 0.0

func update_juice_animation(delta):
	var mouse_pos = get_global_mouse_position()
	
	if velocity.length() > 0:
		_animated_sprite.play("walk")
		var time = Time.get_ticks_msec() * 0.02
		var max_tilt_degrees = 12.0
		_animated_sprite.rotation_degrees = sin(time) * max_tilt_degrees
		var bounce = sin(time * 2.0) * 0.06
		_animated_sprite.scale.y = 1.0 + bounce
		_animated_sprite.scale.x = 1.0 - bounce
		
		_animated_sprite.flip_h = mouse_pos.x < global_position.x
	else:
		_animated_sprite.play("idle")
		_animated_sprite.rotation_degrees = lerp(_animated_sprite.rotation_degrees, 0.0, 15.0 * delta)
		_animated_sprite.scale = lerp(_animated_sprite.scale, Vector2(1, 1), 15.0 * delta)
		
		_animated_sprite.flip_h = mouse_pos.x < global_position.x

func _input(event):
	if event.is_action_pressed("shoot"):
		shoot()

func shoot() -> void:
	if not current_weapon or not bullet_scene:
		printerr("No bullet scene/weapon scene selected!")
		return
	var local_barrel_pos = current_weapon.barrel_position
	
	if gun_sprite.flip_v:
		local_barrel_pos.y = -local_barrel_pos.y
	
	var spawn_point = gun_sprite.to_global(local_barrel_pos)
	var bullet = bullet_scene.instantiate()
	
	get_tree().current_scene.add_child(bullet)
	bullet.global_position = spawn_point
	bullet.global_rotation = gun.global_rotation
