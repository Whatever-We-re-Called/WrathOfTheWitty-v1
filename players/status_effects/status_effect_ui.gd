extends HBoxContainer

func init(icon: Texture2D, value: int, color: Color, hide_text: bool):
	var texture_rect = $TextureRect
	var label = $Label
	
	texture_rect.texture = icon
	texture_rect.self_modulate = color
	
	if not hide_text:
		label.text = str(value)
		label.add_theme_color_override("font_color", color)
	else:
		label.text = ""
