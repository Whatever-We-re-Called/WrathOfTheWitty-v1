extends HBoxContainer

func init(icon: Texture2D, value: int, color: Color):
	var texture_rect = $TextureRect
	var label = $Label
	
	texture_rect.texture = icon
	texture_rect.self_modulate = color
	
	label.text = str(value)
	label.add_theme_color_override("font_color", color)
