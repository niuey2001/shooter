extends CanvasLayer


func change_health(value: int):
	var tween = create_tween()
	tween.tween_property($Control/TextureProgressBar, 'value', value, 0.3)
