extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var move_speed = 100

func _ready():
	add_to_group("enemy")
	velocity.x = -move_speed
	$AnimatedSprite2D.play("walk")

func _physics_process(delta):
	velocity.y += gravity
	if is_on_wall():
		if !$AnimatedSprite2D.flip_h:
			velocity.x = move_speed
		else:
			velocity.x = -move_speed
			
	if velocity.x < 0:
		$AnimatedSprite2D.flip_h = false
	elif velocity.x > 0:
		$AnimatedSprite2D.flip_h = true
	move_and_slide()
	
func die():
	velocity = Vector2.ZERO  # Detiene el movimiento
	$AnimatedSprite2D.play("dead")  # Reproduce la animación de muerte
	await $AnimatedSprite2D.animation_finished  # Espera a que termine la animación
	queue_free()  # Elimina el enemigo de la escena
