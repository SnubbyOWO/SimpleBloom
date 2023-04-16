Shader "Snubs/Bloom"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Threshold ("Threshold", Range(0.0, 1.0)) = 0.9
        _BloomIntensity ("Bloom Intensity", Range(0.0, 10.0)) = 2.0
        _BloomRadius ("Bloom Radius", Range(0.0, 5.0)) = 2.0
    }
 
    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
 
            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };
 
            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };
 
            sampler2D _MainTex;
            float _Threshold;
            float _BloomIntensity;
            float _BloomRadius;
 
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }
 
            float4 frag (v2f i) : SV_Target
            {
                float4 color = tex2D(_MainTex, i.uv);
                float4 bloom = float4(0.0, 0.0, 0.0, 0.0);
 
                float2 texelSize = 1.0 / _ScreenParams.xy;
                for (int x = -7; x <= 7; x++)
                {
                    for (int y = -7; y <= 7; y++)
                    {
                        float2 offset = float2(texelSize.x * x * _BloomRadius, texelSize.y * y * _BloomRadius);
                        bloom += tex2D(_MainTex, i.uv + offset);
                    }
                }
                bloom /= 225.0;
 
                float4 finalColor = color + (bloom - _Threshold) * _BloomIntensity;
                return finalColor;
            }
            ENDCG
        }
    }
}