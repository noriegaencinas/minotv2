extends Control



func _on_boton_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://main.tscn")


func _on_boton_salir_pressed() -> void:
	pass # Replace with function body.
	get_tree().quit()
