shader_type canvas_item;

// --- Parámetros de la Barra ---
uniform float progress : hint_range(0.0, 1.0) = 0.75; // Progreso actual

// --- Colores ---
uniform vec4 fill_color : source_color = vec4(0.0, 1.0, 0.0, 1.0);   // Color sólido de la barra
uniform vec4 empty_color : source_color = vec4(0.1, 0.1, 0.1, 0.5); // Color de la parte vacía

// --- Pulso para tiempo bajo ---
uniform bool enable_low_time_pulse = true;
uniform float low_time_threshold : hint_range(0.0, 1.0) = 0.2;
uniform float pulse_speed : hint_range(0.0, 10.0) = 5.0;
uniform vec4 pulse_color : source_color = vec4(1.0, 0.0, 0.0, 0.7); // Rojo pulsante

void fragment() {
    vec4 final_color;

    if (UV.x < progress) {
        final_color = fill_color;

        if (enable_low_time_pulse && progress < low_time_threshold) {
            float pulse_alpha = (sin(TIME * pulse_speed) * 0.5 + 0.5) * pulse_color.a;
            final_color = mix(final_color, pulse_color, pulse_alpha);
        }

    } else {
        final_color = empty_color;
    }

    COLOR = final_color;
}
