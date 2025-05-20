#define USE_DEBUG_DRAWING
#define USE_ROUGHNESS_MAP // Not used

#define LIGHT_IBL
#define LIGHT_PUNCTUAL

#include "/defold-pbr/shaders/pbr_core.glsl"

void main()
{
	PBRParams params          = getPBRParams();
	MaterialInfo materialInfo = getMaterialInfo(params);
	PBRData pbrData           = getPBRData(params, materialInfo);
	CubemapData cubemapData   = getCubemapData();
	LightingInfo lightInfo    = getLighting(pbrData, cubemapData, params, materialInfo);

	vec3 lighting             = lightInfo.diffuse + lightInfo.specular;
	lighting                  = applyOcclusion(params, lightInfo, lighting);
	lighting                  = applyEmissive(params, lighting);
	
	gl_FragColor.rgb = exposure(lighting, PBR_CAMERA_EXPOSURE);
	gl_FragColor.a   = materialInfo.baseColor.a;
	gl_FragColor     = applyDebugMode(gl_FragColor, materialInfo, lightInfo, pbrData);
}
