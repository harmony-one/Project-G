extends CanvasLayer

@onready var player: Player = get_tree().get_first_node_in_group("player")

@onready var player_hp_bar: ProgressBar = %PlayerHPBar

func _ready() -> void:
	player_hp_bar.max_value = player.hp
	player.hp_changed.connect(_on_player_hp_changed)

func _on_player_hp_changed(new_hp: float):
	var tween: Tween = create_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	
	tween.tween_property(player_hp_bar, "value", new_hp, 0.5)
