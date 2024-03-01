Shader "Unlit/RadarScreen"
{
    Properties
    {
        _Color1 ("Main Color", Color) = (1,1,1,1)
        _Color2 ("Secondary Color", Color) = (1,1,1,1)
        _NCircles ("Number Of Circles", Float) = 3
        _CThickness ("Circles Thickness", Float) = 0.1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            LOD 200
            Cull Off
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            uniform half4 _Color1;
            uniform half4 _Color2;
            uniform float _NCircles;
            uniform float _CThickness;

            #include "UnityCG.cginc"

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


             VertexOutput vert(VertexInput v)
           {
               VertexOutput o;

               o.texcoord.xy = v.texcoord;
               o.pos = UnityObjectToClipPos(v.vertex);
               
               return o;
           }

            float DistFromCenter (float2 uv){

                float2 center = (0.5,0.5);
                return (distance(center,uv));
            }

            half4 frag (VertexOutput i) : Color
            {
                float4 col= (0,0,0,0);
                float circleRatio = 1/_NCircles;

                if( ((DistFromCenter(i.texcoord) % circleRatio) < _CThickness) && (DistFromCenter(i.texcoord) < 0.5) )
                {
                    col = _Color1;
                }
                else
                {
                    col = _Color2;
                }
                return col;
            }
            ENDCG
        }
    }
}
