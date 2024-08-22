extends RigidBody2D


func _on_moeda_tree_exited():
	queue_free()
