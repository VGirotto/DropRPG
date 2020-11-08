extends Control

signal delete_save()
# Called when the node enters the scene tree for the first time.
func _ready():
	$Button.connect("pressed", self, "_on_Button_delete_pressed")

func _on_Button_delete_pressed():
	emit_signal("delete_save")
