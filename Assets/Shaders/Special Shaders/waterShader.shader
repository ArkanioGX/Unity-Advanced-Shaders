Shader "Unlit/WaterShader"
{
    Properties
    {
        _Color1 ("Main Color", Color) = (1,1,1,1)
        _Color2 ("Secondary Color", Color) = (1,1,1,1)
        _NoiseTex("Random Texture", 2D) = "white"{}
        _Speed ("Water Speed", Float) = 1
        _Frequency ("Water Frequency", Float) = 1
        _Amplitude ("Water Amplitude", Float) = 1
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
            uniform half4 _Color1;
            uniform half4 _Color2;
            uniform float4 _NoiseTex_ST;
            uniform float _Speed;
            uniform float _Frequency;
            uniform float _Amplitude;

            
            

            struct VertexInput
           {
               float4 vertex: POSITION;
               float4 normal: NORMAL;
               float4 texcoord: TEXCOORD0;
               float4 tangent: TANGENT;
           };


            struct VertexOutput
            {
                float4 pos : SV_POSITION;
                float4 texcoord: TEXCOORD0;
                float heightValue: DISPLACEMENT ;
            };

            float4 vertexAnimWater(float4 pos, float2 uv)
            {
               pos.y = (sin((uv.x - _Time.y * _Speed) * _Frequency) * _Amplitude);
               return pos;
            }


            uniform sampler2D _NoiseTex;

            VertexOutput vert(VertexInput v)
           {
               VertexOutput o;

               float displacement = tex2Dlod(_NoiseTex, v.texcoord* _NoiseTex_ST);
               o.pos =  UnityObjectToClipPos(v.vertex + (v.normal * displacement*0.1f ) * vertexAnimWater(v.vertex,v.texcoord));
               o.heightValue = ((displacement + ((vertexAnimWater(v.vertex,v.texcoord).y)/(_Amplitude))+1)*0.5)*0.7;

  
               o.texcoord.xy = (v.texcoord.xy * _NoiseTex_ST.xy + _NoiseTex_ST.zw);

               return o;
           }


            half4 frag (VertexOutput i) : Color
            {
                float4 color = lerp(_Color1,_Color2,clamp(i.heightValue, 0, 1));
                return color;
            }
            ENDCG
        }
    }
}
