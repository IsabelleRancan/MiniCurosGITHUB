extends CharacterBody2D

const box_pieces = preload("res://prefabs/pedacos.tscn")
const coin_intance = preload("res://prefabs/coin_rigid.tscn")
@onready var animation := $anim as AnimationPlayer
@onready var spaw_coin := $Marker2D as Marker2D
@export var pieces : PackedStringArray
@export var hitpoints := 3
var impulse := 200

func drop_coin():
	var coin = coin_intance.instantiate()
	get_parent().call_deferred("add_child", coin)
	coin.global_position = spaw_coin.global_position
	coin.apply_impulse(Vector2(randi_range(-50,50), -200))

func break_sprite():
	for piece in pieces.size():
		var pieces_intance = box_pieces.instantiate()
		get_parent().add_child(pieces_intance)
		pieces_intance.get_node("texture").texture = load(pieces[piece])
		pieces_intance.global_position = global_position
		pieces_intance.apply_impulse(Vector2(randi_range(-impulse, impulse), randi_range(-impulse, -impulse * 2)))
	queue_free()
