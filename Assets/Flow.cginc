#if !defined(FLOW_INCLUDED)
#define FLOW_INCLUDED
float2 FlowUV(float2 uv, float2 flowVector, float time)
{
	float progress = frac(time);
	return uv -flowVector * progress;
}
float3 FlowUVW(float2 uv, float2 flowVector, float time, bool flowB)
{
	float phaseOffset = flowB ? 0.5 : 0;
	float progress = frac(time + phaseOffset);
	float3 uvw;
	//uvw.xy is the same as uv in previous function
	uvw.xy = uv - flowVector * progress + phaseOffset;
	//uvw.z = blend weight
	uvw.z = 1 - abs(1 - 2 * progress);
	return uvw;

}
#endif
