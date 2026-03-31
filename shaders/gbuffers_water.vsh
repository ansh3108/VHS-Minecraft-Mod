#version 330 compatibility

uniform float frameTimeCounter;

out vec2 texcoord;
out vec3 facetedColor;

float posterize(float color, float levels) {
    return floor(color * levels) / levels;
}

void main() {
    vec4 viewPos = gl_ModelViewMatrix * gl_Vertex;
    
    float snapGrid = 120.0;
    viewPos.xyz = floor(viewPos.xyz * snapGrid) / snapGrid;
    
    gl_Position = gl_ProjectionMatrix * viewPos;

    vec2 rawUV = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
    
    float scrollSpeed = 0.05;
    texcoord = rawUV + vec2(frameTimeCounter * scrollSpeed, frameTimeCounter * scrollSpeed * 0.5);
    
    vec2 lmcoord = (gl_TextureMatrix[1] * gl_MultiTexCoord1).xy;
    float lightLevel = max(lmcoord.x, lmcoord.y);
    lightLevel = posterize(lightLevel, 8.0);
    
    facetedColor = gl_Color.rgb * lightLevel;
}