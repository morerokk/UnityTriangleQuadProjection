Shader "Unlit/TriangleToQuad"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" "DisableBatching" = "true" }

		Pass
		{
			Cull Off
		
			CGPROGRAM
			#pragma geometry geom
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"

			struct appdata{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};
			 
			struct v2g{
				float4 objPos : SV_POSITION;
				float2 uv : TEXCOORD0;
			};
			 
			struct g2f{
				float4 worldPos : SV_POSITION;
				float2 uv : TEXCOORD0;
			};

			sampler2D _MainTex;
			
			v2g vert (appdata v)
			{
				v2g o;
				o.objPos = v.vertex;
				o.uv = v.uv;
				
				//UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			[maxvertexcount(6)]
			void geom (triangle v2g input[3], inout TriangleStream<g2f> tristream){
			
				float3 pos1 = input[0].objPos;
				float3 pos2 = input[1].objPos;
				
				float3 pos3 = float3(
					pos2.x,
					pos1.y,
					pos1.z
				);
			
				//First triangle
				g2f o;
				o.worldPos = UnityObjectToClipPos(pos1);
				o.uv = float2(0,0);
				tristream.Append(o);
			 
				o.worldPos = UnityObjectToClipPos(pos2);
				o.uv = float2(1,1);
				tristream.Append(o);
			 
				o.worldPos = UnityObjectToClipPos(pos3);
				o.uv = float2(0,1);
				tristream.Append(o);
			 
				tristream.RestartStrip();
				
				//Second triangle				
				pos3 = float3(
					pos1.x,
					pos2.y,
					pos2.z
				);
			
				o.worldPos = UnityObjectToClipPos(pos1);
				o.uv = float2(0,0);
				tristream.Append(o);
			 
				o.worldPos = UnityObjectToClipPos(pos2);
				o.uv = float2(1,1);
				tristream.Append(o);
			 
				o.worldPos = UnityObjectToClipPos(pos3);
				o.uv = float2(1,0);
				tristream.Append(o);
			 
				tristream.RestartStrip();
			}
			
			fixed4 frag (g2f i) : SV_Target
			{
				// sample the texture
				fixed4 col = tex2D(_MainTex, i.uv);
				return col;
			}
			ENDCG
		}
	}
}
