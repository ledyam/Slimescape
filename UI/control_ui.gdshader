shader_type canvas_item;

// --- Parámetros de la Barra ---
uniform float progress : hint_range(0.0, 1.0) = 0.75; // El progreso actual de la barra (0.0 a 1.0)

// --- Colores de la Barra ---
uniform vec4 fill_color_start : source_color = vec4(0.0, 1.0, 0.0, 1.0); // Verde vibrante
uniform vec4 fill_color_end : source_color = vec4(0.0, 0.5, 0.0, 1.0);   // Verde oscuro
uniform vec4 empty_color : source_color = vec4(0.1, 0.1, 0.1, 0.5);     // Gris oscuro semitransparente para la parte vacía

// --- Parámetros de Pulso para Tiempo Bajo ---
uniform bool enable_low_time_pulse = true;
uniform float low_time_threshold : hint_range(0.0, 1.0) = 0.2;  // Cuando el progreso es menor a este valor, pulsa
uniform float pulse_speed : hint_range(0.0, 10.0) = 5.0;        // Velocidad del pulso
uniform vec4 pulse_color : source_color = vec4(1.0, 0.0, 0.0, 0.7); // Rojo para el pulso de advertencia

// --- Parámetros de Brillo Deslizante ---
uniform bool enable_shine_effect = true;
uniform float shine_width : hint_range(0.0, 1.0) = 0.1;       // Ancho del brillo (como porcentaje de la barra)
uniform float shine_speed : hint_range(0.0, 5.0) = 0.5;       // Velocidad a la que se mueve el brillo
uniform vec4 shine_color : source_color = vec4(1.0, 1.0, 1.0, 0.5); // Color y transparencia del brillo

void fragment() {
    vec4 final_color;

    // 1. Determinar el color base según el progreso
    if (UV.x < progress) {
        // Parte Rellena: Aplicar degradado
        final_color = mix(fill_color_start, fill_color_end, UV.x);

        // 2. Aplicar efecto de Brillo Deslizante (si está habilitado)
        if (enable_shine_effect) {
            // ¡CORRECCIÓN AQUÍ! Cambiado 'fmod' a 'mod'
            float shine_pos = mod(TIME * shine_speed, 1.0 + shine_width * 2.0) - shine_width;
            float dist_to_shine = abs(UV.x - shine_pos);
            float shine_alpha = smoothstep(shine_width, 0.0, dist_to_shine) * shine_color.a;
            final_color = mix(final_color, shine_color, shine_alpha);
        }

        // 3. Aplicar efecto de Pulso para Tiempo Bajo (si está habilitado)
        if (enable_low_time_pulse && progress < low_time_threshold) {
            float pulse_alpha = (sin(TIME * pulse_speed) * 0.5 + 0.5) * pulse_color.a;
            final_color = mix(final_color, pulse_color, pulse_alpha);
        }

    } else {
        // Parte Vacía
        final_color = empty_color;
    }

    COLOR = final_color; // Asigna el color final al píxel
}