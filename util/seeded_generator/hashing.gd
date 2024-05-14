extends Node

const HASH_LENGTH = 512
const MAX_VALUE = 65536 # Multiple of 16
 
func hash_string(input: String) -> Array:
	var hash = []
	var sha256 = ""
	
	for i in (HASH_LENGTH * 2) / 64:
		sha256 += (input + str(i)).sha256_text()
	
	var x = MAX_VALUE
	var times = 1
	while x > 16:
		times += 1
		x = x / 16
	
	for i in range(0, sha256.length(), times):
		var index = 0
		
		for j in times:
			var bit = sha256[i + j].hex_to_int() << (j * 4)
			index = index | bit
		
		hash.append(index)
			

	return hash
