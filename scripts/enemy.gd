#extends "res://scripts/base_enemy.gd"
extends KinematicBody2D

onready var anim = get_node("AnimatedSprite")
onready var stats = get_node("Stats")
onready var parent = get_parent()
onready var floaty = get_node("FloatyText")
onready var floaty2 = get_node("FloatyText2")

signal batalha()

var direction = Vector2()
var walk = false

func _physics_process(delta):	
	if get_position().y < 350 && walk:
		move_and_collide(direction)

func _on_start_enemy():
	var actual_enemy = BaseEnemy._get_enemy(parent.mapa)
	anim.play(BaseEnemy._get_anim(actual_enemy, "walk"))
	set_position(Vector2(645, -475))
	stats.visible = false
	parent.base_enemy.visible = true
	
	walk = true

	direction = Vector2(0, 15)
	while(get_position().y < 125):
		yield(get_tree().create_timer(0.00000005), "timeout")
	direction = Vector2(-15, 0)
	while(get_position().x > -55):
		yield(get_tree().create_timer(0.0000005), "timeout")
	direction = Vector2(0, 15)
	while(get_position().y < 350):
		yield(get_tree().create_timer(0.00000005), "timeout")
	walk = false

	anim.play(BaseEnemy._get_anim(actual_enemy, "idle"))
	
	_build_stats(actual_enemy)
	stats.visible = true
	yield(get_tree().create_timer(1), "timeout")
	emit_signal("batalha", actual_enemy, false)

func _build_stats(enemy):
	var val
	var i = 0
	var info = ["HP", "Attack", "Defense", "Agility", "Critical", "Wisdom", "Critical Resis."]
	for label in $Stats.get_children():
		val = BaseEnemy._get_stats(enemy, info[i])
		label.set_text(info[i] + ": " + String(val))
		i = i + 1

func _att_health(health, enemy):
	var aux = enemy + "_stats"
	var values = BaseEnemy.enemies.get(aux)
	$Stats/HP.set_text("HP: " + String(health))

func _on_got_damage(damage):
	var floaty_text = floaty
	
	floaty_text.position = Vector2(-100, -170)
	floaty_text.velocity = Vector2(rand_range(-50, 50), -100)
	floaty_text.modulate = Color(rand_range(0.7, 1), rand_range(0.7, 1), rand_range(0.7, 1), 1.0)
	
	floaty_text.text = damage
	if damage > 0:
		floaty_text.text = "+" + floaty_text.text
	
	add_child(floaty_text)

func _on_got_damage2(damage):
	var floaty_text = floaty2
	
	floaty_text.position = Vector2(10, -150)
	floaty_text.velocity = Vector2(rand_range(-50, 50), -100)
	floaty_text.modulate = Color(rand_range(0.7, 1), rand_range(0.7, 1), rand_range(0.7, 1), 1.0)
	
	floaty_text.text = damage
	if damage > 0:
		floaty_text.text = "+" + floaty_text.text
	
	add_child(floaty_text)
