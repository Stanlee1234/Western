extends Camera2D

@export var decay: float = 2.0  # How quickly the shaking stops
@export var max_offset: Vector2 = Vector2(15.0, 15.0)  # Max pixel movement
@export var max_roll: float = 0.05  # Max rotation in radians

var trauma: float = 0.0  # Current shake strength (0.0 to 1.0)
var trauma_power: int = 2  # Squaring the trauma gives a snappier, heavier feel

func _ready() -> void:
	# Ensure we get truly random numbers every time the game starts
	randomize()

func add_trauma(amount: float) -> void:
	trauma = clamp(trauma + amount, 0.0, 1.0)

func _process(delta: float) -> void:
	if trauma > 0.0:
		# Drain the trauma over time
		trauma = max(trauma - decay * delta, 0.0)
		shake()
	elif offset != Vector2.ZERO or rotation != 0.0:
		# Smoothly return the camera to the exact center when the shake ends
		offset = lerp(offset, Vector2.ZERO, 15.0 * delta)
		rotation = lerp(rotation, 0.0, 15.0 * delta)

func shake() -> void:
	var amount = pow(trauma, trauma_power)
	
	# Pure, punchy arcade shake using random ranges between -1 and 1
	rotation = max_roll * amount * randf_range(-1.0, 1.0)
	offset.x = max_offset.x * amount * randf_range(-1.0, 1.0)
	offset.y = max_offset.y * amount * randf_range(-1.0, 1.0)
