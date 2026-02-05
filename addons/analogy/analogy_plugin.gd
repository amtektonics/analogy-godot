@tool
extends EditorPlugin


func _enter_tree() -> void:
	add_autoload_singleton("Analogy", "res://addons/analogy/Analogy.gd")


func _exit_tree() -> void:
	remove_autoload_singleton("Analogy")
