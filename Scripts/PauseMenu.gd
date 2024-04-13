extends Control

func _ready():
	pass

func resume():
	get_tree().paused = false

func pause():
	get_tree().paused = true

func testEsc():
	if Input.is_action_just_pressed("Pause") and get_tree().paused == false:
		show()
		pause()
	elif Input.is_action_just_pressed("Pause") and get_tree().paused == true:
		hide()
		resume()

func _on_quit_pressed():
	get_tree().quit()
	
func _on_resume_pressed():
	hide()
	resume()

func _process(_delta):
	testEsc()
