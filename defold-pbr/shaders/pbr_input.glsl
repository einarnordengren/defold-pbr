#ifndef PBR_INPUT
#define PBR_INPUT

	varying highp   vec4 var_position_world;
	varying mediump vec3 var_color;
	varying mediump vec3 var_normal;
	varying mediump vec3 var_tangent;
	varying mediump vec2 var_texcoord0;
	varying mediump vec2 var_texcoord1;
	varying mediump mat3 var_TBN;

	// Environment inputs
	uniform mediump samplerCube tex_diffuse_irradiance_skybox;
	uniform mediump samplerCube tex_prefiltered_reflection_skybox;
	uniform mediump samplerCube tex_diffuse_irradiance_parallax;
	uniform mediump samplerCube tex_prefiltered_reflection_parallax;
	uniform mediump sampler2D   tex_brdflut;

	// Material inputs
	uniform lowp sampler2D tex_albedo;
	uniform lowp sampler2D tex_normal;
	uniform lowp sampler2D tex_metallic_roughness;
	uniform lowp sampler2D tex_occlusion;
	uniform lowp sampler2D tex_emissive;

	uniform mediump vec4 u_camera_position;
	uniform mediump mat4 u_cubemap_world_to_local;
	uniform mediump vec4 u_cubemap_position;

	// col 0: xyz: position
	// col 1: xyz: direction
	// col 2: xyz: color
	// col 3: x: type

	uniform mediump vec4 u_pbr_params_0;
	uniform mediump vec4 u_pbr_params_1;
	uniform mediump vec4 u_pbr_params_2;
	uniform mediump vec4 u_pbr_scene_params;

	#define PBR_LIGHT_COUNT     int(u_pbr_scene_params.y)
	#define PBR_CAMERA_EXPOSURE u_pbr_scene_params.z

	struct PBRParams
	{
		vec4  baseColor;
		float metallic;
		float roughness;
		int   lightCount;
		bool  hasAlbedoTexture;
		bool  hasNormalTexture;
		bool  hasEmissiveTexture;
		bool  hasMetallicRoughnessTexture;
		bool  hasOcclusionTexture;
	};

	struct MaterialInfo
	{
		vec4  baseColor;
		vec3  diffuseColor;
		float ior;
		vec3  f0;
		vec3  f90;
		float specularWeight;
		float metallic;
		float perceptualRoughness;
		float alphaRoughness;
	};

	struct PBRData
	{
		vec3 vertexPositionWorld;
		vec3 vertexDirectionToCamera;
		vec3 vertexNormal;
	};

	struct CubemapData
	{
		bool useParallaxCubemap;
		mat4 cubemapWorldToLocal;
		vec3 cubemapPosition;
	};
#endif
