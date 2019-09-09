Shader "SpiritLoops/Debug"
{
	Properties
	{
		_MainTex("Abledo Texture", 2D) = "white" {}
	}
		SubShader
		{
			Tags { "RenderType" = "Opaque" "RenderPipeline" = "LightweightPipeline" "IgnoreProjector" = "True"}
			LOD 100

			Pass
			{
				CGPROGRAM

				#pragma prefer_hlslcc gles
				#pragma exclude_renderers d3d11_9x
				#pragma target 2.0

				#pragma vertex vert
				#pragma fragment frag
				#pragma multi_compile_instancing

				#include "UnityCG.cginc"

				struct appdata
				{
					float4 vertex : POSITION;
					float2 uv : TEXCOORD0;

					UNITY_VERTEX_INPUT_INSTANCE_ID
				};

				struct v2f
				{
					float4 vertex : SV_POSITION;
					float2 uv : TEXCOORD0;
					float3 posLocal : TEXCOORD1;
					float3 posWorld : TEXCOORD2;
					float3 normalWorld : TEXCOORD3;

					UNITY_VERTEX_INPUT_INSTANCE_ID
					UNITY_VERTEX_OUTPUT_STEREO
				};

				sampler2D _MainTex;
				float4 _MainTex_ST;

				v2f vert(appdata v)
				{
					v2f o = (v2f)0;

					UNITY_SETUP_INSTANCE_ID(v);
					UNITY_TRANSFER_INSTANCE_ID(v, o);
					UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
			
					// THIS IS how LWRP does UNLIT vertex input => clip space
					//VertexPositionInputs vertexInput = GetVertexPositionInputs(v.vertex.xyz);
					//float3 positionWS = TransformObjectToWorld(v.vertex.xyz);
					//float4 positionCS = TransformWorldToHClip(positionWS);
					float3 positionWS = mul(UNITY_MATRIX_M, float4(v.vertex.xyz, 1.0)).xyz;
					float4 cs = mul(UNITY_MATRIX_VP, float4(positionWS, 1.0));;
					o.vertex = cs;

					//o.vertex = UnityObjectToClipPos(float4(v.vertex.xyz, 1.0));
					o.uv = v.uv;
					
					return o;
				}

				fixed4 frag(v2f i) : SV_Target
				{
					UNITY_SETUP_INSTANCE_ID(i);
					UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);

					fixed4 col = tex2D(_MainTex, i.uv);

				   return col;
			   }
			   ENDCG
		   }
		}
}
