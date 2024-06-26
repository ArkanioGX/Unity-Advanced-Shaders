Shader "Unlit/FadeoutShader"
{
    Properties
    {
        _Color ("Main Color", Color) = (1,1,1,1)
        _MainTex("Main Texture", 2D) = "white"{}
        _Color1 ("Second Color", Color) = (1,1,1,1)
        _MainTex1("Second Texture", 2D) = "white"{}
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
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            uniform half4 _Color;
            uniform half4 _Color1;
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
            uniform sampler2D _MainTex1;

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
                float4 color1 = tex2D(_MainTex, i.texcoord) * _Color;
                float4 color2 = tex2D(_MainTex1, i.texcoord) * _Color1;
                color1.a = i.texcoord.x;
                color2.a = 1-i.texcoord.x;
                float4 color = (color1 * color1.a) + (color2 * color2.a);
                return color;

            }
            ENDCG
        }
    }
}
