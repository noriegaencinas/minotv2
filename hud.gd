extends CanvasLayer

var lives = 2
var score = 0

func _ready():
	update_hud()

func update_hud():
	$life_label.text = "Vidas: " + str(lives)
	$score_label.text = "Puntos: " + str(score)

func add_point():
	score += 10
	update_hud()

func lose_life():
	lives -= 1
	update_hud()
	if lives <= 0:
		game_over()

func game_over():
	get_tree().change_scene_to_file("res://menu_gameover/game_over.tscn")  # Cambia a una escena de Game Over
