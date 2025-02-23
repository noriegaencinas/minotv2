extends CharacterBody2D

var move_speed = 200
var jump_speed = 400
@onready var animated_sprite = $animatedSprite
var is_facing_right = true
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_attacking = false  # Controla si el personaje está atacando

func _ready() -> void:
	add_to_group("player")
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
	if is_attacking: 
		return  # No cambiar animación si está atacando

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


func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		body.die()
