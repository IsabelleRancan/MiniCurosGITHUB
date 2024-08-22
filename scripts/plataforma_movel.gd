extends Node2D

@export var duracao_espera := 1.0

@onready var plataforma := $plataforma as AnimatableBody2D
@export var veloci_movimento := 3.0
@export var distancia := 192
@export var mover_horizontal := true

var seguir := Vector2.ZERO
var plataforma_centro := 16

# Called when the node enters the scene tree for the first time.
func _ready():
	mover_plataforma()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	plataforma.position = plataforma.position.lerp(seguir, 0.5)
	
func mover_plataforma():
	var move_direcao = Vector2.RIGHT * distancia if mover_horizontal else Vector2.UP * distancia
	var duracao = move_direcao.length() / float(veloci_movimento * plataforma_centro)
	
	var plataforma_tween = create_tween().set_loops().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	plataforma_tween.tween_property(self, "seguir", move_direcao, duracao).set_delay(duracao_espera)
	plataforma_tween.tween_property(self, "seguir", Vector2.ZERO, duracao).set_delay(duracao + duracao_espera * 2)
	
