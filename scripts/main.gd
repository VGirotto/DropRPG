extends Node2D

export (int) var mapa = 1
const SAVE_PATH = "user://savegame.save"

signal start_enemy()
signal start_boss()
signal menuEquip(equip)
signal attQtd(category, equip)
signal points(hero)

onready var base_enemy = get_node("enemy")
onready var boss = get_node("boss")
onready var hero = get_node("player")
onready var dialogBattle = get_node("dialogBattle")
onready var menuEquip = get_node("Equip")

var rng = RandomNumberGenerator.new()
var bossOk = false
var loadExist = false
var gameover = false

# Called when the node enters the scene tree for the first time.
func _ready():
	load_game()
	rng.randomize()
	var random_music = rng.randi_range(0, 1)
	if(random_music == 0):
		$Soundtrack.playing = true
		$Soundtrack2.playing = false
	else:
		$Soundtrack2.playing = true
		$Soundtrack.playing = false
	hero._build_stats()
	for button in $dialogBox/buttons.get_children():
		button.connect("pressed", self, "_on_Button_pressed", [button.button])
	for button in $Menu/GridH/GridV1.get_children():
		button.connect("pressed", self, "_on_Button_Menu_pressed", [button.get_text()])
	for button in $Menu/GridH/GridV2.get_children():
		button.connect("pressed", self, "_on_Button_Menu_pressed", [button.get_text()])
	for button in $Menu/GridH/GridV3.get_children():
		button.connect("pressed", self, "_on_Button_Menu_pressed", [button.get_text()])
	$dialogBattle/Button.connect("pressed", self, "_on_Button_X_pressed")

func _on_Button_pressed(button):
	if (button == "menu"):
		$dialogBox.visible = false
		$Menu.visible = true
		return
	elif(button == "boss"):
		$dialogBox.visible = false
		emit_signal("start_boss")
		return
	else:
		$dialogBox.visible = false
		emit_signal("start_enemy")
		return

func _on_Button_Menu_pressed(button):
	if button == "Stat Points":
		$Stats.visible = true
		$Menu.visible = false
		emit_signal("points", hero)
		return
	elif button == "Exit Menu":
		$dialogBox.visible = true
		$Menu.visible = false
		return
	else:
		emit_signal("menuEquip", button)
		$Menu.visible = false


