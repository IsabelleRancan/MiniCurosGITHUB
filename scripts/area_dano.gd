extends Area2D

@onready var collision = $collision as CollisionShape2D
@onready var spikes = $spikes as Sprite2D

func _ready():
	collision.shape.size = spikes.get_rect().size


func _on_body_entered(body):
	if body.name == "player" && body.has_method("tomar_dano"):
		body.tomar_dano(Vector2(0, -250))
