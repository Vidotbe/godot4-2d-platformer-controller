extends Node

@warning_ignore("unused_signal")
signal item_collected(item_type : String, item_value : int)

@warning_ignore("unused_signal")
signal skill_bought(value : int)

@warning_ignore("unused_signal")
signal update_checkpoint
var active_checkpoint = null

@warning_ignore("unused_signal")
signal key_time_limit

@warning_ignore("unused_signal")
signal door_opened

@warning_ignore("unused_signal")
signal player_respawn

@warning_ignore("unused_signal")
signal update_checkpoint_status

@warning_ignore("unused_signal")
signal reset_awareness


@warning_ignore("unused_signal")
signal on_all_diamonds
