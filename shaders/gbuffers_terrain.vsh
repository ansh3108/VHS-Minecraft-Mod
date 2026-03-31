#version 330 compatibility

out vec2 texcoord;
out vec2 lmcoord;
out vec4 glcolor;
out float dist;
out float vW;

void main() {
    vec4 viewPos = gl_ModelViewMatrix * gl_Vertex;
    
    float snapGrid = 140.0;
    viewPos.xyz = floor(viewPos.xyz * snapGrid) / snapGrid;
    
    gl_Position = gl_ProjectionMatrix * viewPos;
    
    vW = gl_Position.w;
    texcoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy * vW;
    lmcoord  = (gl_TextureMatrix[1] * gl_MultiTexCoord1).xy;
    glcolor = gl_Color;
    dist = length(viewPos.xyz);
}