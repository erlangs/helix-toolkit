#ifndef PSPARTICLEOIT_HLSL
#define PSPARTICLEOIT_HLSL
#define PARTICLE
#define POINTLINE
#include"..\Common\CommonBuffers.hlsl"
#include"..\Common\DataStructs.hlsl"
#include"psParticle.hlsl"


PSOITOutput particleOIT(in ParticlePS_INPUT input)
{
    PSOITOutput output = (PSOITOutput) 0;
    float4 color = main(input);
    // Insert your favorite weighting function here. The color-based factor
    // avoids color pollution from the edges of wispy clouds. The z-based
    // factor gives precedence to nearer surfaces.
    float weight = max(min(1, (max(max(color.r, color.g), color.b) * color.a)), color.a) * clamp(0.03 / (1e-5 + pow(input.position.w / 200, 4.0)), 1e-2, 3e3);
    // Blend Func: GL_ONE, GL_ONE
    // Switch to premultiplied alpha and weight
    output.color = float4(color.rgb * color.a, color.a) * weight;
 
    // Blend Func: GL_ZERO, GL_ONE_MINUS_SRC_ALPHA
    output.alpha.a = color.a;
    return output;
}

#endif