float getSdfRectangle(in vec2 p, in vec2 xy, in vec2 b)
{
    vec2 d = abs(p - xy) - b;
    return length(max(d, 0.0)) + min(max(d.x, d.y), 0.0);
}

vec2 normalize(vec2 value, float isPosition) {
    return (value * 2.0 - (iResolution.xy * isPosition)) / iResolution.y;
}

float antialising(float distance) {
    return 1.0 - smoothstep(0.0, normalize(vec2(2.0, 2.0), 0.0).x, distance);
}

vec2 getRectangleCenter(vec4 rectangle) {
    return rectangle.xy + vec2(rectangle.z, -rectangle.w) * 0.5;
}

const vec4 PULSE_COLOR = vec4(0.278, 0.784, 0.753, 0.4);
const float PULSE_DURATION = 0.4;
const float MAX_PULSE_RADIUS = 0.5;
const float INV_PULSE_THICKNESS = 1.0 / (0.015 * 0.3);
const float JUMP_THRESHOLD = 0.3;
const float JUMP_THRESHOLD_SQ = JUMP_THRESHOLD * JUMP_THRESHOLD; // For distance check

vec4 calculatePulse(vec2 vu, vec2 center, float timeSinceStart) {
    // Manhattan distance for diamond effect
    float distFromCenter = abs(vu.x - center.x) + abs(vu.y - center.y);
    
    float progress = clamp(timeSinceStart / PULSE_DURATION, 0.0, 1.0);
    float oneMinusProgress = 1.0 - progress;
    
    float easedProgress = 1.0 - oneMinusProgress * oneMinusProgress * oneMinusProgress;
    
    // Pulse radius
    float pulseRadius = easedProgress * MAX_PULSE_RADIUS;
    
    float ringDist = abs(distFromCenter - pulseRadius);
    float ringMask = 1.0 - smoothstep(0.0, 0.0045, ringDist); // Precomputed 0.015 * 0.3
    
    // Fade factor
    float fadeFactor = oneMinusProgress * 0.7;
    
    return PULSE_COLOR * (ringMask * fadeFactor);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    #if !defined(WEB)
    fragColor = texture(iChannel0, fragCoord.xy / iResolution.xy);
    #endif
    
    float invResY = 1.0 / iResolution.y;
    vec2 vu = (fragCoord * 2.0 - iResolution.xy) * invResY;
    
    // Normalize cursor data
    vec2 cursorNormXY = (iCurrentCursor.xy * 2.0 - iResolution.xy) * invResY;
    vec2 cursorNormSize = iCurrentCursor.zw * 2.0 * invResY;
    
    vec2 prevCursorNormXY = (iPreviousCursor.xy * 2.0 - iResolution.xy) * invResY;
    vec2 prevCursorNormSize = iPreviousCursor.zw * 2.0 * invResY;
    
    // Get cursor centers
    vec2 cursorCenter = cursorNormXY + vec2(cursorNormSize.x, -cursorNormSize.y) * 0.5;
    vec2 previousCenter = prevCursorNormXY + vec2(prevCursorNormSize.x, -prevCursorNormSize.y) * 0.5;
    
    // Calculate squared distance for comparison
    vec2 jumpVec = cursorCenter - previousCenter;
    float jumpDistSq = dot(jumpVec, jumpVec);
    
    // Check if pulse should trigger
    float shouldPulse = step(JUMP_THRESHOLD_SQ, jumpDistSq);
    
    // Calculate pulse effect
    vec4 totalPulseEffect = vec4(0.0);
    float pulseTime = iTime - iTimeCursorChange;
    
    // Early exit if pulse isn't active
    if (pulseTime >= 0.0 && pulseTime < PULSE_DURATION && shouldPulse > 0.0) {
        totalPulseEffect = calculatePulse(vu, cursorCenter, pulseTime);
    }
    
    // Draw cursor rectangle
    vec2 cursorOffset = cursorNormSize * vec2(-0.5, 0.5);
    float sdfCurrentCursor = getSdfRectangle(vu, cursorNormXY - cursorOffset, cursorNormSize * 0.5);
    
    vec4 newColor = fragColor;
    
    // Blend pulse
    newColor = mix(newColor, totalPulseEffect, totalPulseEffect.a);
    
    // Draw cursor
    float cursorMask = antialising(sdfCurrentCursor);
    float insideCursor = step(sdfCurrentCursor, 0.0);
    newColor = mix(mix(newColor, PULSE_COLOR, cursorMask), fragColor, insideCursor);
    
    fragColor = newColor;
}
