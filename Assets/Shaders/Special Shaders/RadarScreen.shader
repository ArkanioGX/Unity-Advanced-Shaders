Shader "Unlit/RadarScreen"
{
    Properties
    {
        _Color1 ("Main Color", Color) = (1,1,1,1)
        _Color2 ("Secondary Color", Color) = (1,1,1,1)
        _NCircles ("Number Of Circles", Float) = 3
        _CThickness ("Circles Thickness", Float) = 0.1

        _CTrailLength ("TrailLength", Float) = 0.1
        _CTrailSpeed ("TrailSpeed", Float) = 0.1
        _ColorTrail ("Trail Color", Color) = (1,1,1,1)

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
            uniform float _CTrailLength;
            uniform float _CTrailSpeed;
            uniform half4 _ColorTrail;

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

            float AngleFromCenter(float2 uv)
            {
                float2 center = (0.5, 0.5);
                float2 angVector = uv - center;
    
    return 1 - ((degrees(atan2(angVector.y, angVector.x) + _Time * 45) % 360) / 360);
}


        
            half4 frag (VertexOutput i) : Color
            {
                float4 col= (0,0,0,0);
                float circleRatio = 1/_NCircles;
    
    
                
                float2 center = (0.5, 0.5);
                if (((DistFromCenter(i.texcoord) % circleRatio) < _CThickness) && (DistFromCenter(i.texcoord) < 0.5) || abs(center.x - i.texcoord.x) < (_CThickness / 2) || abs(center.y - i.texcoord.y) < (_CThickness/2))
                {
                    col = _Color1;
                }
                else
                {
                    col = _Color2;
                }
    
                col = col + (AngleFromCenter(i.texcoord) * _ColorTrail * _ColorTrail.a);
                
                return col;
}
            ENDCG
        }
    }
}
