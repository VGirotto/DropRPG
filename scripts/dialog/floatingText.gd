extends Position2D

onready var tween = get_node("Tween")

var velocity = Vector2(50, -100)
var gravity = Vector2(0, 1)
var mass = 200

var text setget set_text, get_text

# Called when the node enters the scene tree for the first time.
func _ready():
	tween.interpolate_property(self, "modulate",
	Color(modulate.r, modulate.g, modulate.b, modulate.a),
	Color(modulate.r, modulate.g, modulate.b, 0.0),
	0.3, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0.7)

	tween.interpolate_property(self, "scale", Vector2(0, 0), Vector2(1.0, 1.0),
	1.0, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0.6)
	
	tween.interpolate_callback(self, 1.0, "destroy")
	
	tween.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity += gravity * mass * delta
	position += velocity * delta

func set_text(new_text):
	$floatingText.text = str(new_text)

func get_text():
	return $floatingText.text
