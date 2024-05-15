extends Button


func init(blessing: Blessing):
	icon = blessing.texture
	
	var color = Blessing.COSMIC_COLOR if blessing.is_cosmic else Blessing.NORMAL_COLOR
	add_theme_color_override("icon_normal_color", color)
	add_theme_color_override("icon_pressed_color", color)
	add_theme_color_override("icon_hover_color", color)
	
	tooltip_text = blessing.description
