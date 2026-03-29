#version 330 compatibility
#include "/lib/retro_utils.glsl"

uniform sampler2D colortex0;
uniform float frameTimeCounter;

in vec2 texcoord;
layout(location = 0) out vec4 color;

float noise(vec2 co) {
    return fract(sin(dot(co, vec2(12.9898, 78.233))) * 43758.5453);
}

void main() {
    vec2 uv = crtCurve(texcoord);
    
    if (uv.x < 0.0 || uv.x > 1.0 || uv.y < 0.0 || uv.y > 1.0) {
        color = vec4(0.0, 0.0, 0.0, 1.0);
        return;
    }

    float edgeSoft = smoothstep(0.0, 0.02, uv.x) * smoothstep(1.0, 0.98, uv.x) *
                     smoothstep(0.0, 0.02, uv.y) * smoothstep(1.0, 0.98, uv.y);

    float abAmount = 0.004;
    float r = texture(colortex0, uv + vec2(abAmount, 0.0)).r;
    float g = texture(colortex0, uv).g;
    float b = texture(colortex0, uv - vec2(abAmount, 0.0)).b;
    vec3 outColor = vec3(r, g, b);

    float scanline = sin(uv.y * 800.0) * 0.1;
    outColor -= scanline;

    float grain = (noise(uv + frameTimeCounter) - 0.5) * 0.12;
    outColor += grain;

    float vignette = smoothstep(0.8, 0.2, length(uv - 0.5));
    outColor *= mix(0.7, 1.0, vignette);

    color = vec4(outColor * edgeSoft, 1.0);
}