func _on_enemy_batalha(enemy_name, bossOn):
	hero._build_stats()
	var enemy
	if(bossOn):
		enemy = boss
	else:
		enemy = base_enemy
	var heroHP = hero.stats["HP"]
	var enemyHP = BaseEnemy._get_stats(enemy_name, "HP")
	enemy.anim.play(BaseEnemy._get_anim(enemy_name, "battle"))
	hero.anim.play("attack1")
	
	$AttackAudio.playing = true
	while (heroHP > 0 && enemyHP > 0):
		#hero attack
		var heroAtk
		rng.randomize()
		var random_num = rng.randi_range(1, 100/(hero.stats["Critical"] * (100 - BaseEnemy._get_stats(enemy_name, "res"))/100))
		if (random_num == 1): #critical
			heroAtk = int(hero.stats["Attack"] + ((hero.stats["crd"]/100) * hero.stats["Attack"]))
		else:
			heroAtk = hero.stats["Attack"]
		
		#enemy attack
		var enemyAtk
		rng.randomize()
		random_num = rng.randi_range(1, 100/(BaseEnemy._get_stats(enemy_name, "Critical") * (100 - hero.stats["res"])/100))
		if (random_num == 1): #critical
			enemyAtk = int(BaseEnemy._get_stats(enemy_name, "Attack") + ((50/100) * BaseEnemy._get_stats(enemy_name, "Attack")))
		else:
			enemyAtk = BaseEnemy._get_stats(enemy_name, "Attack")
		
		#enemy defense
		rng.randomize() 
		if ((BaseEnemy._get_stats(enemy_name, "Agility")/10) != 0):
			random_num = rng.randi_range(1, 100/ (BaseEnemy._get_stats(enemy_name, "Agility")/10))
		else:
			random_num = 0
		if (random_num != 1): #nao esquivou
			if (heroAtk - BaseEnemy._get_stats(enemy_name, "Defense") > 0):
				enemyHP = enemyHP - int(heroAtk - BaseEnemy._get_stats(enemy_name, "Defense"))
				enemy._on_got_damage(int(-(heroAtk - BaseEnemy._get_stats(enemy_name, "Defense"))))
				if (hero.stats["lee"] > 0): 
					heroHP = ceil(heroHP + ((heroAtk - BaseEnemy._get_stats(enemy_name, "Defense")) * hero.stats["lee"]/100))
					hero._on_got_damage2(ceil((heroAtk -  BaseEnemy._get_stats(enemy_name, "Defense")) * hero.stats["lee"]/100))
				enemy.anim.play(BaseEnemy._get_anim(enemy_name, "hurt"))
			else:
				if ((enemyAtk - hero.stats["Defense"]) <= 0): #without damage
					enemyAtk = int(BaseEnemy._get_stats(enemy_name, "Attack") + ((50/100) * BaseEnemy._get_stats(enemy_name, "Attack")))
					enemyHP = enemyHP - int(heroAtk - BaseEnemy._get_stats(enemy_name, "Defense"))
					enemy._on_got_damage(int(-(heroAtk - BaseEnemy._get_stats(enemy_name, "Defense"))))
					if (hero.stats["lee"] > 0): 
						heroHP = ceil(heroHP + ((heroAtk - BaseEnemy._get_stats(enemy_name, "Defense")) * hero.stats["lee"]/100))
						hero._on_got_damage2(ceil((heroAtk -  BaseEnemy._get_stats(enemy_name, "Defense")) * hero.stats["lee"]/100))
					enemy.anim.play(BaseEnemy._get_anim(enemy_name, "hurt"))
					
					enemyAtk = int(BaseEnemy._get_stats(enemy_name, "Attack") + ((50/100) * BaseEnemy._get_stats(enemy_name, "Attack")))
		#hero defense
		rng.randomize()
		random_num = rng.randi_range(1, 100/(hero.stats["Agility"]/10))
		if (random_num != 1): #nao esquivou
			if ((enemyAtk - hero.stats["Defense"]) > 0):
				heroHP = heroHP - (enemyAtk - hero.stats["Defense"])
				hero._on_got_damage(-(enemyAtk - hero.stats["Defense"]))
				hero.anim.play("hurt")
				if hero.stats["red"] > 0:
					enemyHP = int(enemyHP - ceil(enemyAtk * hero.stats["red"]/100))
					enemy._on_got_damage2(floor(-(enemyAtk  * hero.stats["red"]/100)))
		yield(get_tree().create_timer(0.2), "timeout")
		
		enemy._att_health(enemyHP, enemy_name)
		if (enemyHP <= 0):
			break
		if (heroHP <= hero.stats["max_hp"]):
			hero._att_health(heroHP)
		if (heroHP <= 0):
			break
		
		hero.anim.play("attack2")
		enemy.anim.play(BaseEnemy._get_anim(enemy_name, "battle"))
		#$AttackAudio.playing = false
		yield(get_tree().create_timer(0.8), "timeout")
	
	$AttackAudio.playing = false
	if (heroHP <= 0 && enemyHP > 0):
		hero._build_stats()
		save_game()
		hero.anim.play("dead")
		enemy.anim.play(BaseEnemy._get_anim(enemy_name, "idle"))
		$dialogBattle/NinePatchRect/MarginContainer/Label.set_text("You died! \nNow you can comeback with all \nyour current equips.\n Click the X to restart.")
		dialogBattle.visible = true
		gameover = true
		return
	
	#venceu -> ganha exp e item -> se upar ganha pontos para distribuir
	hero.anim.play("idle")
	enemy.anim.play(BaseEnemy._get_anim(enemy_name, "death"))
	
	#informacoes vitoria
	dialogBattle.visible = true
	hero.maxHP -= 10
	var itemDrop = BaseEnemy._get_drop(enemy_name)
	if (Items._check_exist(itemDrop[2], itemDrop[0])):
		var type = Items._get_tipo(itemDrop[2])
		emit_signal("attQtd", type, itemDrop[0])
	
	var addExp = float(BaseEnemy._get_stats(enemy_name, "Wisdom") + (BaseEnemy._get_stats(enemy_name, "Wisdom") * (float(hero.stats["Wisdom"]) / 100)))
	hero.experience += addExp
	
	#atualizar status
	hero._build_stats()
	$dialogBattle/NinePatchRect/MarginContainer/Label.set_text("Experience: +" + String(addExp) + 
	"\nLevel: " + String(hero.stats["Level"]) + "\nDrop: " + itemDrop[0] + "\n-10 MaxHP -- New MaxHP = " + String(hero.stats["max_hp"]))
	
	save_game()
	
	
	if (bossOn):
		bossOk = true
		

