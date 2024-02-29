extends Sprite2D

func _ready():
	# Remplacez "image path" par le chemin d'accès complet à votre image
	var image_path = "C:/Users/nolan/AppData/Roaming/Godot/app_userdata/Platform Master/Worlds/555555/screenshot.png"

	var image = Image.new()
	
	# Chargez l'image depuis le chemin spécifié
	var load_success = image.load(image_path)

	if load_success == OK:
		var image_texture = ImageTexture.new()
		image_texture.create_from_image(image)

		# Assurez-vous que $Sprite est correctement lié dans votre scène
		self.texture = image_texture  # Utilisez "self.texture" pour définir la texture du Sprite2D
	else:
		print("Échec du chargement de l'image depuis le chemin:", image_path)
