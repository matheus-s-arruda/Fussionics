extends Node2D


var element: Element

@onready var debuffs = $PanelContainer/MarginContainer/VBoxContainer/debuffs
@onready var buffs = $PanelContainer/MarginContainer/VBoxContainer/buffs
@onready var panel_container = $PanelContainer


func _init():
	Gameplay.passive_status = self


func set_element(_element: Element):
	element = _element
	
	var active: bool = element != null
	set_process(active)
	
	if active:
		debuffs.get_children().map(func(c): c.visible = false)
		buffs  .get_children().map(func(c): c.visible = false)
		
		_size_compare(debuffs.get_child_count(), element.debuffs.size(), debuffs)
		_size_compare(buffs.get_child_count(), element.buffs.size(), buffs)
		
		var has_debuff: bool
		var count_debuff := 0
		for _debuff in element.debuffs:
			debuffs.get_child(count_debuff).load_passive(element.debuffs[_debuff])
			debuffs.get_child(count_debuff).visible = true
			count_debuff += 1
			has_debuff = true
		
		var has_buff: bool
		var count_buff := 0
		for _buff in element.buffs:
			buffs.get_child(count_buff).load_passive(element.buffs[_buff])
			buffs.get_child(count_buff).visible = true
			count_buff += 1
			has_buff = true
		
		visible = has_buff or has_debuff
		buffs.visible = has_buff
		debuffs.visible = has_debuff
	else:
		visible = false
	
	_recalcule_mid_position()


func _recalcule_mid_position():
	panel_container.position.x = -panel_container.size.x / 2.0


func _process(delta):
	if is_instance_valid(element):
		position = element.position + Vector2(40, 80)


func _unhandled_input(event):
	if (event.is_action("mouse_click") or event.is_action("ui_cancel")) and event.is_pressed():
		visible = false


func _notification(what: int):
	if what == NOTIFICATION_DRAG_BEGIN:
		visible = false


func _turn_machine_end_turn(player):
	visible = false


func _size_compare(childs: int, size: int, parent: Node):
	if childs < size:
		for i in abs(childs - size):
			parent.add_child(parent.get_child(0).duplicate())
