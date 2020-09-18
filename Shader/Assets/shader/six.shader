Shader "Unlit/six"
{
	
	SubShader
	{
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

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
			
			fixed4 frag (v2f callB) : SV_Target
			{
				float3 c;
				float L_v,z=_Time.y;
				for(int j=0;j<3;j++){
					float2 uv;
					float2 p = callB.uv;//_ScreenParams.xy;
					uv = p;
					p-=0.5;
					p.x*=_ScreenParams.x/_ScreenParams.y;
					z+=0.07;
					L_v= length(p);
					uv +=p/L_v*(sin(z)+1.0)*abs(sin(L_v*9.0-z*2.0));
					c[j]=0.01/length(abs(fmod(uv,1.)-0.5));
				}
				return float4(c/L_v,_Time.y);
			}
			ENDCG
		}
	}
}
