#version 330 compatibility
#include "/lib/retro_utils.glsl"

uniform sampler2D gtexture;
uniform sampler2D lightmap;

in vec2 texcoord;
in vec2 lmcoord;
in vec4 glcolor;
in float vW;

layout(location = 0) out vec4 color;

void main() {
    vec2 affineUV = texcoord / vW;
    vec4 albedo = texture(gtexture, affineUV) * glcolor;
    
    vec2 ditherPos = gl_FragCoord.xy;
    float threshold = getBayer8(ditherPos);
    
    if (0.5 < threshold) discard;

    color = vec4(posterize(albedo.rgb, 12.0), 1.0);
}