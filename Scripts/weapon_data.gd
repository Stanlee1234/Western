extends Resource
class_name WeaponData

@export var name: String = "Pistol"
@export var texture: Texture2D
@export var player_distance: float = 4.0  # Small offset for pistols
@export var barrel_position: Vector2      # Where bullets shoot from
