extends Control


onready var menu = get_parent().get_node("Menu")
onready var player = get_parent().get_node("player")
onready var parent = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	for btt in $VBoxContainer.get_children():
		btt.connect("pressed", self, "_on_Button_stat_pressed", [btt.button])
	$Exit.connect("pressed", self, "_on_Button_exit_pressed")


func _on_Map_points(hero):
	var aux
	for btt in $VBoxContainer.get_children():
		aux = btt.button
		match aux:
			"hp":
				btt.set_text("Max HP: " + String(hero.stats["max_hp"]) + "  HP: " + String(hero.stats["HP"]))
			"atk":
				btt.set_text("ATK: " + String(hero.stats["Attack"]))
			"def":
				btt.set_text("DEF: " + String(hero.stats["Defense"]))
			"agi":
				btt.set_text("AGI: " + String(hero.stats["Agility"]))
	$Points.set_text("Points: " + String(hero.points))

func _on_Button_exit_pressed():
	visible = false
	menu.visible = true

func _on_Button_stat_pressed(btt):
	if player["points"] > 0:
		player[btt] += 1
		if btt == "hp": player["maxHP"] += 1
		player["points"] -= 1
		player._build_stats()
		_on_Map_points(player)
		parent.save_game()
