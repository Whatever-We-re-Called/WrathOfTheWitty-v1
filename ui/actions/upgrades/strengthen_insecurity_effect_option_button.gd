extends Button


func init(insecurity: Constants.Insecurity, dividend_value: int):
	text = Constants.insecurity_strings[insecurity] + " [" + str(dividend_value) + "]"
