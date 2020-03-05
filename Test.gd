extends Control

onready var result = $Panel/Result
onready var generator = $ShaderToImage
onready var multiplier = $Panel/Multiplier
onready var type = $Panel/NoiseType
onready var time = $Panel/Time
onready var mod1 = $Panel/Mod1
onready var mod2 = $Panel/Mod2

var enable_time = false

var getted_image

var example_type = [
	{
		"name" : "Type1",
		"material" : preload("ExampleShaders/ShaderToImage_Type1.material"),
		"args" : ["time"]
	},
	{
		"name" : "Type2",
		"material" : preload("ExampleShaders/ShaderToImage_Type2.material"),
		"args" : ["time", "mod1"]
	},
	{
		"name" : "Type3",
		"material" : preload("ExampleShaders/ShaderToImage_Type3.material"),
		"args" : ["time"]
	},
	{
		"name" : "Type4",
		"material" : preload("ExampleShaders/ShaderToImage_Type4.material"),
		"args" : ["time", "mod1"]
	},
	{
		"name" : "Type5",
		"material" : preload("ExampleShaders/ShaderToImage_Type5.material"),
		"args" : ["time", "mod1"]
	},
	{
		"name" : "Type6",
		"material" : preload("ExampleShaders/ShaderToImage_Type6.material"),
		"args" : ["time"]
	},
	{
		"name" : "Type7",
		"material" : preload("ExampleShaders/ShaderToImage_Type7.material"),
		"args" : ["mod1", "mod2"]
	},
	{
		"name" : "Type8",
		"material" : preload("ExampleShaders/ShaderToImage_Type8.material"),
		"args" : ["time"]
	},
	{
		"name" : "Type9",
		"material" : preload("ExampleShaders/ShaderToImage_Type9.material"),
		"args" : ["time", "mod1"]
	},
]

func build_noise_type():
	for _type in generator.get_type_list():
		var name = _type.name
		name += " ("
		for arg in _type.args:
			name+=arg+", "
		name += ")"
		type.add_item(name) 
	pass

func _ready():
	for ex in example_type:
		generator.add_custom_type(ex.name, ex.material, ex.args)
	build_noise_type();

func _process(_delta):
	if enable_time:
		time.text = str(OS.get_ticks_msec()/1000.0)
	pass

func _on_Button_pressed():
	generator.multiplier = multiplier.value
	generator.type = type.get_selected_id()
	generator.time = int(time.text)
	generator.mod1 = mod1.value
	generator.mod2 = mod2.value
	
	generator.generate_image()
	yield(generator, "generated")
	getted_image = generator.get_image()
	
	var text = ImageTexture.new()
	text.create_from_image(getted_image)
	result.texture = text


func _on_EnableTime_pressed():
	enable_time=!enable_time
	pass # Replace with function body.



func _on_Save_as_pressed():
	$Panel/FileDialog.popup()
	pass # Replace with function body.


func _on_FileDialog_file_selected(path):
	if getted_image:
		getted_image.save_png(path)
	pass # Replace with function body.
