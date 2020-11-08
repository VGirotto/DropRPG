extends Control

onready var buttons = [get_node("GridH/GridV1/Button1"), get_node("GridH/GridV1/Button2"), get_node("GridH/GridV1/Button3"),
get_node("GridH/GridV2/Button1"), get_node("GridH/GridV2/Button2"), get_node("GridH/GridV2/Button3"),
get_node("GridH/GridV3/Button1"), get_node("GridH/GridV3/Button2"), get_node("GridH/GridV3/Button3")]
onready var parent = get_parent()

signal menu()


# Called when the node enters the scene tree for the first time.
func _ready():
	self.visible = false
	

func _on_Button_use_pressed(text, category):
	if text == "Exit":
		self.visible = false
		emit_signal("menu")
		return
	else:
		Items._set_equip(category.to_lower(), text)
		_on_Map_menuEquip(category)
		parent.hero._build_stats()
		parent.save_game()


func _on_Map_menuEquip(equipament):
	var i = 0
	for item in Items.inventory[equipament]:
		buttons[i].get_node("Label2").set_text(String(Items.qtdEquip[item]) + "x")
		buttons[i].set_text(item)
		buttons[i].button = equipament
		buttons[i].disabled = false
		if (Items.equip[equipament.to_lower()] == item):
			buttons[i].disabled = true
		buttons[i].get_node("Label").set_text(_get_equip_text(equipament, item))
		i += 1
		
	for y in range (i, 8):
		buttons[y].disabled = true
		buttons[y].set_text("")
		buttons[y].get_node("Label").set_text("")
		buttons[y].get_node("Label2").set_text("")
		buttons[y].button = ""
	self.visible = true
	
	for btt in $GridH/GridV1.get_children():
		if btt.is_connected("pressed", self, "_on_Button_use_pressed"):
			btt.disconnect("pressed", self, "_on_Button_use_pressed")
		btt.connect("pressed", self, "_on_Button_use_pressed", [btt.get_text(), btt.button])
	for btt in $GridH/GridV2.get_children():
		if btt.is_connected("pressed", self, "_on_Button_use_pressed"):
			btt.disconnect("pressed", self, "_on_Button_use_pressed")
		btt.connect("pressed", self, "_on_Button_use_pressed", [btt.get_text(), btt.button])
	for btt in $GridH/GridV3.get_children():
		if btt.is_connected("pressed", self, "_on_Button_use_pressed"):
			btt.disconnect("pressed", self, "_on_Button_use_pressed")
		btt.connect("pressed", self, "_on_Button_use_pressed", [btt.get_text(), btt.button])

func _get_equip_text(tipo, item):
	var text
	match tipo:
		"Sword":
			text = ("Atk: " + String(Items._get_equip_stat(Items.Sword, item, "atk") * (1 + (Items.qtdEquip[item]-1) * 0.1)) 
			+ " Cr. D.: " + String(Items._get_equip_stat(Items.Sword, item, "crd") * (1 + (Items.qtdEquip[item]-1) * 0.1)) )
		"Shoes":
			text = ("Agi: " + String(Items._get_equip_stat(Items.Shoes, item, "agi") * (1 + (Items.qtdEquip[item]-1) * 0.1)) 
			+ " Cr. D.: " + String(Items._get_equip_stat(Items.Shoes, item, "crd") * (1 + (Items.qtdEquip[item]-1) * 0.1)))
		"Pants":
			text = ("Agi: " + String(Items._get_equip_stat(Items.Pants, item, "agi") * (1 + (Items.qtdEquip[item]-1) * 0.1)) 
			+ " Ref.D.: " + String(Items._get_equip_stat(Items.Pants, item, "red") * (1 + (Items.qtdEquip[item]-1) * 0.1)))
		"Breastplate":
			text = ("Def: " + String(Items._get_equip_stat(Items.Breastplate, item, "def") * (1 + (Items.qtdEquip[item]-1) * 0.1)) 
			+ " Res: " + String(Items._get_equip_stat(Items.Breastplate, item, "res") * (1 + (Items.qtdEquip[item]-1) * 0.1)))
		"Gloves":
			text = ("Atk: " + String(Items._get_equip_stat(Items.Gloves, item, "atk") * (1 + (Items.qtdEquip[item]-1) * 0.1)) 
			+ " Cri: " + String(Items._get_equip_stat(Items.Gloves, item, "cri") * (1 + (Items.qtdEquip[item]-1) * 0.1)) 
			+ "\nLif. Lee.: " + String(Items._get_equip_stat(Items.Gloves, item, "lee") * (1 + (Items.qtdEquip[item]-1) * 0.1)))
		"Helmet":
			text = ("HP: " + String(Items._get_equip_stat(Items.Helmet, item, "hp") * (1 + (Items.qtdEquip[item]-1) * 0.1)) 
			+ "  Res: " + String(Items._get_equip_stat(Items.Helmet, item, "res") * (1 + (Items.qtdEquip[item]-1) * 0.1)))
		"Shield":
			text = ("Def: " + String(Items._get_equip_stat(Items.Shield, item, "def") * (1 + (Items.qtdEquip[item]-1) * 0.1)) 
			+ " Ref.D.: " + String(Items._get_equip_stat(Items.Shield, item, "red") * (1 + (Items.qtdEquip[item]-1) * 0.1)))
		"Necklace":
			text = ("HP: " + String(Items._get_equip_stat(Items.Necklace, item, "hp") * (1 + (Items.qtdEquip[item]-1) * 0.1)) 
			+ " Wis: " + String(Items._get_equip_stat(Items.Necklace, item, "wis") * (1 + (Items.qtdEquip[item]-1) * 0.1)))
		"Bracelet":
			text = ("Cri: " + String(Items._get_equip_stat(Items.Bracelet, item, "cri") * (1 + (Items.qtdEquip[item]-1) * 0.1)) 
			+ " Lif. Lee.: " + String(Items._get_equip_stat(Items.Bracelet, item, "lee") * (1 + (Items.qtdEquip[item]-1) * 0.1)))
		"Pearl":
			text = "Wis: " + String(Items._get_equip_stat(Items.Pearl, item, "wis") * (1 + (Items.qtdEquip[item]-1) * 0.1))
	
	return text


func _on_Map_attQtd(category, equip):
	Items._set_qtd(category, equip)
