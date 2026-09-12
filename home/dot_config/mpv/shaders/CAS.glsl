// FidelityFX Contrast Adaptive Sharpening (CAS) for MPV
// Ported for MPV / libplacebo by butterw
//!HOOK MAIN
//!BIND HOOKED
//!DESC FidelityFX Contrast Adaptive Sharpening (CAS)

#define SHARPENING 0.6 // [0.0 to 1.0]

vec4 hook() {
    vec2 pos = HOOKED_pos;
    vec2 size = HOOKED_size;
    vec2 pt = HOOKED_pt;

    vec3 a = HOOKED_texOff(vec2(-1, -1)).rgb;
    vec3 b = HOOKED_texOff(vec2( 0, -1)).rgb;
    vec3 c = HOOKED_texOff(vec2( 1, -1)).rgb;
    vec3 d = HOOKED_texOff(vec2(-1,  0)).rgb;
    vec3 e = HOOKED_texOff(vec2( 0,  0)).rgb;
    vec3 f = HOOKED_texOff(vec2( 1,  0)).rgb;
    vec3 g = HOOKED_texOff(vec2(-1,  1)).rgb;
    vec3 h = HOOKED_texOff(vec2( 0,  1)).rgb;
    vec3 i = HOOKED_texOff(vec2( 1,  1)).rgb;

    vec3 min_rgb = min(min(min(d, e), min(f, b)), h);
    vec3 min_rgb2 = min(min(min(min_rgb, a), min(c, g)), i);
    min_rgb += min_rgb2;

    vec3 max_rgb = max(max(max(d, e), max(f, b)), h);
    vec3 max_rgb2 = max(max(max(max_rgb, a), max(c, g)), i);
    max_rgb += max_rgb2;

    vec3 amp_rgb = clamp(min(min_rgb, 2.0 - max_rgb) / max_rgb, 0.0, 1.0);
    vec3 w_rgb = sqrt(amp_rgb) * (-0.125 * SHARPENING - 0.03125);

    vec3 res = (b + d + f + h) * w_rgb + e;
    res /= (4.0 * w_rgb + 1.0);

    return vec4(clamp(res, 0.0, 1.0), 1.0);
}
