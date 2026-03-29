#version 330 compatibility
#include "/lib/retro_utils.glsl"

uniform sampler2D colortex0;
uniform float frameTimeCounter;

in vec2 texcoord;
layout(location = 0) out vec4 color;

void main() {
    vec2 uv = crtCurve(texcoord);
    
    if (uv.x < 0.0 || uv.x > 1.0 || uv.y < 0.0 || uv.y > 1.0) {
        color = vec4(0.0, 0.0, 0.0, 1.0);
        return;
    }

    float time = frameTimeCounter;
    float jitter = (rand(vec2(time, floor(uv.y * 100.0))) - 0.5) * 0.002;
    
    float drift = sin(uv.y * 2.0 + time) * 0.002;
    float jump = step(0.98, rand(vec2(time * 0.5, 0.0))) * (rand(vec2(time, 1.0)) - 0.5) * 0.05;
    
    uv.x += jitter + drift + jump;

    float edgeSoft = smoothstep(0.0, 0.03, uv.x) * smoothstep(1.0, 0.97, uv.x) *
                     smoothstep(0.0, 0.05, uv.y) * smoothstep(1.0, 0.95, uv.y);

    float abAmount = 0.003;
    float r = texture(colortex0, uv + vec2(abAmount, 0.0)).r;
    float g = texture(colortex0, uv).g;
    float b = texture(colortex0, uv - vec2(abAmount, 0.0)).b;
    vec3 outColor = vec3(r, g, b);

    float scanline = sin(uv.y * 700.0) * 0.08;
    outColor -= scanline;

    float grain = (rand(uv + time) - 0.5) * 0.15;
    outColor += grain;

    float recDot = distance(uv, vec2(0.1, 0.9));
    if (recDot < 0.015 && mod(time, 2.0) > 1.0) {
        outColor = mix(outColor, vec3(1.0, 0.0, 0.0), 0.8);
    }

    if (uv.x > 0.75 && uv.x < 0.9 && uv.y > 0.1 && uv.y < 0.12) {
        float textNoise = rand(vec2(uv.x * 200.0, uv.y * 20.0));
        if (textNoise > 0.4) outColor += 0.5;
    }

    float vignette = smoothstep(0.9, 0.3, length(uv - 0.5));
    outColor *= mix(0.6, 1.0, vignette);

    color = vec4(outColor * edgeSoft, 1.0);
}