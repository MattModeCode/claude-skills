extends Node
## TEMPORARY README capture harness (create-readme skill, Godot path).
##
## Drop this into `tools/`, register it as a temporary autoload in
## project.godot, run the game HEADED once, then DELETE both this file and the
## autoload line. It is not part of the shipped game.
##
##   [autoload]
##   ...existing autoloads...
##   CaptureHarness="*res://tools/capture_screens.gd"
##
## Run stills:  Godot --path .
## Run movie:   Godot --path . --write-movie <scratch>/clip.avi --fixed-fps 60 -- movie
##
## Why an autoload and not a scene: SceneRouter/change_scene_to_file frees the
## current scene on every navigation, so a harness that lived in a scene would
## be destroyed the moment it navigated. An autoload persists across scene
## changes, so it can drive the whole tour from one _ready() coroutine.
##
## ADAPT PER PROJECT (search "EDIT:"):
##  - screen scene paths + how you navigate to them (this uses a SceneRouter
##    autoload with goto_scene/goto_scene_pushed; use your own navigation API);
##  - how the app receives its data before a screen can render (here: a
##    PlaySession autoload holding a chart list + a "clean-capture" autoplay
##    mod). Replace with your project's real data handoff + demo/seeded state;
##  - settle durations, if your screens need more/less time to animate in.

const OUT_DIR: String = "res://docs/screenshots/"           # EDIT: output dir
const SHOWCASE_ITEM: String = "res://songs/example/hard.oct" # EDIT: the "thing" every screen shows

# EDIT: your real screen scene paths.
const HERO_SCENE: String = "res://game/gameplay.tscn"
const SCREENS := {
	"library": "res://game/song_select.tscn",
	"editor": "res://editor/editor_main.tscn",
	"community": "res://ui/map_hub.tscn",
}

const MOVIE_DURATION_SEC: float = 10.0


func _ready() -> void:
	if OS.get_cmdline_user_args().has("movie"):
		await _run_movie()
	else:
		await _run_stills()
	print("capture: done")
	get_tree().quit()


# ---------------------------------------------------------------------------
# Stills
# ---------------------------------------------------------------------------

func _run_stills() -> void:
	# Let boot (autoloads, first scene) settle before the first navigation.
	await get_tree().create_timer(1.0).timeout

	for name in SCREENS:
		# EDIT: your navigation call. goto_scene = hard jump to a hub screen.
		SceneRouter.goto_scene(SCREENS[name])
		await get_tree().create_timer(1.0).timeout
		await _save(name + ".png")

	await _capture_hero()


## The core-loop hero shot. EDIT: set up whatever data your main screen needs,
## and enable a clean-capture mode so the shot looks flawless (here: autoplay).
func _capture_hero() -> void:
	PlaySession.chart_list = [SHOWCASE_ITEM] as Array[String]
	PlaySession.chart_index = 0
	PlaySession.mods = GameplayMods.new()
	PlaySession.mods.autoplay = true              # clean-capture mode
	SceneRouter.goto_scene_pushed(HERO_SCENE)
	# Long enough for the loop to look busy (notes falling, combo climbing).
	await get_tree().create_timer(8.0).timeout
	await _save("gameplay.png")


## HONESTY NOTE: if your demo/autoplay mode fakes or blanks real values (Octet's
## autoplay zeroes score + marks the run UNRANKED), do NOT screenshot a results/
## summary screen straight out of it -- it will look broken. Instead drive the
## real system through its public API to a genuine, flattering state. Example:
##   var engine := JudgeEngine.new(chart, Config.gameplay, Config.scoring, GameplayMods.new())
##   for note in sorted_notes:                 # hand-timed perfect hits
##       engine.update(float(note.time_ms))
##       engine.on_lane_press(note.lane, float(note.time_ms))
##   PlaySession.last_engine = engine          # real, ranked SS -- then capture


func _save(file_name: String) -> void:
	# Two frames so the just-navigated screen has been through a full draw.
	await get_tree().process_frame
	await get_tree().process_frame
	var image := get_viewport().get_texture().get_image()
	var err := image.save_png(OUT_DIR + file_name)
	if err != OK:
		push_error("capture: failed to save %s (error %d)" % [file_name, err])
	else:
		print("capture: saved %s" % file_name)


# ---------------------------------------------------------------------------
# Movie -- run alongside Godot's --write-movie / --fixed-fps flags
# ---------------------------------------------------------------------------

func _run_movie() -> void:
	await get_tree().create_timer(0.5).timeout
	PlaySession.chart_list = [SHOWCASE_ITEM] as Array[String]
	PlaySession.chart_index = 0
	PlaySession.mods = GameplayMods.new()
	PlaySession.mods.autoplay = true
	SceneRouter.goto_scene_pushed(HERO_SCENE)
	await get_tree().create_timer(MOVIE_DURATION_SEC).timeout
