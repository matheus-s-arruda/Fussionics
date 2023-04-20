extends Control
class_name GuiMenu

enum State {
	MAIN_MENU, CAMPAIGN
}
const TRANSITION_TIME := 0.3

@export var Settings:Control

@onready var buttons = $Buttons
@onready var links = $MarginContainer
@onready var campaign = $campaign

var state: State

var buttons_tween: Tween
var campaign_tweem: Tween


func _modo_campanha_pressed():
#	buttons.get_children().map(func(c): c.disabled = true)
	
	if buttons_tween and buttons_tween.is_valid():
		buttons_tween.kill()
	
	buttons_tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	buttons_tween.tween_property(buttons, "position", Vector2(-400, buttons.position.y), TRANSITION_TIME)
	buttons_tween.parallel().tween_property(links, "position", Vector2(links.position.x, 1200), TRANSITION_TIME)
	buttons_tween.tween_property(campaign, "position", Vector2(30, campaign.position.y), TRANSITION_TIME)
	
	state = State.CAMPAIGN


func _input(event: InputEvent):
	if event.is_action_pressed("ui_cancel"):
		match state:
			State.CAMPAIGN:
				state == State.MAIN_MENU
				
				if buttons_tween and buttons_tween.is_valid():
					buttons_tween.kill()
				
				buttons_tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
				buttons_tween.tween_property(campaign, "position", Vector2(-500, campaign.position.y), TRANSITION_TIME)
				buttons_tween.tween_property(buttons, "position", Vector2(48, buttons.position.y), TRANSITION_TIME)
				buttons_tween.parallel().tween_property(links, "position", Vector2(links.position.x, 950), TRANSITION_TIME)


func _partida_rapida_pressed():
	get_tree().change_scene_to_file("res://scenes/world/arena.tscn")


func _galeriafussion_pressed():
	get_tree().change_scene_to_file("res://scenes/interface/periodic_table/table.tscn")


func _configuraes_pressed():
	Settings.visible = true


func _sairdo_jogo_pressed():
	#Se quiser pode colocar algum save
	get_tree().quit()


func _itch_pressed():
	OS.shell_open("https://itch.io/profile/atelie-yami")


func _insta_pressed():
	OS.shell_open("https://www.instagram.com/atelie.yami/")


func _twiter_pressed():
	OS.shell_open("https://twitter.com/AtelieYami")
