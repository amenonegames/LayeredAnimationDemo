Shader "Custom/LayeredShader"
{
    Properties
    {
        _Layer4("Layer4", 2D) = "white" {}
        _Layer3("Layer3", 2D) = "white" {}
        _Layer2("Layer2", 2D) = "white" {}
        _Layer1("Layer1", 2D) = "white" {}
        _Color("Color", Color) = (1,1,1,1)
    }
    SubShader
    {
        Tags
        {
            "Queue" = "Transparent"
            "RenderType" = "Transparent"
            "RenderPipeline" = "UniversalPipeline"

            "IgnoreProjector" = "True"
            "PreviewType" = "Plane"
            "CanUseSpriteAtlas" = "True"
        }
        Cull off
        ZWrite Off
        Blend SrcAlpha OneMinusSrcAlpha

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"
            
            sampler2D _Layer4;
            sampler2D _Layer3;
            sampler2D _Layer2;
            sampler2D _Layer1;
            
            float4 _Layer4_ST;
            float4 _Layer3_ST;
            float4 _Layer2_ST;
            float4 _Layer1_ST;
            half4 _Color;
            
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
            
            float clamp01(float x)
            {
                return clamp(x, 0.0, 1.0);
            }

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _Layer1);

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float2 uv = i.uv;

                float4 layer4 = tex2D(_Layer4, uv);
                float4 layer3 = tex2D(_Layer3, uv);
                float4 layer2 = tex2D(_Layer2, uv);
                float4 layer1 = tex2D(_Layer1, uv);
                
                float r = clamp01((layer4.r * layer4.a) + (layer3.r * layer3.a * clamp01(1-layer4.a)) + (layer2.r * layer2.a * clamp01(1-layer4.a-layer3.a)) + (layer1.r * layer1.a * clamp01(1-layer4.a-layer3.a-layer2.a)));
                float g = clamp01((layer4.g * layer4.a) + (layer3.g * layer3.a * clamp01(1-layer4.a)) + (layer2.g * layer2.a * clamp01(1-layer4.a-layer3.a)) + (layer1.g * layer1.a * clamp01(1-layer4.a-layer3.a-layer2.a)));
                float b = clamp01((layer4.b * layer4.a) + (layer3.b * layer3.a * clamp01(1-layer4.a)) + (layer2.b * layer2.a * clamp01(1-layer4.a-layer3.a)) + (layer1.b * layer1.a * clamp01(1-layer4.a-layer3.a-layer2.a)));
                float a = clamp01(layer4.a + layer3.a + layer2.a + layer1.a);
                
                float4 c = float4(r,g,b,a) * _Color;
                
                return c;
            }
            ENDCG
        }
    }
}
