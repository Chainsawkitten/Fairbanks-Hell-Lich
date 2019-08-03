extends Node2D

# Whether the object should move.
var dead : bool = false

# How much gravity should accelerate the object downward (pixels / second^2)
const gravity : float = 25.0

# The current velocity of the object, in pixels / second.
var velocity : Vector2 = Vector2(0, 0)

# The angular velocity in radians / second.
var angular_velocity : float = 0.0

# The maximum randomized velocity, in pixels / second.
const max_velocity = 25.0

# The maximum angular velocity, in radians / second
const max_angular_velocity = PI

var sprite_node = null

func _ready():
	sprite_node = get_node("Sprite")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if dead:
		velocity.y += gravity * delta
		transform.origin += velocity * delta
		sprite_node.rotation += angular_velocity * delta

# Activate the death object.
func die():
	dead = true
	visible = true
	
	# Randomize velocity and angular velocity.
	velocity.x = (randf() - 0.5) * 2.0 * max_velocity
	velocity.y = (randf() - 0.5) * 2.0 * max_velocity
	angular_velocity = (randf() - 0.5) * 2.0 * max_angular_velocity
