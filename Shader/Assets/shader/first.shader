Shader "Unlit/Myfirst"{
    Properties{
        // _Color("Color",Color)=(1,1,1,1)
		_FrontTex("FrontTex",2d)="white"{}
		_BackTex("BackTex",2d)="black"{}
    }
    SubShader{
		cull off
        pass{
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
			#pragma target 3.0
			sampler2D _FrontTex;
			sampler2D _BackTex;
			struct adddata{
				float4 vertex:POSITION;
				float2 uv:TEXCOORD;
			};

			struct v2f{
				float4 pos:POSITION;
				float2 uv:TEXCOORD;
			};
			v2f vert(adddata v){
				v2f o;
				o.pos=UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}
			fixed checker(float2 uv){
				float2 repeatUV = uv*10;
				float2 c= floor(repeatUV)/2;
				float checker = frac(c.x+c.y)*2;
				return checker;
			}
			fixed4 frag(v2f i):SV_Target{
				fixed col = checker(i.uv);
				return col;
			}

			//  fixed4 frag(v2f i,float face:VFACE):SV_Target{
			// 	 fixed4 col = 1;
			// 	 col = face>0?tex2D(_FrontTex,i.uv):tex2D(_BackTex,i.uv);
			// 	 return col;
			//  }
            ENDCG
        }
    }
}