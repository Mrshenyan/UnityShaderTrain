Shader "Unlit/Seven"
{
	
	SubShader
	{

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"
			#define p1 (0.25,0.75)
			#define p2 (0.33,0.10)
			#define p3 (0.80,0.70)

			#define color1 (1.0,0.0,0.0)
			#define color2 (0.0,1.0,0.0)
			#define color3 (0.0,0.0,1.0)

			#define epsion 0.000001

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

			float cross2D(in float2 v1,in float2 v2){
				return v1.x * v2.y - v1.y*v2.x;
			}

			float triArea2D(in float2 c1,in float2 c2,in float2 c3){
				float2 ba = c2-c1;
				float2 ca = c3-c1;
				float z = cross2D(ba,ca);
				return abs(z)/2.0;
			}

			float3 barycentric(in float2 a,in float2 b,in float2 c,in float2 p){
				float abc = triArea2D(a,b,c);
				float bcp = triArea2D(b,c,p);
				float cap = triArea2D(c,a,p);
				float abp = triArea2D(a,b,p);
				return float3(bcp/abc,cap/abc,abp/abc);
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				float4 fragcolor=float4(1.0,1.0,1.0,1.0);
				float2 uv = i.uv.xy/_ScreenParams.xy;
				float3 uvw = barycentric(p1,p2,p3,uv);
				if(abs((uvw.x+uvw.y+uvw.z)-1.0)<epsion){
					float3 totalColor = (uvw.x*color1)+(uvw.y*color2)+(uvw.z*color3);
					fragcolor = float4(totalColor,1.0);
				}
				return fragcolor;
			}
			ENDCG
		}
	}
}
