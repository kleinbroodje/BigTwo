extends CanvasLayer

func _process(delta: float) -> void:
	get_node("FPS").text = "FPS: " + str(int(Engine.get_frames_per_second()))
