#version 330 compatibility

out vec2 texcoord;
out vec2 lmcoord;
out vec4 glcolor;

void main() {
    vec4 viewPos = gl_ModelViewMatrix * gl_Vertex;
    
    float snapGrid = 80.0;
    viewPos.xyz = floor(viewPos.xyz * snapGrid) / snapGrid;
    
    gl_Position = gl_ProjectionMatrix * viewPos;
    texcoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
    lmcoord  = (gl_TextureMatrix[1] * gl_MultiTexCoord1).xy;
    glcolor = gl_Color;
}