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
    
    float tapeTear = step(0.95, fract(uv.y * 1.2 + time * 0.1)) * 0.005 * sin(time * 20.0);
    uv.x += tapeTear;

    float r = texture(colortex0, uv + vec2(0.003, 0.0)).r;
    float g = texture(colortex0, uv).g;
    float b = texture(colortex0, uv - vec2(0.003, 0.0)).b;
    
    vec3 outColor = vec3(r, g, b);
    outColor -= sin(uv.y * 1000.0) * 0.03;
    
    float noiseGrain = (fract(sin(dot(uv + time, vec2(12.9898, 78.233))) * 43758.5453) - 0.5) * 0.1;
    outColor += noiseGrain;

    float edgeSoft = smoothstep(0.0, 0.05, uv.x) * smoothstep(1.0, 0.95, uv.x) *
                     smoothstep(0.0, 0.08, uv.y) * smoothstep(1.0, 0.92, uv.y);

    color = vec4(outColor * edgeSoft, 1.0);
}