// glitch_transition.gdshader (VERSIÓN CON DESPLAZAMIENTO)
//Glitch de Distorción para transición de niveles
shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;

// --- PARÁMETROS ---
// Intensidad del glitch de desplazamiento
uniform float glitch_intensity : hint_range(0.0, 1.0) = 0.0;
// Intensidad de la viñeta oscura
uniform float vignette_intensity : hint_range(0.0, 1.0) = 0.5;
// Opacidad de la viñeta
uniform float vignette_opacity : hint_range(0.0, 1.0) = 0.0;
// Opacidad del fundido a negro final
uniform float fade_to_black : hint_range(0.0, 1.0) = 0.0;

// Función de ruido simple para obtener un valor aleatorio.
float rand(vec2 coord) {
    return fract(sin(dot(coord, vec2(12.9898, 78.233))) * 43758.5453123);
}

void fragment() {
    
    // --- 1. GLITCH DE DESPLAZAMIENTO HORIZONTAL ---
    // Generamos un valor de ruido aleatorio basado en la coordenada vertical y el tiempo.
    // Esto crea un desplazamiento diferente para cada línea horizontal.
    float random_offset = rand(vec2(TIME, SCREEN_UV.y));
    // Mapeamos el ruido (de 0 a 1) a un rango (-1 a 1) para que el desplazamiento sea en ambas direcciones.
    random_offset = (random_offset - 0.5) * 2.0;
    
    // Aplicamos la intensidad del glitch a nuestro desplazamiento aleatorio.
    float horizontal_displacement = random_offset * glitch_intensity;
    
    // Creamos las nuevas coordenadas de textura, aplicando solo el desplazamiento horizontal.
    vec2 displaced_uv = SCREEN_UV + vec2(horizontal_displacement, 0.0);
    
    // Tomamos el color de la pantalla usando las coordenadas desplazadas.
    vec3 glitched_color = texture(SCREEN_TEXTURE, displaced_uv).rgb;

    // --- 2. VIÑETA (sin cambios) ---
    float dist_from_center = distance(SCREEN_UV, vec2(0.5));
    float vignette = smoothstep(0.8, vignette_intensity, dist_from_center);
    vignette *= vignette_opacity;
    
    // --- 3. COMBINACIÓN FINAL ---
    // Mezclamos el color con glitch con el negro, usando la viñeta como máscara.
    vec3 final_color = mix(glitched_color, vec3(0.0), vignette);
    // Aplicamos el fundido a negro final sobre todo lo demás.
    final_color = mix(final_color, vec3(0.0), fade_to_black);
    
    COLOR = vec4(final_color, 1.0);
}