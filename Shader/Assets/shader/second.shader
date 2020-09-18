Shader "Unlit/second"
{
	SubShader
	{
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			struct adddata {
				float4 vertex:POSITION;
				float2 uv :TEXCOORD0;
			};

			struct v2f{
				float2 uv:TEXCOORD0;
				float4 vertex :SV_POSITION;
			};

			v2f vert(adddata v){
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}

			const float MATH_PI=3.14159265359;
			//旋转
			void Rotate(inout float2 p,float a){
				p = cos(a)* p + sin(a)*float2(p.y,-p.x);
			}
			//随机
			float Rand( float2 c )
			{
				return frac( sin( dot( c.xy, float2( 12.9898, 78.233 ) ) ) * 43758.5453 );
			}
			//像素格连续生成
			void BokenhLayer(inout fixed3 color,float2 p,float3 c){
				float wrap = 450.0;
				//像素格连续生成
				if(fmod(floor(p.y/wrap+0.5),2.0)==0.0){
					p.x+=wrap*0.5;
				}
				float2 pTemp=p+0.5*450;
				float2 p2 = pTemp-450*floor(pTemp/450)-0.5*450;
				float2 cell = floor(p/wrap+0.5);
				float cellR = Rand(cell);
				//降低饱和度，对比度
				c *= frac(cellR*3.33+3.33);
				//半径
				float radius = lerp(30.0,70.0,cellR);
				//拉伸
				p2.x *=lerp(0.9,1.1,frac(cellR*11.13+11.13));
				p2.y*=lerp(0.9,1.1,frac(cellR*17.17+17.17));

				//画圆，圆周发光
				float sdf = (length(p2/radius)-1.0)*radius;
				float circle=1.0-smoothstep(0.0,1.0,sdf*0.04);
				float glow = exp(-sdf*0.025)*0.3*(1.0-circle);
				color+=c*(circle+glow);
				// color+=c;
			}

			fixed4 frag(v2f i):SV_Target{
				// float3 col = 0.5+0.5*cos(_Time.y+i.uv.x+float3(0,2,4));
				//背景色
				float3 col = lerp(float3(0.3,0.1,0.3),float3(0.1,0.3,0.5),i.uv.y);
				float4 finalCol = float4(col,1.0);
				//坐标按屏幕像素进行偏移
				float2 p = 2.0*(i.uv*_ScreenParams.xy)-_ScreenParams.xy;//float2((2.0*(i.uv.x*_ScreenParams.x)-_ScreenParams.x),(2.0*(i.uv.y*_ScreenParams.y)-_ScreenParams.y));
				//分层绘制
				float time = _Time.x;
				float t = 0.2+time*0.003;
				Rotate(p,0.2+time*0.003);
				BokenhLayer(col,p+float2(-500.0*time+0.0,0.0),3.0*float3(0.4,0.1,0.2));
				Rotate(p,0.3-time*0.5);
				BokenhLayer(col,p+float2(-700.0*time+33.0,-33.0),3.0*float3(0.6,0.4,0.2));
				Rotate(p,0.5+time*0.7);
				BokenhLayer(col,p+float2(-600.0*time+55.0,55.0),3.0*float3(0.4,0.3,0.2));
				Rotate(p,0.9-time*0.3);
				BokenhLayer(col,p+float2(-250.0*time+77.0,77.0),3.0*float3(0.4,0.2,0.1));
				Rotate(p,0.0+time*0.5);
				BokenhLayer(col,p+float2(-150.0*time+99.0,99.0),3.0*float3(0.2,0.0,0.4));
				
				return fixed4(col,1.0);
			}
			ENDCG
		}
	}


}
