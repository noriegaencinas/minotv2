extends CharacterBody2D

func _ready():
	add_to_group("instakill")
	


func _on_area_2d_body_entered(body: Node2D) -> void:
	# print("Colisión detectada con:", body.name)  # Depuración
	if body.is_in_group("player"):
		# print("Jugador detectado. Ejecutando die().")
		body.die()
