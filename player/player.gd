extends CharacterBody2D

var move_speed = 200
var jump_speed = 400
@onready var animated_sprite = $animatedSprite
var is_facing_right = true
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_attacking = false  # Controla si el personaje está atacando
var is_dead = false  # Nueva variable para evitar sobrescribir la animación

func _ready():
	add_to_group("player")
	#print("Player agregado al grupo: ", is_in_group("player"))  # Depuración
	$hitbox/CollisionShape2D.disabled = true

func _physics_process(delta):
	attack()  # Primero verificamos si está atacando antes de actualizar animaciones
	jump(delta)
	move_x()
	flip()
	update_animations()
	move_and_slide()

func attack():
	if Input.is_action_just_pressed("attack") and not is_attacking:
		is_attacking = true
		animated_sprite.play("attack")
		$hitbox/CollisionShape2D.disabled = false
		await animated_sprite.animation_finished  # Espera a que termine la animación
		$hitbox/CollisionShape2D.disabled = true
		is_attacking = false

func update_animations():
	if is_dead or is_attacking:  # 🚨 Evita que cualquier otra animación sobreescriba "dead"
		return

	if velocity.x != 0:
		animated_sprite.play("walk")
	else:
		animated_sprite.play("idle")

func jump(delta):
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = -jump_speed
	
	if not is_on_floor():
		velocity.y += gravity * delta

func flip():
	if (is_facing_right and velocity.x < 0) or (not is_facing_right and velocity.x > 0):
		scale.x *= -1
		is_facing_right = not is_facing_right

func move_x():
	var input_axis = Input.get_axis("move_left","move_right")
	velocity.x = input_axis * move_speed

func die():
	if is_dead:
		return  # Evita múltiples ejecuciones de la muerte

	is_dead = true
	velocity = Vector2.ZERO
	animated_sprite.play("dead")
	await animated_sprite.animation_finished

	# Primero cambiamos de escena
	get_tree().change_scene_to_file("res://menu_gameover/game_over.tscn")

	# Luego eliminamos el nodo, pero con un pequeño retraso para evitar conflictos	
	queue_free()



func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		body.die()
