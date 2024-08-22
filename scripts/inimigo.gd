extends CharacterBody2D


const SPEED = 20.0
const JUMP_VELOCITY = -400.0
@onready var detector := $detector_parede as RayCast2D
@onready var textura := $textura as Sprite2D
@onready var anim := $anima as AnimationPlayer

@export var direction := -1
@export var DURACAO_ANDAR = 4.0
var tempo := 0.0
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	tempo = DURACAO_ANDAR

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	if detector.is_colliding():
		direction *= -1
		detector.scale.x *= -1
		tempo = DURACAO_ANDAR
	
	if direction == 1:
		textura.flip_h = true
	else:
		textura.flip_h = false

	velocity.x = direction * SPEED
	
	if tempo > 0.0:
		tempo -= delta
		if tempo < 0.0:
			direction *= -1
			detector.scale.x *= -1
			tempo = DURACAO_ANDAR


	move_and_slide()

func _on_anima_animation_finished(anim_name):
	if anim_name == "dano":
		queue_free()
