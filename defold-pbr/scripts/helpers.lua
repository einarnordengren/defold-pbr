
local M = {}

M.LIGHT_TYPE = {
	DIRECTIONAL = 0,
	POINT       = 1,
}

M.make_irradiance_texture = function(w, h, name)
	local targs = {
		type   = resource.TEXTURE_TYPE_CUBE_MAP,
		width  = w,
		height = h,
		format = resource.TEXTURE_FORMAT_RGBA16F
	}
	return resource.create_texture("/defold-pbr/irradiance_" .. name .. ".texturec", targs)
end

M.make_prefilter_texture = function(w, h, mipmaps, name)
	local targs = {
		type        = resource.TEXTURE_TYPE_CUBE_MAP,
		width       = w,
		height      = h,
		format      = resource.TEXTURE_FORMAT_RGBA16F,
		max_mipmaps = mipmaps
	}
	return resource.create_texture("/defold-pbr/prefilter_" .. name .. ".texturec", targs)
end

M.make_brdf_lut = function(brdf_buffer, w, h)
	local targs = {
		type   = resource.TEXTURE_TYPE_2D,
		width  = w,
		height = h,
		format = resource.TEXTURE_FORMAT_RGBA16F
	}
	return resource.create_texture("/pbr-brdf-lut.texturec", targs, resource.get_buffer(brdf_buffer))
end

M.load_environment = function(ctx, env_data)
	local cubemaps = { "skybox" }
	if ctx.params.use_parallax_cubemap then
		table.insert(cubemaps, "parallax")
	end

	for _, name in ipairs(cubemaps) do
		local irradiance_name = "texture_irradiance_" .. name
		local property = name .. "_irradiance"
		resource.set_texture(ctx[irradiance_name], {
			type   = resource.TEXTURE_TYPE_CUBE_MAP,
			format = resource.TEXTURE_FORMAT_RGBA16F,
			width  = env_data.irradiance_size,
			height = env_data.irradiance_size,
		}, resource.get_buffer(env_data[property]))

		ctx["handle_irradiance_" .. name] = resource.get_texture_info(ctx[irradiance_name]).handle

		local slice_width  = env_data.prefilter_size
		local slice_height = env_data.prefilter_size
		local mipmaps      = env_data.prefilter_count

		local prefilter_name = "texture_prefilter_" .. name

		for i = 0, mipmaps-1 do
			local slice_property = name .. "_prefilter" .. "_mm_" .. i
			resource.set_texture(ctx[prefilter_name], {
				type        = resource.TEXTURE_TYPE_CUBE_MAP,
				width       = slice_width,
				height      = slice_height,
				format      = resource.TEXTURE_FORMAT_RGBA16F,
				mipmap      = i,
			}, resource.get_buffer(env_data[slice_property]))
			slice_width  = slice_height / 2
			slice_height = slice_height / 2
		end
		ctx["handle_prefilter_" .. name]  = resource.get_texture_info(ctx[prefilter_name]).handle
	end
end

M.make_params = function(from_params)
	
	local p = {
		irradiance = {
			width  = 64,
			height = 64
		},
		prefilter = {
			width   = 256,
			height  = 256,
			mipmaps = 9
		},
		brdf_lut = {
			width = 512,
			height = 512
		},
		use_parallax_cubemap = false,
	}

	if from_params == nil then
		return p
	end

	p.irradiance = from_params.irradiance or p.irradiance
	p.prefilter  = from_params.prefilter or p.prefilter
	p.brdf_lut = from_params.brdf_lut or p.brdf_lut
	p.use_parallax_cubemap = from_params.use_parallax_cubemap or p.use_parallax_cubemap
	return p
end

return M