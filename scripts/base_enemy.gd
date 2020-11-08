extends Node
class_name base_enemy

var inimigos = ["ancient", "porco", "anubis", "statue"]
var rng = RandomNumberGenerator.new()

var enemies = {
	"viking_stats" : {
		HP = 200,
		Attack = 30,
		Defense = 20,
		Agility = 10,
		Critical = 5,
		Wisdom = 100,
		res = 10
	},
	"ancient_stats" : {
		HP = 100,
		Attack = 20,
		Defense = 10,
		Agility = 10,
		Critical = 3.5,
		Wisdom = 10,
		res = 20
	},
	"porco_stats" : {
		HP = 100,
		Attack = 20,
		Defense = 12,
		Agility = 5,
		Critical = 5,
		Wisdom = 10,
		res = 20
	},
	"manticore_stats" : {
		HP = 200,
		Attack = 80,
		Defense = 60,
		Agility = 30,
		Critical = 1,
		Wisdom = 200,
		res = 5
	},
	"anubis_stats" : {
		HP = 100,
		Attack = 50,
		Defense = 20,
		Agility = 30,
		Critical = 5,
		Wisdom = 30,
		res = 20
	},
	"statue_stats" : {
		HP = 120,
		Attack = 40,
		Defense = 50,
		Agility = 15,
		Critical = 10,
		Wisdom = 30,
		res = 20
	},
}

var drops = {
	"viking_drop" : {
		drop1 = ["Nice Helmet", 25, "Helmet"],
		drop2 = ["Nice Sword", 50, "Sword"],
		drop3 = ["Nice Gloves", 75, "Gloves"],
		drop4 = ["Nice Shield", 99, "Shield"],
		drop5 = ["Pearl +1", 100, "Pearl"]
	},
	"ancient_drop" : {
		drop1 = ["Nice Helmet", 25, "Helmet"],
		drop2 = ["Nice Shoes", 50, "Shoes"],
		drop3 = ["Nice Gloves", 75, "Gloves"],
		drop4 = ["Nice Bracelet", 99, "Bracelet"],
		drop5 = ["Pearl", 100, "Pearl"]
	},
	"porco_drop" : {
		drop1 = ["Nice Sword", 25, "Sword"],
		drop2 = ["Nice Breastplate", 50, "Breastplate"],
		drop3 = ["Nice Necklace", 75, "Necklace"],
		drop4 = ["Nice Shield", 99, "Shield"],
		drop5 = ["Pearl", 100, "Pearl"]
	},
	"manticore_drop" : {
		drop1 = ["Nice Helmet +1", 25, "Helmet"],
		drop2 = ["Nice Shoes +1", 50, "Shoes"],
		drop3 = ["Nice Gloves +1", 75, "Gloves"],
		drop4 = ["Nice Bracelet +1", 99, "Bracelet"],
		drop5 = ["Pearl +2", 100, "Pearl"]
	},
	"anubis_drop" : {
		drop1 = ["Nice Helmet", 25, "Helmet"],
		drop2 = ["Nice Shield", 50, "Shield"],
		drop3 = ["Pearl", 75, "Pearl"],
		drop4 = ["Nice Necklace +1", 99, "Necklace"],
		drop5 = ["Pearl +1", 100, "Pearl"]
	},
	"statue_drop" : {
		drop1 = ["Nice Sword", 25, "Sword"],
		drop2 = ["Nice Gloves", 50, "Gloves"],
		drop3 = ["Pearl", 75, "Pearl"],
		drop4 = ["Nice Breastplate +1", 99, "Breastplate"],
		drop5 = ["Pearl +1", 100, "Pearl"]
	},
}

func _get_enemy(mapa):
	rng.randomize()
	var my_random_number
	match mapa:
		1: my_random_number = rng.randi_range(0, 1)
		2: my_random_number = rng.randi_range(2, 3)
	return BaseEnemy.inimigos[my_random_number]


func _get_boss(mapa):
	match mapa:
		1: return "viking"
		2: return "manticore"

func _get_anim(enemy, move):
	match move:
		"idle":
			var idle = enemy + "_idle"
			return idle
		"walk":
			var walk = enemy + "_walk"
			return walk
		"death":
			var death = enemy + "_dead"
			return death
		"hurt":
			var hurt = enemy + "_hurt"
			return hurt
		"battle":
			rng.randomize()
			var random_number = rng.randi_range(1, 2)
			var battle = enemy + "_battle" + String(random_number)
			return battle

func _get_stats(enemy, stat):
	if (stat == "Critical Resis."):
		stat = "res"
	var aux = enemy + "_stats"
	var values = BaseEnemy.enemies.get(aux)
	return values[stat]

func _get_drop(enemy):
	var dic = enemy + "_drop"
	var value = BaseEnemy.drops.get(dic)
	rng.randomize()
	var random_number = rng.randi_range(1, 100)
	if (random_number <= value.drop1[1]):
		return value.drop1
	elif (value.drop1[1] < random_number && random_number <= value.drop2[1]):
		return value.drop2
	elif (value.drop2[1] < random_number && random_number <= value.drop3[1]):
		return value.drop3
	elif (value.drop3[1] < random_number && random_number <= value.drop4[1]):
		return value.drop4
	elif (value.drop4[1] < random_number && random_number <= value.drop5[1]):
		return value.drop5
