Shader "Unlit/thirdSh"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			float3 hash3(float2 p){
				//随机噪波常用公式：frac(sin(dot(i.uv.xy,float2(12.9898,78.233)))*43758.5453);
				//dot部分进行拆解（以下用q代替）----->三维向量（RGB）
				//以R进行分析：q.r = frac(sin(dot(p,float2(127.1,311.7)))*43758.5453);


				// float3 q = float3(dot(p,float2(127.1,311.7))
				// 	,dot(p,float2(269.5,183.3))
				// 	,dot(p,float2(419.2,371.9)));
				// return frac(sin(q)*43758.5453);

				p+=1;
				return frac(sin(p.x*p.y)*43758.5453);
			}
			float iqnoise(in float2 x,float u,float v){
				float2 p = floor(x);
				float2 f = frac(x);
				float k = 1.0+63.0*pow(1.0-v,4.0);//决定模糊程度
				float va= 0.0;
				float wt = 0.0;
				for(int j=-2;j<=2;j++){
					for(int i=-2;i<=2;i++){
						// float2 g = float2(float(i),float(j));
						float2 g = float2(i,j);
						float3 o = hash3(p+g)*float3(u,u,1.0);
						float2 r = g-f+o.xy;
						float d = dot(r,r);
						float ww = pow(1.0-smoothstep(0.0,1.414,sqrt(d)),k);//smoothstep--->柔和过渡效果
						va +=o.z*ww;
						wt+=ww;
					}
				}
				return va/wt;
			}
			fixed4 frag (v2f i) : SV_Target
			{
				float2 uv = i.uv * _ScreenParams / _ScreenParams.x;
				float2 p = 0.5-0.5*sin(_Time.y*float2(1.01,1.71));
				return iqnoise(24.0*uv,p.x,p.y);
				// return iqnoise(24.0*uv,0,0);
			}
			ENDCG
		}
	}
}
