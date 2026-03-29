#version 330 compatibility
#include "/lib/retro_utils.glsl"

uniform sampler2D gtexture;
uniform sampler2D lightmap;

in vec2 texcoord;
in vec2 lmcoord;
in vec4 glcolor;

/* RENDERTARGETS: 0 */
layout(location = 0) out vec4 color;

void main() {
    vec4 albedo = texture(gtexture, texcoord) * glcolor;
    albedo *= texture(lightmap, lmcoord);
    
    if (albedo.a < 0.1) discard;
    
    albedo.rgb = posterizeVec3(albedo.rgb, 16.0);
    
    color = albedo;
}