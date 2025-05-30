Shader "FairyGUI/TextMeshPro/Distance Field" {

Properties {
	_FaceTex			("Face Texture", 2D) = "white" {}
	_FaceUVSpeedX		("Face UV Speed X", Range(-5, 5)) = 0.0
	_FaceUVSpeedY		("Face UV Speed Y", Range(-5, 5)) = 0.0
	_FaceColor			("Face Color", Color) = (1,1,1,1)
	_FaceDilate			("Face Dilate", Range(-1,1)) = 0

	_OutlineColor		("Outline Color", Color) = (0,0,0,1)
	_OutlineTex			("Outline Texture", 2D) = "white" {}
	_OutlineUVSpeedX	("Outline UV Speed X", Range(-5, 5)) = 0.0
	_OutlineUVSpeedY	("Outline UV Speed Y", Range(-5, 5)) = 0.0
	_OutlineWidth		("Outline Thickness", Range(0, 1)) = 0
	_OutlineSoftness	("Outline Softness", Range(0,1)) = 0

	_Bevel				("Bevel", Range(0,1)) = 0.5
	_BevelOffset		("Bevel Offset", Range(-0.5,0.5)) = 0
	_BevelWidth			("Bevel Width", Range(-.5,0.5)) = 0
	_BevelClamp			("Bevel Clamp", Range(0,1)) = 0
	_BevelRoundness		("Bevel Roundness", Range(0,1)) = 0

	_LightAngle			("Light Angle", Range(0.0, 6.2831853)) = 3.1416
	_SpecularColor		("Specular", Color) = (1,1,1,1)
	_SpecularPower		("Specular", Range(0,4)) = 2.0
	_Reflectivity		("Reflectivity", Range(5.0,15.0)) = 10
	_Diffuse			("Diffuse", Range(0,1)) = 0.5
	_Ambient			("Ambient", Range(1,0)) = 0.5

	_BumpMap 			("Normal map", 2D) = "bump" {}
	_BumpOutline		("Bump Outline", Range(0,1)) = 0
	_BumpFace			("Bump Face", Range(0,1)) = 0

	_ReflectFaceColor	("Reflection Color", Color) = (0,0,0,1)
	_ReflectOutlineColor("Reflection Color", Color) = (0,0,0,1)
	_Cube 				("Reflection Cubemap", Cube) = "black" { /* TexGen CubeReflect */ }
	_EnvMatrixRotation	("Texture Rotation", vector) = (0, 0, 0, 0)
		

	_UnderlayColor		("Border Color", Color) = (0,0,0, 0.5)
	_UnderlayOffsetX	("Border OffsetX", Range(-1,1)) = 0
	_UnderlayOffsetY	("Border OffsetY", Range(-1,1)) = 0
	_UnderlayDilate		("Border Dilate", Range(-1,1)) = 0
	_UnderlaySoftness	("Border Softness", Range(0,1)) = 0

	_GlowColor			("Color", Color) = (0, 1, 0, 0.5)
	_GlowOffset			("Offset", Range(-1,1)) = 0
	_GlowInner			("Inner", Range(0,1)) = 0.05
	_GlowOuter			("Outer", Range(0,1)) = 0.05
	_GlowPower			("Falloff", Range(1, 0)) = 0.75

	_WeightNormal		("Weight Normal", float) = 0
	_WeightBold			("Weight Bold", float) = 0.5

	_ShaderFlags		("Flags", float) = 0
	_ScaleRatioA		("Scale RatioA", float) = 1
	_ScaleRatioB		("Scale RatioB", float) = 1
	_ScaleRatioC		("Scale RatioC", float) = 1

	_MainTex			("Font Atlas", 2D) = "white" {}
	_TextureWidth		("Texture Width", float) = 512
	_TextureHeight		("Texture Height", float) = 512
	_GradientScale		("Gradient Scale", float) = 5.0
	_ScaleX				("Scale X", float) = 1.0
	_ScaleY				("Scale Y", float) = 1.0
	_PerspectiveFilter	("Perspective Correction", Range(0, 1)) = 0.875
	_Sharpness			("Sharpness", Range(-1,1)) = 0

	_VertexOffsetX		("Vertex OffsetX", float) = 0
	_VertexOffsetY		("Vertex OffsetY", float) = 0
	
	_MaskCoord			("Mask Coordinates", vector) = (0, 0, 32767, 32767)
	_ClipRect			("Clip Rect", vector) = (-32767, -32767, 32767, 32767)
	_MaskSoftnessX		("Mask SoftnessX", float) = 0
	_MaskSoftnessY		("Mask SoftnessY", float) = 0

	_StencilComp		("Stencil Comparison", Float) = 8
	_Stencil			("Stencil ID", Float) = 0
	_StencilOp			("Stencil Operation", Float) = 0
	_StencilWriteMask	("Stencil Write Mask", Float) = 255
	_StencilReadMask	("Stencil Read Mask", Float) = 255

	_ColorMask			("Color Mask", Float) = 15

    _BlendSrcFactor ("Blend SrcFactor", Float) = 1
    _BlendDstFactor ("Blend DstFactor", Float) = 10
}

SubShader {

	Tags
	{
		"Queue"="Transparent"
		"IgnoreProjector"="True"
		"RenderType"="Transparent"
	}

	Stencil
	{
		Ref [_Stencil]
		Comp [_StencilComp]
		Pass [_StencilOp] 
		ReadMask [_StencilReadMask]
		WriteMask [_StencilWriteMask]
	}

	Cull [_CullMode]
	ZWrite Off
	Lighting Off
	Fog { Mode Off }
	ZTest [unity_GUIZTestMode]
    
    Blend [_BlendSrcFactor] [_BlendDstFactor]
	ColorMask [_ColorMask]

	Pass {
		CGPROGRAM
		#pragma target 3.0
		#pragma vertex VertShader
		#pragma fragment PixShader
		//#pragma shader_feature __ BEVEL_ON
		#pragma shader_feature __ UNDERLAY_ON UNDERLAY_INNER
		//#pragma shader_feature __ GLOW_ON

		//#pragma multi_compile __ UNITY_UI_CLIP_RECT
		//#pragma multi_compile __ UNITY_UI_ALPHACLIP
		#pragma multi_compile _ GRAYED
		#pragma multi_compile _ CLIPPED SOFT_CLIPPED

		#include "UnityCG.cginc"
		#include "UnityUI.cginc"

		//begin copy
		//#include "Assets/TextMesh Pro/Shaders/TMPro_Properties.cginc"
		//#include "Assets/TextMesh Pro/Shaders/TMPro.cginc"

		// UI Editable properties
		uniform sampler2D	_FaceTex;					// Alpha : Signed Distance
		uniform float		_FaceUVSpeedX;
		uniform float		_FaceUVSpeedY;
		uniform fixed4		_FaceColor;					// RGBA : Color + Opacity
		uniform float		_FaceDilate;				// v[ 0, 1]
		uniform float		_OutlineSoftness;			// v[ 0, 1]

		uniform sampler2D	_OutlineTex;				// RGBA : Color + Opacity
		uniform float		_OutlineUVSpeedX;
		uniform float		_OutlineUVSpeedY;
		uniform fixed4		_OutlineColor;				// RGBA : Color + Opacity
		uniform float		_OutlineWidth;				// v[ 0, 1]

		uniform float		_Bevel;						// v[ 0, 1]
		uniform float		_BevelOffset;				// v[-1, 1]
		uniform float		_BevelWidth;				// v[-1, 1]
		uniform float		_BevelClamp;				// v[ 0, 1]
		uniform float		_BevelRoundness;			// v[ 0, 1]

		uniform sampler2D	_BumpMap;					// Normal map
		uniform float		_BumpOutline;				// v[ 0, 1]
		uniform float		_BumpFace;					// v[ 0, 1]

		uniform samplerCUBE	_Cube;						// Cube / sphere map
		uniform fixed4 		_ReflectFaceColor;			// RGB intensity
		uniform fixed4		_ReflectOutlineColor;
		//uniform float		_EnvTiltX;					// v[-1, 1]
		//uniform float		_EnvTiltY;					// v[-1, 1]
		uniform float3      _EnvMatrixRotation;
		uniform float4x4	_EnvMatrix;

		uniform fixed4		_SpecularColor;				// RGB intensity
		uniform float		_LightAngle;				// v[ 0,Tau]
		uniform float		_SpecularPower;				// v[ 0, 1]
		uniform float		_Reflectivity;				// v[ 5, 15]
		uniform float		_Diffuse;					// v[ 0, 1]
		uniform float		_Ambient;					// v[ 0, 1]

		uniform fixed4		_UnderlayColor;				// RGBA : Color + Opacity
		uniform float		_UnderlayOffsetX;			// v[-1, 1]
		uniform float		_UnderlayOffsetY;			// v[-1, 1]
		uniform float		_UnderlayDilate;			// v[-1, 1]
		uniform float		_UnderlaySoftness;			// v[ 0, 1]

		uniform fixed4 		_GlowColor;					// RGBA : Color + Intesity
		uniform float 		_GlowOffset;				// v[-1, 1]
		uniform float 		_GlowOuter;					// v[ 0, 1]
		uniform float 		_GlowInner;					// v[ 0, 1]
		uniform float 		_GlowPower;					// v[ 1, 1/(1+4*4)]

		// API Editable properties
		uniform float 		_ShaderFlags;
		uniform float		_WeightNormal;
		uniform float		_WeightBold;

		uniform float		_ScaleRatioA;
		uniform float		_ScaleRatioB;
		uniform float		_ScaleRatioC;

		uniform float		_VertexOffsetX;
		uniform float		_VertexOffsetY;

		//uniform float		_UseClipRect;
		uniform float		_MaskID;
		uniform sampler2D	_MaskTex;
		uniform float4		_MaskCoord;
		uniform float4		_ClipRect;	// bottom left(x,y) : top right(z,w)
		//uniform float		_MaskWipeControl;
		//uniform float		_MaskEdgeSoftness;
		//uniform fixed4		_MaskEdgeColor;
		//uniform bool		_MaskInverse;

		uniform float		_MaskSoftnessX;
		uniform float		_MaskSoftnessY;

		// Font Atlas properties
		uniform sampler2D	_MainTex;
		uniform float		_TextureWidth;
		uniform float		_TextureHeight;
		uniform float 		_GradientScale;
		uniform float		_ScaleX;
		uniform float		_ScaleY;
		uniform float		_PerspectiveFilter;
		uniform float		_Sharpness;

		float2 UnpackUV(float uv)
		{ 
			float2 output;
			output.x = floor(uv / 4096);
			output.y = uv - 4096 * output.x;
		
			return output * 0.001953125;
		}
		
		fixed4 GetColor(half d, fixed4 faceColor, fixed4 outlineColor, half outline, half softness)
		{
			half faceAlpha = 1-saturate((d - outline * 0.5 + softness * 0.5) / (1.0 + softness));
			half outlineAlpha = saturate((d + outline * 0.5)) * sqrt(min(1.0, outline));
		
			faceColor.rgb *= faceColor.a;
			outlineColor.rgb *= outlineColor.a;
		
			faceColor = lerp(faceColor, outlineColor, outlineAlpha);
		
			faceColor *= faceAlpha;
		
			return faceColor;
		}
		
		//end copy


		struct vertex_t {
			UNITY_VERTEX_INPUT_INSTANCE_ID
			float4	position		: POSITION;
			float3	normal			: NORMAL;
			fixed4	color			: COLOR;
			float2	texcoord0		: TEXCOORD0;
			float2	texcoord1		: TEXCOORD1;
		};


		struct pixel_t {
			UNITY_VERTEX_INPUT_INSTANCE_ID
			UNITY_VERTEX_OUTPUT_STEREO
			float4	position		: SV_POSITION;
			fixed4	color			: COLOR;
			float2	atlas			: TEXCOORD0;		// Atlas
			float4	param			: TEXCOORD1;		// alphaClip, scale, bias, weight
			float2	mask			: TEXCOORD2;		// Position in object space(xy), pixel Size(zw)
			float3	viewDir			: TEXCOORD3;
			
		#if (UNDERLAY_ON || UNDERLAY_INNER)
			float4	texcoord2		: TEXCOORD4;		// u,v, scale, bias
			fixed4	underlayColor	: COLOR1;
		#endif
			float4 textures			: TEXCOORD5;
		};

		// Used by Unity internally to handle Texture Tiling and Offset.
		float4 _FaceTex_ST;
		float4 _OutlineTex_ST;

		CBUFFER_START(UnityPerMaterial)
		#ifdef CLIPPED
		float4 _ClipBox = float4(-2, -2, 0, 0);
		#endif

		#ifdef SOFT_CLIPPED
		float4 _ClipBox = float4(-2, -2, 0, 0);
		float4 _ClipSoftness = float4(0, 0, 0, 0);
		#endif
		CBUFFER_END

		pixel_t VertShader(vertex_t input)
		{
			pixel_t output;

			UNITY_INITIALIZE_OUTPUT(pixel_t, output);
			UNITY_SETUP_INSTANCE_ID(input);
			UNITY_TRANSFER_INSTANCE_ID(input,output);
			UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(output);

			float bold = step(input.texcoord1.y, 0);

			float4 vert = input.position;
			vert.x += _VertexOffsetX;
			vert.y += _VertexOffsetY;

			float4 vPosition = UnityObjectToClipPos(vert);

			float2 pixelSize = vPosition.w;
			pixelSize /= float2(_ScaleX, _ScaleY) * abs(mul((float2x2)UNITY_MATRIX_P, _ScreenParams.xy));
			float scale = rsqrt(dot(pixelSize, pixelSize));
			scale *= abs(input.texcoord1.y) * _GradientScale * (_Sharpness + 1);
			if (UNITY_MATRIX_P[3][3] == 0) scale = lerp(abs(scale) * (1 - _PerspectiveFilter), scale, abs(dot(UnityObjectToWorldNormal(input.normal.xyz), normalize(WorldSpaceViewDir(vert)))));

			float weight = lerp(_WeightNormal, _WeightBold, bold) / 4.0;
			weight = (weight + _FaceDilate) * _ScaleRatioA * 0.5;

			float bias =(.5 - weight) + (.5 / scale);

			float alphaClip = (1.0 - _OutlineWidth * _ScaleRatioA - _OutlineSoftness * _ScaleRatioA);
		
		// #if GLOW_ON
		// 	alphaClip = min(alphaClip, 1.0 - _GlowOffset * _ScaleRatioB - _GlowOuter * _ScaleRatioB);
		// #endif

			alphaClip = alphaClip / 2.0 - ( .5 / scale) - weight;

		#if (UNDERLAY_ON || UNDERLAY_INNER)
			float4 underlayColor = _UnderlayColor;
			underlayColor.rgb *= underlayColor.a;

			float bScale = scale;
			bScale /= 1 + ((_UnderlaySoftness*_ScaleRatioC) * bScale);
			float bBias = (0.5 - weight) * bScale - 0.5 - ((_UnderlayDilate * _ScaleRatioC) * 0.5 * bScale);

			float x = -(_UnderlayOffsetX * _ScaleRatioC) * _GradientScale / _TextureWidth;
			float y = -(_UnderlayOffsetY * _ScaleRatioC) * _GradientScale / _TextureHeight;
			float2 bOffset = float2(x, y);
		#endif

			// Generate UV for the Masking Texture
			// float4 clampedRect = clamp(_ClipRect, -2e10, 2e10);
			// float2 maskUV = (vert.xy - clampedRect.xy) / (clampedRect.zw - clampedRect.xy);

			// Support for texture tiling and offset
			float2 textureUV = UnpackUV(input.texcoord1.x);
			//float2 faceUV = TRANSFORM_TEX(textureUV, _FaceTex);
			//float2 outlineUV = TRANSFORM_TEX(textureUV, _OutlineTex);

			output.position = vPosition;
			#if !defined(UNITY_COLORSPACE_GAMMA) && (UNITY_VERSION >= 550)
			output.color.rgb = GammaToLinearSpace(input.color.rgb);
			output.color.a = input.color.a;
			#else
			output.color = input.color;
			#endif
			output.atlas =	input.texcoord0;
			output.param =	float4(alphaClip, scale, bias, weight);
			//output.mask = half4(vert.xy * 2 - clampedRect.xy - clampedRect.zw, 0.25 / (0.25 * half2(_MaskSoftnessX, _MaskSoftnessY) + pixelSize.xy));
			output.viewDir =	mul((float3x3)_EnvMatrix, _WorldSpaceCameraPos.xyz - mul(unity_ObjectToWorld, vert).xyz);
			#if (UNDERLAY_ON || UNDERLAY_INNER)
			output.texcoord2 = float4(input.texcoord0 + bOffset, bScale, bBias);
			output.underlayColor = underlayColor;
			#endif
			//output.textures = float4(faceUV, outlineUV);
	
			#ifdef CLIPPED
			output.mask = mul(unity_ObjectToWorld, input.position).xy * _ClipBox.zw + _ClipBox.xy;
			#endif

			#ifdef SOFT_CLIPPED
			output.mask = mul(unity_ObjectToWorld, input.position).xy * _ClipBox.zw + _ClipBox.xy;
			#endif

			return output;
		}


		fixed4 PixShader(pixel_t input) : SV_Target
		{
			UNITY_SETUP_INSTANCE_ID(input);

			float c = tex2D(_MainTex, input.atlas).a;
		
		#ifndef UNDERLAY_ON
			clip(c - input.param.x);
		#endif

			float	scale	= input.param.y;
			float	bias	= input.param.z;
			float	weight	= input.param.w;
			float	sd = (bias - c) * scale;

			float outline = (_OutlineWidth * _ScaleRatioA) * scale;
			float softness = (_OutlineSoftness * _ScaleRatioA) * scale;

			half4 faceColor = _FaceColor;
			half4 outlineColor = _OutlineColor;

			faceColor.rgb *= input.color.rgb;
			
			//faceColor *= tex2D(_FaceTex, input.textures.xy + float2(_FaceUVSpeedX, _FaceUVSpeedY) * _Time.y);
			//outlineColor *= tex2D(_OutlineTex, input.textures.zw + float2(_OutlineUVSpeedX, _OutlineUVSpeedY) * _Time.y);

			faceColor = GetColor(sd, faceColor, outlineColor, outline, softness);

		// #if BEVEL_ON
		// 	float3 dxy = float3(0.5 / _TextureWidth, 0.5 / _TextureHeight, 0);
		// 	float3 n = GetSurfaceNormal(input.atlas, weight, dxy);

		// 	float3 bump = UnpackNormal(tex2D(_BumpMap, input.textures.xy + float2(_FaceUVSpeedX, _FaceUVSpeedY) * _Time.y)).xyz;
		// 	bump *= lerp(_BumpFace, _BumpOutline, saturate(sd + outline * 0.5));
		// 	n = normalize(n- bump);

		// 	float3 light = normalize(float3(sin(_LightAngle), cos(_LightAngle), -1.0));

		// 	float3 col = GetSpecular(n, light);
		// 	faceColor.rgb += col*faceColor.a;
		// 	faceColor.rgb *= 1-(dot(n, light)*_Diffuse);
		// 	faceColor.rgb *= lerp(_Ambient, 1, n.z*n.z);

		// 	fixed4 reflcol = texCUBE(_Cube, reflect(input.viewDir, -n));
		// 	faceColor.rgb += reflcol.rgb * lerp(_ReflectFaceColor.rgb, _ReflectOutlineColor.rgb, saturate(sd + outline * 0.5)) * faceColor.a;
		// #endif

		#if UNDERLAY_ON
			float d = tex2D(_MainTex, input.texcoord2.xy).a * input.texcoord2.z;
			faceColor += input.underlayColor * saturate(d - input.texcoord2.w) * (1 - faceColor.a);
		#endif

		#if UNDERLAY_INNER
			float d = tex2D(_MainTex, input.texcoord2.xy).a * input.texcoord2.z;
			faceColor += input.underlayColor * (1 - saturate(d - input.texcoord2.w)) * saturate(1 - sd) * (1 - faceColor.a);
		#endif

		// #if GLOW_ON
		// 	float4 glowColor = GetGlowColor(sd, scale);
		// 	faceColor.rgb += glowColor.rgb * glowColor.a;
		// #endif

		// Alternative implementation to UnityGet2DClipping with support for softness.
		// #if UNITY_UI_CLIP_RECT
		// 	half2 m = saturate((_ClipRect.zw - _ClipRect.xy - abs(input.mask.xy)) * input.mask.zw);
		// 	faceColor *= m.x * m.y;
		// #endif

		// #if UNITY_UI_ALPHACLIP
		// 	clip(faceColor.a - 0.001);
		// #endif

		#ifdef GRAYED
			fixed grey = dot(faceColor.rgb, fixed3(0.299, 0.587, 0.114));  
			faceColor.rgb = fixed3(grey, grey, grey);
		#endif

		#ifdef CLIPPED
			float2 factor = abs(input.mask);
			clip(1-max(factor.x, factor.y));
		#endif

		#ifdef SOFT_CLIPPED
			float2 factor;
			float2 condition = step(input.mask.xy, 0);
			float4 clip_softness = _ClipSoftness * float4(condition, 1 - condition);
			factor.xy = (1.0 - abs(input.mask.xy)) * (clip_softness.xw + clip_softness.zy);
			faceColor.a *= clamp(min(factor.x, factor.y), 0.0, 1.0);
			clip(faceColor.a - 0.001);
		#endif
		return faceColor * input.color.a;
}

		ENDCG
	}
}

//Fallback "TextMeshPro/Mobile/Distance Field"
CustomEditor "TMPro.EditorUtilities.TMP_SDFShaderGUI"
}
