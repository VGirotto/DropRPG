extends KinematicBody2D

onready var floaty = get_node("FloatyText")
onready var floaty2 = get_node("FloatyText2")
onready var anim = get_node("AnimatedSprite")
onready var parent = get_parent()

export (float) var level = 1
export (float) var experience = 0
export (int) var hp = 100
export (int) var atk = 10
export (int) var def = 1
export (float) var agi = 1
export (float) var cri = 0
export (float) var wis = 10
export (float) var res = 10
export (float) var crd = 20
export (float) var red = 0
export (float) var lee = 0
export (float) var maxHP = 100
export (float) var points = 0



var stats = {
	Experience = 0,
	Level = 1,
	HP = 0,
	Attack = 0,
	Defense = 0,
	Agility = 0.0,
	Critical = 0.0,
	Wisdom = 0,
	res = 0.0,
	lee = 0.0,
	crd = 0.0,
	red = 0.0,
	max_hp = maxHP
}

# Called when the node enters the scene tree for the first time.
func _ready():
	_build_stats()
	anim.play("idle")

func _build_stats():
	_att_stats()
	var val
	var i = 0
	if stats.HP > stats.max_hp:
		stats.HP = stats.max_hp
	var info = ["Level", "Experience", "HP", "Attack", "Defense", "Agility", "Critical", "Wisdom", "Critical Resis.", "Critical Damage", "Damage Reflect", "Life Leecher"]
	for label in $Stats.get_children():
		val = _get_stats(info[i])
		label.set_text(info[i] + ": " + String(val))
		i = i + 1

func _get_stats(stat):
	if (stat == "Critical Resis."):
		stat = "res"
	elif (stat == "Critical Damage"):
		stat = "crd"
	elif (stat == "Damage Reflect"):
		stat = "red"
	elif (stat == "Life Leecher"):
		stat = "lee"

	return stats[stat]

func _att_stats():
	for info in stats:
		match info:
			"Experience": 
				while experience >= level * 10:
					level += 1
					experience = experience - (level-1) * 10
					points += 10
					if(hp < maxHP - 20): hp += 20
					else: hp = maxHP
				stats.Experience = experience
			"Level": stats.Level = level
			"HP": 
				stats.HP = int((hp + (Items._get_equip_stat(Items.Helmet, Items.equip.helmet, "hp") * (1 + (Items.qtdEquip[Items.equip.helmet]-1) * 0.1)))
				+ (Items._get_equip_stat(Items.Necklace, Items.equip.necklace, "hp") * (1 + (Items.qtdEquip[Items.equip.necklace]-1) * 0.1)))
			"Attack": 
				stats.Attack = int(atk + Items._get_equip_stat(Items.Gloves, Items.equip.gloves, "atk") * (1 + (Items.qtdEquip[Items.equip.gloves]-1) * 0.1) 
				+ Items._get_equip_stat(Items.Sword, Items.equip.sword, "atk") * (1 + (Items.qtdEquip[Items.equip.sword]-1) * 0.1))
			"Defense": 
				stats.Defense = int(def + Items._get_equip_stat(Items.Breastplate, Items.equip.breastplate, "def") * (1 + (Items.qtdEquip[Items.equip.breastplate]-1) * 0.1)
				+ Items._get_equip_stat(Items.Shield, Items.equip.shield, "def") * (1 + (Items.qtdEquip[Items.equip.shield]-1) * 0.1))
			"Agility": 
				stats.Agility = (agi + Items._get_equip_stat(Items.Shoes, Items.equip.shoes, "agi") * (1 + (Items.qtdEquip[Items.equip.shoes]-1) * 0.1)
				+ Items._get_equip_stat(Items.Pants, Items.equip.pants, "agi") * (1 + (Items.qtdEquip[Items.equip.pants]-1) * 0.1))
			"Critical": 
				stats.Critical = ((stats.Agility * 0.05) + Items._get_equip_stat(Items.Gloves, Items.equip.gloves, "cri") * (1 + (Items.qtdEquip[Items.equip.gloves]-1) * 0.1)
				+ Items._get_equip_stat(Items.Bracelet, Items.equip.bracelet, "cri") * (1 + (Items.qtdEquip[Items.equip.bracelet]-1) * 0.1))
			"Wisdom": 
				stats.Wisdom = int(wis + Items._get_equip_stat(Items.Necklace, Items.equip.necklace, "wis") * (1 + (Items.qtdEquip[Items.equip.necklace]-1) * 0.1)
				+ Items._get_equip_stat(Items.Pearl, Items.equip.pearl, "wis") * (1 + (Items.qtdEquip[Items.equip.pearl]-1) * 0.1))
			"res": 
				stats.res = (res + Items._get_equip_stat(Items.Breastplate, Items.equip.breastplate, "res") * (1 + (Items.qtdEquip[Items.equip.breastplate]-1) * 0.1)
				+ Items._get_equip_stat(Items.Helmet, Items.equip.helmet, "res") * (1 + (Items.qtdEquip[Items.equip.helmet]-1) * 0.1))
			"lee": 
				stats.lee = (Items._get_equip_stat(Items.Gloves, Items.equip.gloves, "lee") * (1 + (Items.qtdEquip[Items.equip.gloves]-1) * 0.1)
				+ Items._get_equip_stat(Items.Bracelet, Items.equip.bracelet, "lee") * (1 + (Items.qtdEquip[Items.equip.bracelet]-1) * 0.1))
			"crd": 
				stats.crd = (crd + Items._get_equip_stat(Items.Shoes, Items.equip.shoes, "crd") * (1 + (Items.qtdEquip[Items.equip.shoes]-1) * 0.1)
				+ Items._get_equip_stat(Items.Sword, Items.equip.sword, "crd") * (1 + (Items.qtdEquip[Items.equip.sword]-1) * 0.1))
			"red": 
				stats.red = (Items._get_equip_stat(Items.Pants, Items.equip.pants, "red") * (1 + (Items.qtdEquip[Items.equip.pants]-1) * 0.1)
				+ Items._get_equip_stat(Items.Shield, Items.equip.shield, "red") * (1 + (Items.qtdEquip[Items.equip.shield]-1) * 0.1))
			"max_hp": 
				stats.max_hp = int(maxHP + Items._get_equip_stat(Items.Helmet, Items.equip.helmet, "hp") * (1 + (Items.qtdEquip[Items.equip.helmet]-1) * 0.1)
				+ Items._get_equip_stat(Items.Necklace, Items.equip.necklace, "hp") * (1 + (Items.qtdEquip[Items.equip.necklace]-1) * 0.1))

func _att_health(health):
	hp =  int(health - ( Items._get_equip_stat(Items.Helmet, Items.equip.helmet, "hp") * (1 + (Items.qtdEquip[Items.equip.helmet]-1) * 0.1)
				+ Items._get_equip_stat(Items.Necklace, Items.equip.necklace, "hp") * (1 + (Items.qtdEquip[Items.equip.necklace]-1) * 0.1)))
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
	
	floaty_text.position = Vector2(0, -170)
	floaty_text.velocity = Vector2(rand_range(-50, 50), -100)
	floaty_text.modulate = Color(rand_range(0.7, 1), rand_range(0.7, 1), rand_range(0.7, 1), 1.0)
	
	floaty_text.text = damage
	if damage > 0:
		floaty_text.text = "+" + floaty_text.text
	
	add_child(floaty_text)
