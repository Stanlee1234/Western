extends CharacterBody2D

@export var speed = 100
@onready var _animated_sprite = $AnimatedSprite2D

# Juicy animation variables
var target_rotation = 0.0
var target_scale = Vector2(1, 1)

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed

func _physics_process(delta):
	get_input()
	move_and_slide()
	update_juice_animation(delta)

func update_juice_animation(delta):
	if velocity.length() > 0:
		_animated_sprite.play("walk")
		
		# Keep the speed of the step, but lower the amplitude (intensity)
		var time = Time.get_ticks_msec() * 0.02
		
		# 1. GENTLE ROCKING 
		# Reduced max tilt to 6 degrees for a subtle waddle
		var max_tilt_degrees = 12.0
		_animated_sprite.rotation_degrees = sin(time) * max_tilt_degrees
		
		# 2. GENTLE SQUASH AND STRETCH
		# Reduced from 0.15 to 0.06 for a much milder bounce
		var bounce = sin(time * 2.0) * 0.06
		_animated_sprite.scale.y = 1.0 + bounce
		_animated_sprite.scale.x = 1.0 - bounce
		
		if velocity.x != 0:
			_animated_sprite.flip_h = velocity.x < 0
	else:
		_animated_sprite.play("idle")
		# Smoothly return to upright center and normal scale
		_animated_sprite.rotation_degrees = lerp(_animated_sprite.rotation_degrees, 0.0, 15.0 * delta)
		_animated_sprite.scale = lerp(_animated_sprite.scale, Vector2(1, 1), 15.0 * delta)
