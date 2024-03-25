Shader "Unlit/LineShader"
{
    Properties
    {
        _Color ("Main Color", Color) = (1,1,1,1)
        _MainTex("Main Texture", 2D) = "white"{}
        _LineNumber("Line Number", Float) = 1
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
            uniform float4 _MainTex_ST;

            struct VertexInput
           {
               float4 vertex: POSITION;
               float4 texcoord: TEXCOORD0;
           };

           float drawLine(float2 uv, float number)
           {
               float nLine = number*2 + 1;
               float div = (uv.x / (1/nLine)) - (uv.x % (1/nLine));
               if(div % 2 > 1)
               {
                   return 1;
               }
               return 0;
           }


            struct VertexOutput
            {
                float4 pos : SV_POSITION;
                float4 texcoord: TEXCOORD0;
            };

            uniform sampler2D _MainTex;
            uniform float _LineNumber;

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
                float4 color = tex2D(_MainTex, i.texcoord) * _Color;
                color.a = drawLine(i.texcoord,_LineNumber);
                return color;
            }
            ENDCG
        }
    }
}
