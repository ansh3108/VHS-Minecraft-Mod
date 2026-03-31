float getBayer8(vec2 uv) {
    int x = int(mod(uv.x, 8.0));
    int y = int(mod(uv.y, 8.0));
    int index = x + y * 8;
    float bayer8[64] = float[](
        0, 32, 8, 40, 2, 34, 10, 42,
        48, 16, 56, 24, 50, 18, 58, 26,
        12, 44, 4, 36, 14, 46, 6, 38,
        60, 28, 52, 20, 62, 30, 54, 22,
        3, 35, 11, 43, 1, 33, 9, 41,
        51, 19, 59, 27, 49, 17, 57, 25,
        15, 47, 7, 39, 13, 45, 5, 37,
        63, 31, 55, 23, 61, 29, 53, 21
    );
    return bayer8[index] / 64.0;
}

vec2 crtCurve(vec2 uv) {
    uv = uv * 2.0 - 1.0;
    vec2 offset = abs(uv.yx) / 3.0;
    uv = uv + uv * offset * offset;
    uv = uv * 0.5 + 0.5;
    return uv;
}

vec3 posterize(vec3 color, float levels) {
    return floor(color * levels) / levels;
}