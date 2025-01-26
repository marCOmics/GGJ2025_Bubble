extends Node
#THIS IS A GLOBAL CLASS, used to access, load and save setting data

const SETTINGS_FILE_PATH = "user://ACTbeforeYouSINK.config"
enum INPUT_METHOD{
	GYROSCOPE = 0, #"gyroscope",
	TOUCH = 1,  #"touch",
}

var _input: INPUT_METHOD = INPUT_METHOD.GYROSCOPE
var _highscore: int #in levels

## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Settings.read_file()


#func _process(delta: float) -> void:
	#print("input: " + "gyroscope" if _input == INPUT_METHOD.GYROSCOPE else "touch")


func read_file() -> void:
	if not FileAccess.file_exists(SETTINGS_FILE_PATH):
		save_file(true)
		return # Error! We don't have a save to load.
	
	# Load the file line by line and process that dictionary to restore
	# the object it represents.
	var settingsFile = FileAccess.open(SETTINGS_FILE_PATH, FileAccess.READ)
	while settingsFile.get_position() < settingsFile.get_length():
		var jsonString = settingsFile.get_line()

		var json = JSON.new()
		var parse_result = json.parse(jsonString)
		if parse_result != OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", jsonString, " at line ", json.get_error_line())
			continue
	
		# Get the data from the JSON object.
		var node_data : Variant = json.data
		#if node_data.data == null:
			#return #ERROR
		
		for key in node_data.keys():
			match key:
				"input":
					_input = node_data[key]
				"highscore":
					_highscore = node_data[key]
				_:
					continue
			#new_object.set(key, node_data[key])


func save_file(p_initial: bool = false) -> void:
	var settingsFile = FileAccess.open(SETTINGS_FILE_PATH, FileAccess.WRITE)
	
	if p_initial == false:
		pass #TODO: Remove savefile
	
	var settingsFileContents = {
		"input": _input,
		"highscore" : _highscore,
	}
	
	var json_string = JSON.stringify(settingsFileContents)
	settingsFile.store_line(json_string)
	settingsFile.close()


func set_input_method(p_input : INPUT_METHOD) -> void:
	_input = p_input
	Settings.save_file()


func input_is_gyroscope() -> bool:
	return _input == INPUT_METHOD.GYROSCOPE


func add_highscore(p_level: int) -> void:
	if _highscore < p_level:
		_highscore = p_level
		save_file()


func get_highscore() -> int:
	return _highscore
