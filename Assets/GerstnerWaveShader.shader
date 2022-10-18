Shader "Custom/GerstnerWaveShader"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Glossiness("Smoothness", Range(0,1)) = 0.5
        _Metallic("Metallic", Range(0,1)) = 0.0
        [NoScaleOffset] _FlowMap("Flow (RG, A noise)", 2D) = "black"{}
       
        [NoScaleoffset] _DerivHeightMap("Derviv (AG) Height(B)", 2D) = "Black"{}
        _UJump("U jump per phase", Range(-0.25, 0.25)) = 0.25
        _VJump("V jump per phase", Range(-0.25, 0.25)) = 0.25
        _Tiling("Tiling", Float) = 1
        _Speed("Speed", Float) = 1
        _FlowOffset("Flow Offset",Float) = 0
        _FlowStrength("Flow Strength", Float) = 1
        _HeightScale("Height Scale, Constant", Float) = 0.25
        _HeightScaleModulated("Height Scale, Modulated", Float) = 0.75
        _WaveA("Wave A (direction , steepness, wavelength)", Vector)=(1,0,0.5,10)
        _WaveB("Wave B (direction , steepness, wavelength)", Vector) = (1,1,0.5,10)
        _WaveC("Wave C (direction , steepness, wavelength)", Vector) = (0,1,0.5,10)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows vertex:vert addshadow
        #include "GerstnerWave.cginc"
        #include "Flow.cginc"
        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex, _FlowMap, _DerivHeightMap;

        struct Input
        {
            float2 uv_MainTex;
        };

        half _Glossiness;
        half _Metallic;
        fixed4 _Color;
        float4 _WaveA;
        float4 _WaveB;
        float4 _WaveC;
        float _UJump;
        float _VJump;
        float _Tiling;
        float _Speed;
        float _FlowOffset;
        float _FlowStrength;
        float _HeightScale;
        float _HeightScaleModulated;

        void vert(inout appdata_full vertexData) 
        {
            float3 gridPoint = vertexData.vertex.xyz;
            float3 tangent = float3(1, 0, 0);
            float3 binormal = float3(0, 0, 1);
            float3 p = gridPoint;
            p += GerstnerWave(_WaveA, gridPoint, tangent, binormal);
            p += GerstnerWave(_WaveB, gridPoint, tangent, binormal);
            p += GerstnerWave(_WaveC, gridPoint, tangent, binormal);
            float3 normal = normalize(cross(binormal, tangent));
            vertexData.normal = normal;
            vertexData.vertex.xyz = p;
        }
        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

            float3 UnpackDerivativeHeight(float4 textureData)
        {
            float3 dh = textureData.agb;
            dh.xy = dh.xy * 2 - 1;
            return dh;
        }

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            // Albedo comes from a texture tinted by color
            float3 flow = tex2D(_FlowMap, IN.uv_MainTex).rgb;
            flow.xy = flow.xy * 2 - 1;
            flow *= _FlowStrength;
            float2 flowVector = tex2D(_FlowMap, IN.uv_MainTex).rg * 2 - 1;
            float noise = tex2D(_FlowMap, IN.uv_MainTex).a;
            float time = _Time.y * _Speed + noise;
            float jump = float2(_UJump, _VJump);
           

            float fHeightScale = length(flow.z * _HeightScaleModulated + _HeightScale);


            float3 uvwA = FlowUVW(IN.uv_MainTex, flow.xy,_FlowOffset,_Tiling, jump, time, false); //original triangle wave
            float3 uvwB = FlowUVW(IN.uv_MainTex, flow.xy,_FlowOffset,_Tiling, jump, time, true); //offset triangle wave

            float3 dhA = UnpackDerivativeHeight(tex2D(_DerivHeightMap, uvwA.xy)) * (uvwA.z * fHeightScale);
            float3 dhB = UnpackDerivativeHeight(tex2D(_DerivHeightMap, uvwB.xy)) * (uvwB.z * fHeightScale);
            

            fixed4 texA = tex2D(_MainTex, uvwA.xy) * uvwA.z;
            fixed4 texB = tex2D(_MainTex, uvwB.xy) * uvwB.z;
            fixed4 c = (texA + texB) * _Color;

            o.Normal = normalize(float3(-(dhA.xy + dhB.xy),1));
            //o.Albedo = pow(dhA.z + dhB.z,2);
            o.Albedo = c.rgb;
            // Metallic and smoothness come from slider variables
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
