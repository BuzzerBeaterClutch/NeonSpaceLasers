extends Node

var music_player : AudioStreamPlayer

func _ready():

	music_player = AudioStreamPlayer.new()

	add_child(music_player)

	music_player.bus = "Music"

func play_music(track: AudioStream):

	if music_player.stream == track and music_player.playing:
		return

	music_player.stream = track
	music_player.play()

func stop_music():

	music_player.stop()
