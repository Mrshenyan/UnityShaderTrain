﻿Shader "Unlit/five"
{
	SubShader
	{

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			//粒子数量
			#define NUM_PARTICLES 200.0
			//粒子半径
			#define RADIUS_PARTICLES 0.025
			//粒子外发光
			#define GLOW 0.55

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
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}
			float3 Orb(float2 uv,float3 color,float radius,float offset){
				float2 position = float2(sin(offset*(_Time.y+30.)),cos(offset*(_Time.y+30.)));
				position *= sin((_Time.y)-offset)*cos(offset);
				radius =radius * offset;
				float dist = radius/distance(uv,position);
				return color*pow(dist,1.0/GLOW);
			}
			fixed4 frag (v2f i) : SV_Target
			{
				half ratio = _ScreenParams.x/_ScreenParams.y;

				// float2 uv = float2(_ScreenParams.xy-0.5)
				half2 centerUV = i.uv*2-1;
				centerUV.x*=ratio;

				float3 pixel,color = 0;
				color.r = (sin(_Time.y*0.55)+1.5)*0.4;
				color.g = (sin(_Time.y*0.34)+2.0)*0.4;
				color.b = (sin(_Time.y*0.31)+4.5)*0.3;

				for(int i=0.0;i<NUM_PARTICLES;i++){
					pixel+=Orb(centerUV,color,RADIUS_PARTICLES,i/NUM_PARTICLES);
				}
				float4 fragColor = lerp(float4(centerUV,0.8+0.5*sin(_Time.y),1.0),float4(pixel,1.0),0.8);
				return fragColor;
			}
			ENDCG
		}
	}
}
