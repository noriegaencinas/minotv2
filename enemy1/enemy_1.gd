extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var move_speed = 40
var is_attacking = false  # Controla si el personaje está atacando

func _ready():
	add_to_group("enemy")
	velocity.x = -move_speed
	$AnimatedSprite2D.play("walk")
	$Area2D/CollisionShape2D.disabled = true

func _physics_process(delta):
	velocity.y += gravity
	if is_on_wall():
		velocity.x *= -1  # Invierte la dirección
	
	# Ajusta la dirección del sprite y el área de ataque
	if velocity.x < 0:
		$AnimatedSprite2D.flip_h = false
		$Area2D.position.x = 5  # Ajusta la posición cuando mira a la izquierda
		$Area2D2.position.x = 7  # Ajusta la posición cuando mira a la derecha
	elif velocity.x > 0:
		$AnimatedSprite2D.flip_h = true
		$Area2D.position.x = -80  # Ajusta la posición cuando mira a la derecha
		$Area2D2.position.x = -110  # Ajusta la posición cuando mira a la derecha
	move_and_slide()
	
func die():
	velocity = Vector2.ZERO  # Detiene el movimiento
	$AnimatedSprite2D.play("dead")  # Reproduce la animación de muerte
	await $AnimatedSprite2D.animation_finished  # Espera a que termine la animación
	
	# 🚀 Enviar señal al HUD para sumar puntos
	var hud = get_node("../hud")  # Ajusta la ruta si es diferente
	hud.add_point()
	
	queue_free()  # Elimina el enemigo de la escena


func _on_area_2d_body_entered(body: Node2D) -> void: # interior
	print("algo")
	if body.is_in_group("player"):
		print("entro en zona de damage")
		body.play("hurt")


func _on_area_2d_2_body_entered(body: Node2D) -> void: # exterior
	if body.is_in_group("player") and not is_attacking:
		is_attacking = true
		$Area2D/CollisionShape2D.disabled = false
		$AnimatedSprite2D.play("attack")		
		await $AnimatedSprite2D.animation_finished  # Espera a que termine la animación		
		is_attacking = false
		$Area2D/CollisionShape2D.disabled = true
		$AnimatedSprite2D.play("walk")
		
		
		
