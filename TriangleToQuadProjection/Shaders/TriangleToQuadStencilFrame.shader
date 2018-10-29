Shader "QuadProjection/Stencil Frame"
{
	Properties
	{
		_Stencil("Stencil Value", Int) = 1
		[Enum(Both,0,Front,2,Back,1)] _Cull("Sidedness", Float) = 0.0
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" "DisableBatching" = "true" "Queue"="Geometry-1" }

		Pass
		{
			Stencil {
				Ref [_Stencil]
				Comp Always
				Pass Replace
			}
		
			Cull [_Cull]
			ZWrite Off
			ColorMask 0
		
			CGPROGRAM
			#pragma geometry geom
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog
			#pragma target 4.0
			
			#include "UnityCG.cginc"

			struct appdata{
				float4 vertex : POSITION;
			};
			 
			struct v2g{
				float4 objPos : SV_POSITION;
			};
			 
			struct g2f{
				float4 worldPos : SV_POSITION;
			};
			
			v2g vert (appdata v)
			{
				v2g o;
				o.objPos = v.vertex;
				
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
				tristream.Append(o);
				
				o.worldPos = UnityObjectToClipPos(pos3);
				tristream.Append(o);
			 
				o.worldPos = UnityObjectToClipPos(pos2);
				tristream.Append(o);
			 
				tristream.RestartStrip();
				
				//Second triangle				
				pos3 = float3(
					pos1.x,
					pos2.y,
					pos2.z
				);
			
				o.worldPos = UnityObjectToClipPos(pos1);
				tristream.Append(o);
			 
				o.worldPos = UnityObjectToClipPos(pos2);
				tristream.Append(o);
			 
				o.worldPos = UnityObjectToClipPos(pos3);
				tristream.Append(o);
			 
				tristream.RestartStrip();
			}
			
			fixed4 frag (g2f i) : SV_Target
			{				
				return fixed4(0,0,0,0);
			}
			ENDCG
		}
	}
}
