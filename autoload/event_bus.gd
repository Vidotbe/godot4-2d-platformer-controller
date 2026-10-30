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

@warning_ignore("unused_signal")
signal start_challenge

@warning_ignore("unused_signal")
signal diamond_key_get

@warning_ignore("unused_signal")
signal next_challenge

@warning_ignore("unused_signal")
signal next_challenge_fail

@warning_ignore("unused_signal")
signal intermission_good

@warning_ignore("unused_signal")
signal intermission_fail

@warning_ignore("unused_signal")
signal check_lives

@warning_ignore("unused_signal")
signal display_prompt
