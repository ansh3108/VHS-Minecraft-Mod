#version 330 compatibility
#include "/lib/retro_utils.glsl"

uniform sampler2D gtexture;
uniform sampler2D lightmap;

in vec2 texcoord;
in vec2 lmcoord;
in vec4 glcolor;
in float dist;
in float vW;

layout(location = 0) out vec4 color;

void main() {
    vec2 affineUV = texcoord / vW;
    vec4 albedo = texture(gtexture, affineUV) * glcolor;
    albedo *= texture(lightmap, lmcoord);
    
    if (albedo.a < 0.1) discard;

    float fogDensity = 0.04;
    float fog = exp(-fogDensity * dist);
    vec3 fogColor = vec3(0.1, 0.12, 0.15);
    
    vec3 finalRGB = mix(fogColor, albedo.rgb, clamp(fog, 0.0, 1.0));
    color = vec4(posterize(finalRGB, 16.0), albedo.a);
}