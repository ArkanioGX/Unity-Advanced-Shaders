Shader "Unlit/FlagShader"
{
    Properties
    {
        _Color ("Main Color", Color) = (1,1,1,1)
        _MainTex("Main Texture", 2D) = "white"{}
        _Speed ("Flag Speed", Float) = 1
        _Frequency ("Flag Frequency", Float) = 1
        _Amplitude ("Flag Amplitude", Float) = 1
    }
    SubShader
    {
        Tags
        {
           "RenderType"="Opaque"
        }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            uniform half4 _Color;
            uniform float4 _MainTex_ST;
            uniform float _Speed;
            uniform float _Frequency;
            uniform float _Amplitude;

            struct VertexInput
           {
               float4 vertex: POSITION;
               float4 texcoord: TEXCOORD0;
           };


            struct VertexOutput
            {
                float4 pos : SV_POSITION;
                float4 texcoord: TEXCOORD0;
            };

            uniform sampler2D _MainTex;

            float4 vertexAnimFlag(float4 pos, float2 uv)
            {
               pos.z = pos.z + (sin((uv.x - _Time.y * _Speed) * _Frequency) * _Amplitude) * uv.x;
               return pos;
            }


            VertexOutput vert(VertexInput v)
           {
               VertexOutput o;

               o.texcoord.xy = v.texcoord;
               o.texcoord.xy = (v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw);
               v.vertex = vertexAnimFlag(v.vertex,o.texcoord.xy);
               o.pos = UnityObjectToClipPos(v.vertex);
               
               
               return o;
           }


            half4 frag (VertexOutput i) : Color
            {
                return tex2D(_MainTex, i.texcoord) * _Color;
            }
            ENDCG
        }
    }
}
