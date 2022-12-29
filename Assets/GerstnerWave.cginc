#if !defined(GERSTNER_INCLUDED)
#define (GERSTNER_INCLUDED)
float3 GerstnerWave(float4 wave, float3 p, inout float3 tangent, inout float3 binormal)
{
	float steepness = wave.z;
	float wavelength = wave.w;
	float k = 2 * UNITY_PI / wavelength;
	float c = sqrt(9.8 / k); //gravity
	float2 d = normalize(wave.xy); //direction
	float f = k * (dot(d, p.xz) - c * _Time.y); //freq
	float a = steepness / k; //amplitude


	tangent += float3(
		-d.x * d.x * (steepness * sin(f)),
		d.x * (steepness * cos(f)),
		-d.x * d.y * (steepness * sin(f))
		);
	binormal += float3(
		-d.x * d.y * (steepness * sin(f)),
		d.y * (steepness * cos(f)),
		-d.y * d.y * (steepness * sin(f))
		);
	return float3(
		d.x * (a * cos(f)),
		a * sin(f),
		d.y * (a * cos(f)));
}
#endif
