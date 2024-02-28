shader_type canvas_item;

var light_position = Vector2(0, 0) // Position de la source de lumière
var light_radius = 5.0 // Rayon de la source de lumière
var luminosity_texture : ImageTexture = preload("res://luminosity_texture.png") // Remplacez par le chemin de votre texture de luminosité

func _ready():
    // Initialisez la texture de luminosité avec des valeurs par défaut (1.0)
    var luminosity_image = luminosity_texture.get_data()
    luminosity_image.lock()
    
    for x in range(luminosity_image.get_width()):
        for y in range(luminosity_image.get_height()):
            luminosity_image.set_pixel(x, y, Color(1.0, 1.0, 1.0, 1.0)) // Luminosité maximale par défaut
    
    luminosity_image.unlock()
    luminosity_texture.set_data(luminosity_image)

func _process(delta):
    // À chaque trame, mettez à jour la texture de luminosité en fonction de la proximité des tiles à la source de lumière
    var luminosity_image = luminosity_texture.get_data()
    luminosity_image.lock()
    
    for x in range(luminosity_image.get_width()):
        for y in range(luminosity_image.get_height()):
            var tile_position = Vector2(x, y)
            var distance_to_light = light_position.distance_to(tile_position)
            
            // Calculez la luminosité en fonction de la distance par rapport à la source de lumière
            var brightness = clamp(1.0 - distance_to_light / light_radius, 0.0, 1.0)
            
            // Mettez à jour la luminosité dans la texture
            var current_color = luminosity_image.get_pixel(x, y)
            var new_color = Color(brightness, brightness, brightness, 1.0)
            luminosity_image.set_pixel(x, y, current_color.blend(new_color))
    
    luminosity_image.unlock()
    luminosity_texture.set_data(luminosity_image)
    
    // Mettez à jour la texture de luminosité dans votre shader
    var shader_material = your_tilemap.material
    shader_material.set_shader_param("luminosity_texture", luminosity_texture)
