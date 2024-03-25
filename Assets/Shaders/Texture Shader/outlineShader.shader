// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unlit/OutlineShader"
{
    Properties
    {
        _Color ("Main Color", Color) = (1,1,1,1)
        _MainTex("Main Texture", 2D) = "white"{}
        _Outline ("Outline Thickness", Float) = 0.1
        _OutlineColor ("Outline Color", Color) = (1,1,1,1)
    }
    SubShader
    {
        Tags
        {
           "Queue" = "Transparent"
           "RenderType" = "Transparent"
           "IgnoreProjector" = "True"
        }

        Pass
        {
            Blend SrcAlpha OneMinusSrcAlpha
            Cull front
            Zwrite off
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            uniform half4 _OutlineColor;
            uniform float _Outline;

            struct VertexInput
            {
                float4 vertex : POSITION;
                float4 normal : NORMAL;
            };


            struct VertexOutput
            {
                float4 pos : SV_POSITION;
            };

            VertexOutput vert(VertexInput v)
            {
                VertexOutput o;
                o.pos = UnityObjectToClipPos(v.vertex + v.normal * _Outline);
                //o.pos = UnityObjectToClipPos(v.vertex + (v.normal * _Outline));
                return o;
            }


            half4 frag(VertexOutput i) : Color
            {
                return _OutlineColor;
            }
            ENDCG
        }

        Pass
        {
            Blend SrcAlpha OneMinusSrcAlpha
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            uniform half4 _Color;
            uniform float4 _MainTex_ST;

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

            VertexOutput vert(VertexInput v)
           {
               VertexOutput o;
               o.pos = UnityObjectToClipPos(v.vertex);
               o.texcoord.xy = v.texcoord;
               o.texcoord.xy = (v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw);
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
