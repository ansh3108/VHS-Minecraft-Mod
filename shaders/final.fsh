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
    
    float tapeTear = step(0.96, fract(uv.y * 1.5 + time * 0.2)) * 0.004 * sin(time * 30.0);
    uv.x += tapeTear;

    float r = texture(colortex0, uv + vec2(0.0025, 0.0)).r;
    float g = texture(colortex0, uv).g;
    float b = texture(colortex0, uv - vec2(0.0025, 0.0)).b;
    vec3 outColor = vec3(r, g, b);
    
    outColor -= sin(uv.y * 800.0) * 0.05;
    
    float noiseGrain = (fract(sin(dot(uv + time, vec2(12.9898, 78.233))) * 43758.5453) - 0.5) * 0.12;
    outColor += noiseGrain;

    float recDot = distance(uv, vec2(0.12, 0.88));
    if (recDot < 0.015 && mod(time, 2.0) > 1.0) {
        outColor = mix(outColor, vec3(1.0, 0.0, 0.0), 0.9);
    }
    if (uv.x > 0.72 && uv.x < 0.88 && uv.y > 0.12 && uv.y < 0.14) {
        float textNoise = fract(sin(dot(uv.xy * 100.0, vec2(12.9898, 78.233))) * 43758.5453);
        if (textNoise > 0.4) outColor += 0.6;
    }

    float vignette = smoothstep(0.9, 0.35, length(uv - 0.5));
    outColor *= mix(0.65, 1.0, vignette);

    float edgeSoft = smoothstep(0.0, 0.04, uv.x) * smoothstep(1.0, 0.96, uv.x) *
                     smoothstep(0.0, 0.06, uv.y) * smoothstep(1.0, 0.94, uv.y);

    color = vec4(outColor * edgeSoft, 1.0);
}