Shader "Unlit/four"
{
	SubShader
	{
		Pass
		{
			CGPROGRAM
            #pragma target 3.5
			#include "UnityCG.cginc"

			struct v2f
			{
				float2 uv : TEXCOORD0;
            #pragma vertex vert
            #pragma fragment frag
				float4 vertex : SV_POSITION;
			};
			
			v2f vert (appdata_base v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.texcoord;
				return o;
			}

			fixed3 hsv2rgb_01(float3 hsv){
				fixed R,G,B = hsv.z;
				fixed h = hsv.x;
				fixed s =hsv.y;
				fixed v = hsv.z;
				h*=6;
				fixed i=floor(h);
				fixed f = h-i;
				fixed p = v* (1-s);
				fixed q = v*(1-s*f);
				fixed t = v*(1-s*(1-f));
				switch(i){
					case 0:{
						R = v;G=t;B=p;
						break;
					}
					case 1:{
						R = q;G=v;B=p;
						break;
					}
					case 2:{
						R = p;G=v;B=t;
						break;
					}
					case 3:{
						R = p;G=q;B=v;
						break;
					}
					case 4:{
						R = t;G=p;B=v;
						break;
					}
					default:{
						R = v;G=p;B=q;
						break;
					}
				}
				return fixed3(R,G,B);
			}
			fixed3 hsv2rgb_02(float3 c){
				float3 m=fmod(float3(5,3,1)+c.x*6,6);
				return c.z-c.z*c.y*max(min(min(m,4-m),1),0);
			}
			 //HSV2RGB(取自ASE中的算法，替代版的优化版本)
			fixed3 hsv2rgb_03(float3 c)
			{
				float4 K = float4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
				float3 p = abs(frac(c.xxx + K.xyz) * 6.0 - K.www);
				return c.z * lerp(K.xxx, saturate(p - K.xxx), c.y);
			}
            
			float3 RGB2HSV(float3 c){
				float4 k = float4(0.0,-1.0/3.0,2.0/3.0,-1.0);
				float4 p = lerp(float4(c.bg,k.wz),float4(c.gb,k.xy),step(c.b,c.g));
				float4 q = lerp(float4(p.xyw,c.r),float4(c.r,p.xyz),step(p.x,c.r));

				float d = q.x-min(q.w,q.y);
				float e = 1.0e-10;
				return float3(abs(q.z+(q.w-q.y)/(6.0*d+e)),d/(q.x+e),q.x);
			}
			fixed4 frag (v2f i) : SV_Target
			{
				float2 thsv =0.5+0.5* cos(_Time.y*(float2(i.uv.x,i.uv.y)));
				fixed3 hsv = fixed3(thsv.x,1,thsv.y);
				// return fixed4(hsv2rgb_01(hsv),1);
				// return fixed4(hsv2rgb_02(hsv),1);
				return fixed4(hsv2rgb_03(hsv),1);
			}
			ENDCG
		}
	}
}