func _on_Button_X_pressed():
	#encerrar HUDs
	if gameover:
		if self.get_path() == "/root/Map":
			get_tree().reload_current_scene()
		else:
			get_tree().change_scene("res://Cenas/Map.tscn")
		
	else:
		base_enemy.visible = false
		dialogBattle.visible = false
		if bossOk:
			bossOk = false
			get_tree().change_scene("res://Cenas/maps/Map" + String(mapa+1) + ".tscn")
		$dialogBox.visible = true

func save_game():
	var save_dict = {}
	save_dict["level"] = hero.level
	save_dict["experience"] = hero.experience
	save_dict["hp"] = hero.hp
	save_dict["hp with items"] = hero.stats["HP"]
	save_dict["atk"] = hero.atk
	save_dict["def"] = hero.def
	save_dict["agi"] = hero.agi
	save_dict["maxHP"] = hero.maxHP
	save_dict["points"] = hero.points
	
	var save_file = File.new()
	var err = save_file.open_encrypted_with_pass(SAVE_PATH, File.WRITE, "marrie&pierre")
	#save_file.open(SAVE_PATH, File.WRITE)
	
	save_file.store_line(to_json(save_dict))
	save_file.store_line(to_json(Items.inventory))
	save_file.store_line(to_json(Items.equip))
	save_file.store_line(to_json(Items.qtdEquip))
	save_file.close()

func load_game():
	var save_game = File.new()
	
	if save_game.file_exists(SAVE_PATH):
		loadExist = true
		var err = save_game.open_encrypted_with_pass(SAVE_PATH, File.READ, "marrie&pierre")
		#save_game.open(SAVE_PATH, File.READ)
		#while save_game.get_position() < save_game.get_len():
		
		var data = parse_json(save_game.get_line())
		
		#check new map or new game
		if data["hp with items"] <= 0:
			#the player died => new game =>load only the items
			data = parse_json(save_game.get_line()) #inventory
			for i in data:
				Items.inventory[i] = data[i]
			
			data = parse_json(save_game.get_line()) #equip
			for i in data:
				Items.equip[i] = data[i]
			
			data = parse_json(save_game.get_line()) #qtdEquip
			for i in data:
				Items.qtdEquip[i] = data[i]
		
		else: #change map => load everything
			hero.level = data["level"]
			hero.experience = data["experience"]
			hero.hp = data["hp"]
			hero.atk = data["atk"]
			hero.def = data["def"]
			hero.agi = data["agi"]
			hero.maxHP = data["maxHP"]
			hero.points = data["points"]
			
			data = parse_json(save_game.get_line()) #inventory
			for i in data:
				Items.inventory[i] = data[i]
			
			data = parse_json(save_game.get_line()) #equip
			for i in data:
				Items.equip[i] = data[i]
			
			data = parse_json(save_game.get_line()) #qtdEquip
			for i in data:
				Items.qtdEquip[i] = data[i]
	save_game.close()


func _on_Delete_save():
	var dir = Directory.new()
	dir.remove("user://savegame.save")


func _on_Soundtrack_finished():
	$Soundtrack2.playing = true


func _on_Soundtrack2_finished():
	$Soundtrack.playing = true


func _on_Attack_Audio_finished():
	$AttackAudio.playing = false


func _on_Minus_pressed():
	$Soundtrack.set_volume_db($Soundtrack.get_volume_db() - 4)
	$Soundtrack2.set_volume_db($Soundtrack2.get_volume_db() - 4)
	$AttackAudio.set_volume_db($AttackAudio.get_volume_db() - 4)


func _on_More_pressed():
	$Soundtrack.set_volume_db($Soundtrack.get_volume_db() + 4)
	$Soundtrack2.set_volume_db($Soundtrack2.get_volume_db() + 4)
	$AttackAudio.set_volume_db($AttackAudio.get_volume_db() + 4)
