extends CharacterBody2D

const SPEED = 130.0
const JUMP_VELOCITY = -300.0
var is_jumping := false
@export var vida_player := 5
var knockback_vector := Vector2.ZERO


var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var animation := $anim as AnimatedSprite2D
@onready var remote_transform := $remote as RemoteTransform2D
@onready var direita := $ray_direita as RayCast2D
@onready var esquerda := $ray_esquerda as RayCast2D
@onready var corpo_colisor := $collsion
@onready var time := $Timer
var descendo = 2.0
var direction


func _physics_process(delta):
	if animation.animation != "kill":
		if !is_on_floor():
			velocity.y += gravity * delta

		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		direction = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
		
		if direction != 0:
			animation.scale.x = direction
			velocity.x = direction * SPEED
		else:
			velocity.x = 0

		if knockback_vector != Vector2.ZERO:
			velocity = knockback_vector
		
		#if Input.is_action_just_pressed("ui_down") and is_on_floor():
			#corpo_colisor.disabled = true
			#time.start(0.2)
			

		_set_state()
		move_and_slide()
		
		for platforms in get_slide_collision_count():
			var collision = get_slide_collision(platforms)
			if collision.get_collider().has_method("has_collided_with"):
				collision.get_collider().has_collided_with(collision, self)
 
func _on_hurtbox_body_entered(body):

	if direita.is_colliding():
		tomar_dano(Vector2(-200,-200))
	elif esquerda.is_colliding():
		tomar_dano(Vector2(200,-200))

func seguir_camera(camera):
	var camera_caminho = camera.get_path()
	remote_transform.remote_path = camera_caminho

func tomar_dano(knockback_force := Vector2.ZERO, duration := 0.25):

	if vida_player >= 0:
		vida_player -= 1
	if vida_player < 0:
		if animation.name != "kill":
			animation.play("kill")

	if knockback_force != Vector2.ZERO:
		knockback_vector = knockback_force
		print(vida_player)
		
		var knockback_tween := get_tree().create_tween()
		knockback_tween.parallel().tween_property(self, "knockback_vector", Vector2.ZERO, duration)
		animation.modulate = Color (1,0,0,1)
		knockback_tween.parallel().tween_property(animation, "modulate", Color(1,1,1,1), duration)
		
		

func _set_state():
	var state = "idle"
	
	if vida_player < 0:
		state = "kill"
	elif !is_on_floor():
		if velocity.y < 0:
			state = "jump"
		else:
			state = "fall"
	elif direction != 0:
		state = "walk"

	if animation.name != state:
		animation.play(state)
		



func _on_head_collider_body_entered(body):
	if body.has_method("break_sprite"):
		body.hitpoints -= 1
		if body.hitpoints < 1:
			body.drop_coin()
			body.break_sprite()
		else:
			body.animation.play("hit")
			body.drop_coin()


#func _on_timer_timeout():
	#corpo_colisor.disabled = false # Replace with function body.



func _on_anim_animation_finished():
	if animation.animation == "kill":
		queue_free()
