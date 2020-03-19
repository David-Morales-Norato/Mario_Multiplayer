extends RichTextLabel

var board = ["","","","","",""]
const size = 6
const cooldown = 1200
var time = 0

func updateText():
	text = ""
	for i in range(size):
		text=text+board[i]
		text=text+"\n"
	time = cooldown

func addEntry(entry):
	for i in range(size-1):
		board[i] = board[i+1]
	
	board[5] = entry
	updateText()

func _process(delta):
	if time > 0:
		set_visible(true)
		time-=1
	else:
		set_visible(false)
