extends Node
class_name items

signal addEquip(category, equip)

var inventory = {
	Shoes = ["Simple Shoes"],
	Pants = ["Simple Pants"],
	Breastplate = ["Simple Plate"],
	Gloves = ["Simple Gloves"],
	Helmet = ["Simple Helmet"],
	Sword = ["Weak Sword"],
	Shield = ["Weak Shield"],
	Necklace = ["Simple Necklace"],
	Bracelet = ["Simple Bracelet"],
	Pearl = ["Pearl"]
}

var equip = {
	shoes = "Simple Shoes",
	pants = "Simple Pants",
	breastplate = "Simple Plate",
	gloves = "Simple Gloves",
	helmet = "Simple Helmet",
	sword = "Weak Sword",
	shield = "Weak Shield",
	necklace = "Simple Necklace",
	bracelet = "Simple Bracelet",
	pearl = "Pearl"
}


var Shoes = {
	"Simple Shoes" : {
		agi = 2,
		crd = 10
	},
	"Nice Shoes" : {
		agi = 10,
		crd = 20
	},
	"Nice Shoes +1" : {
		agi = 20,
		crd = 40
	}
}

var Pants = {
	"Simple Pants" : {
		agi = 2,
		red = 0
	},
	"Nice Pants" : {
		agi = 10,
		red = 1
	},
	"Nice Pants +1" : {
		agi = 20,
		red = 2
	}
}

var Breastplate = {
	"Simple Plate" : {
		def = 1,
		res = 1
	},
	"Nice Breastplate" : {
		def = 10,
		res = 2
	},
	"Nice Breastplate +1" : {
		def = 20,
		res = 5
	}
}

var Gloves = {
	"Simple Gloves" : {
		atk = 1,
		cri = 1,
		lee = 0
	},
	"Nice Gloves" : {
		atk = 8,
		cri = 2,
		lee = 1
	},
	"Nice Gloves +1" : {
		atk = 16,
		cri = 4,
		lee = 2
	}
}

var Helmet = {
	"Simple Helmet" : {
		hp = 5,
		res = 1
	},
	"Nice Helmet" : {
		hp = 20,
		res = 2
	},
	"Nice Helmet +1" : {
		hp = 40,
		res = 4
	}
}

var Sword = {
	"Weak Sword" : {
		atk = 10,
		crd = 10
	},
	"Nice Sword" : {
		atk = 15,
		crd = 20
	},
	"Nice Sword +1" : {
		atk = 30,
		crd = 40
	}
}

var Shield = {
	"Weak Shield" : {
		def = 10,
		red = 1
	},
	"Nice Shield" : {
		def = 20,
		red = 3
	},
	"Nice Shield +1" : {
		def = 40,
		red = 6
	}
}

var Necklace = {
	"Simple Necklace" : {
		hp = 5,
		wis = 1
	},
	"Nice Necklace" : {
		hp = 15,
		wis = 5
	},
	"Nice Necklace +1" : {
		hp = 30,
		wis = 10
	}
}

var Bracelet = {
	"Simple Bracelet" : {
		cri = 2,
		lee = 0
	},
	"Nice Bracelet" : {
		cri = 4,
		lee = 2
	},
	"Nice Bracelet +1" : {
		cri = 6,
		lee = 4
	}
}

var Pearl = {
	"Pearl" : {
		wis = 2
	},
	"Pearl +1" : {
		wis = 10
	},
	"Pearl +2" : {
		wis = 20
	}
}

var qtdEquip = {
	"Simple Shoes" : 1,
	"Nice Shoes" : 0,
	"Nice Shoes +1" : 0,
	"Simple Pants" : 1,
	"Nice Pants" : 0,
	"Nice Pants +1" : 0,
	"Simple Plate" : 1,
	"Nice Breastplate" : 0,
	"Nice Breastplate +1" : 0,
	"Simple Gloves" : 1,
	"Nice Gloves" : 0,
	"Nice Gloves +1" : 0,
	"Simple Helmet" : 1,
	"Nice Helmet" : 0,
	"Nice Helmet +1" : 0,
	"Weak Sword" : 1,
	"Nice Sword" : 0,
	"Nice Sword +1" : 0,
	"Weak Shield" : 1,
	"Nice Shield" : 0,
	"Nice Shield +1" : 0,
	"Simple Necklace" : 1,
	"Nice Necklace" : 0,
	"Nice Necklace +1" : 0,
	"Simple Bracelet" : 1,
	"Nice Bracelet" : 0,
	"Nice Bracelet +1" : 0,
	"Pearl" : 1,
	"Pearl +1" : 0,
	"Pearl +2" : 0
}

func _get_equip_stat(tipo, nome, stat):
	var value = tipo.get(nome)
	return value[stat]

func _set_equip(category, name):
	equip[category] = name
	

func _set_qtd(category, name):
	var qtd = qtdEquip[name]
	if (qtd < 5):
		qtdEquip[name] += 1
	
func _add_equip(category, name):
	inventory[category].append(name)
	var qtd = qtdEquip[name]
	if (qtd < 5):
		qtdEquip[name] += 1

func _check_exist(category, equip):
	for item in inventory[category]:
		if (item == equip):
			return true
	emit_signal("addEquip", category, equip)
	_add_equip(category, equip)
	

func _get_tipo(tipo):
	match tipo:
		"Sword":
			return Sword
		"Shoes":
			return Shoes
		"Pants":
			return Pants
		"Breastplate":
			return Breastplate
		"Gloves":
			return Gloves
		"Helmet":
			return Helmet
		"Shield":
			return Shield
		"Necklace":
			return Necklace
		"Bracelet":
			return Bracelet
		"Pearl":
			return Pearl

