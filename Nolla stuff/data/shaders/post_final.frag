#version 110
#define DITHER
#define HIQ
//extra_define0

//uniform sampler2D tex_prev;
uniform sampler2D tex_bg;
uniform sampler2D tex_fg;
uniform sampler2D tex_lights;
uniform sampler2D tex_skylight;
uniform sampler2D tex_noise;
uniform sampler2D tex_perlin_noise;
uniform sampler2D tex_glow_unfiltered;
uniform sampler2D tex_glow;
uniform sampler2D tex_fog;

uniform float dithering_amount;

uniform vec2 window_size;
uniform vec2 world_viewport_size;
uniform vec2 camera_pos;
uniform float camera_inv_zoom_ratio;

uniform float time;
uniform float night_amount;
uniform vec4 sky_light_color;
uniform float damage_flash_interpolation;
uniform vec4  additive_overlay_color;
uniform vec4  overlay_color;
uniform vec4  overlay_color_blindness;
uniform float low_health_indicator_alpha;

uniform vec4 color_grading;
uniform vec4 brightness_contrast_gamma;

uniform float fog_amount_background;
uniform float fog_amount_foreground;

uniform float drugged_distortion_amount;
uniform float drugged_color_amount;    
uniform float drugged_fractals_amount;
uniform float drugged_fractals_size;
uniform float drugged_nightvision_amount;
uniform float drugged_doublevision_amount;

uniform sampler2D tex_debug;
uniform sampler2D tex_debug2;


varying vec2 tex_coord_;
varying vec2 tex_coord_y_inverted_;
varying vec2 tex_coord_glow_;
varying vec2 world_pos;
varying vec2 tex_coord_skylight;
varying vec2 tex_coord_fogofwar;


// -----------------------------------------------------------------------------------------------
// utilities

vec3 srgb2lin_fast(vec3 c) { return c*c; }
vec3 lin2srgb_fast(vec3 c) { return sqrt(c); }

vec4 unpack_noise( vec4 noise ) { return mix(vec4(0.5,0.5,0.5,0.5), mix(vec4(-0.5), vec4(1.5), noise), dithering_amount); } // converts [0.0,1.0] to [-0.5,1.5], which is ideal for dithering

#ifdef DITHER
	vec3 dither(vec3 c, float noise, float ratio)      { return c + noise / ratio; }
	vec3 dither_srgb(vec3 c, float noise, float ratio) { return srgb2lin_fast(dither(lin2srgb_fast(c), noise, ratio )); }
#else
	vec3 dither(vec3 c, float noise, float ratio)      { return c; }
	vec3 dither_srgb(vec3 c, float noise, float ratio) { return c; }
#endif

#define T time


// trip "fractals" effect. this is based on some code from ShaderToy, which I can't find anymore.

#ifdef TRIPPY
float mlength(vec2 uv) {
	uv = abs(uv);
    return uv.x + uv.y;
}

mat2 rotate(float a) {
	float c = cos(a), 
        s = sin(a);
    return mat2(c, -s, s, c);
}

float sinp(float v) {
	return .5 + .5 * sin(v);
}

float sinr(float v, float a, float b) {
	return mix(a, b, sinp(v));
}

float shape(vec2 uv) {

    vec2 f = fract(uv) - .5;
	
    // trying manhattan dist
    vec2 st = vec2(atan(f.x, f.y), mlength(f));

	float k = sinr(T * .05, 2., 12.);
    float a = 4.;
    
    return cos(st.y * k + st.x * a + T) * 
        	cos(st.y * k - st.x * a + T) * 
        	smoothstep(.2, .8, st.y);
}

vec3 render(vec2 uv) {

    uv = abs(uv) - sinr(T * .5, .25, .5);

    float t = shape(uv) + 
        clamp(abs(.2 / shape(uv)) * .25, .0, 2.); // glow
   
    // rotate, scale and layer
    uv *= rotate(.785);
    t *= shape(uv) + 
        clamp(abs(.03 / shape(uv)) * .25, .0, .9);
    //t *= length(uv);
   
    return mix(vec3(t, .4, sinr(T, .3, .8)),
               vec3(.1, .0, .3), t);
}
#endif

// -----------------------------------------------------------------------------------------------

void main()
{
	// constants
	const bool ENABLE_REFRACTION 			= 1>0;
	const bool ENABLE_LIGHTING	    		= 1>0;
	const bool ENABLE_FOG_OF_WAR 			= 1>0;
	const bool ENABLE_GLOW 					= 1>0;
	const bool ENABLE_GAMMA_CORRECTION		= 1>0;
	const bool ENABLE_PATH_DEBUG			= 1>0;
	
	const float DISTORTION_TIME_SPD 		= 10.0;
	const float DISTORTION_SCALE_MULT 		= 50.0;
	const float DISTORTION_SCALE_MULT2 		= 0.002;
	
	const float REFLECTION_SAMPLES 			= 50.0;
	const float REFLECTION_SAMPLE_DISTANCE 	= 0.0045;
	const float REFLECTION_INTENSITY 		= 0.65;
	const float REFLECTION_MAX_DISTANCE 	= REFLECTION_SAMPLES * REFLECTION_SAMPLE_DISTANCE;

	const vec4  FOG_FOREGROUND 				= vec4(0.6,0.6,0.6,1.0);
	const vec3  FOG_BACKGROUND 				= vec3(0.7,0.7,0.7);

	const vec4  FOG_FOREGROUND_NIGHT 		= vec4(0.2,0.2,0.2,1.0);
	const vec3  FOG_BACKGROUND_NIGHT 		= vec3(0.2,0.2,0.2);

	const vec2  NOISE_TEX_SIZE				= vec2( 1024.0, 1024.0 );

	const float EXTRA_BRIGHT_INTENSITY = 0.25;
	
	const vec3 LOW_HEALTH_INDICATOR_COLOR = vec3( 0.7, 0.1, 0.0 );

	const float SCREEN_W = 427.0;
	const float SCREEN_H = 242.0;

// ==========================================================================================================
// fetch texture coords etc =============================================================================

	vec2 tex_coord = tex_coord_;
	vec2 tex_coord_y_inverted = tex_coord_y_inverted_;
	vec2 tex_coord_glow = tex_coord_glow_;

// ===========================================================================================================
// get noise. R G B and A channels each contain unique noise from the same source ============================

    float noise_time = mod(time, 1000.0);
    vec2 noise_scale = vec2(1.0,1.0) / ( NOISE_TEX_SIZE / window_size ); // scale the noise so that 1 pixel on source maps to 1 pixel on screen. TODO: move this math to CPU

    vec4 noise = unpack_noise( texture2D( tex_noise, tex_coord * noise_scale + noise_time * 10.0 ) );
    vec4 noise_perlin2 = texture2D( tex_perlin_noise, world_pos * 0.0004 + vec2(0.0,noise_time * 0.005) );

// ===========================================================================================================
// liquid distortion/refraction effect (calculate distorted texture coordinates for later use) ===============
  
  	const float SHADING_BRIGHT_BITS_ALPHA = 0.25;
    const float SHADING_LIQUID_BITS_ALPHA = 0.99;

	vec4 extra_data = texture2D( tex_glow_unfiltered, tex_coord_glow );

	float liquid_mask      = step( SHADING_LIQUID_BITS_ALPHA, extra_data.a );
	float very_bright_mask = step( SHADING_BRIGHT_BITS_ALPHA, extra_data.a ) - liquid_mask;

	if (ENABLE_REFRACTION)
	{
		float distortion_mult  = time * DISTORTION_TIME_SPD; // time * (DISTORTION_TIME_SPD - 5.0 *drugged_distortion_amount);

		vec2 liquid_distortion_offset = vec2(
			liquid_mask * sin( distortion_mult + (tex_coord.x + camera_pos.x / world_viewport_size.x ) * DISTORTION_SCALE_MULT) * DISTORTION_SCALE_MULT2, 
			liquid_mask * cos( distortion_mult + (tex_coord.y - camera_pos.y / world_viewport_size.y ) * DISTORTION_SCALE_MULT) * DISTORTION_SCALE_MULT2 
			) / camera_inv_zoom_ratio;
			
		// distort the texture coordinate if the pixel we would sample is liquid
		vec4 extra_data_at_liquid_offset = texture2D( tex_glow_unfiltered, tex_coord_glow + vec2( liquid_distortion_offset.x, -liquid_distortion_offset.y ) );
		liquid_distortion_offset *= step( SHADING_LIQUID_BITS_ALPHA, extra_data_at_liquid_offset.a );

		tex_coord = tex_coord + liquid_distortion_offset;
		tex_coord_y_inverted += vec2( liquid_distortion_offset.x, -liquid_distortion_offset.y );
		tex_coord_glow += vec2( liquid_distortion_offset.x, -liquid_distortion_offset.y );
	}

   	vec2 pos_seed = vec2(camera_pos.x / SCREEN_W, camera_pos.y / SCREEN_H) + vec2( gl_TexCoord[0].x, - gl_TexCoord[0].y );

#ifdef TRIPPY
   	// trip distortion
	pos_seed = floor(pos_seed * SCREEN_W) / SCREEN_W; // pixelate
	vec2 perlin_noise = texture2D(tex_perlin_noise, pos_seed*0.1 + vec2(time,time)*0.01).xy - vec2(0.5,0.5);
	perlin_noise += texture2D(tex_perlin_noise, pos_seed*0.3 + vec2(time,time)*0.005).xy - vec2(0.5,0.5);
	float tex_coord_warped_zoom = min( 1.0, drugged_distortion_amount * 1.5 ); // zoom in a little to avoid sampling past texture edges
	vec2 tex_coord_warped = (tex_coord - vec2(0.5,0.5)) * mix(1.0, 0.9, tex_coord_warped_zoom ) + vec2(0.5,0.5);
	tex_coord = tex_coord_warped;
	tex_coord_warped += perlin_noise.xy * 0.2;
	float tex_coord_warped_lerp = length(tex_coord - vec2(0.5,0.5)) * drugged_distortion_amount;
	tex_coord = mix( tex_coord, tex_coord_warped, tex_coord_warped_lerp );

   	pos_seed = vec2(camera_pos.x / SCREEN_W, camera_pos.y / SCREEN_H) + vec2( tex_coord.x, - tex_coord.y );
#endif

// ===========================================================================================================
// sample the original color =================================================================================

	vec3 color    = texture2D(tex_bg, tex_coord).rgb;
	vec4 color_fg = texture2D(tex_fg, tex_coord);
	
#ifdef TRIPPY
	// drunk doublevision
	vec2 doublevision_offset = vec2(0.005 * cos(time*0.5)  * drugged_doublevision_amount,0.005 * sin(time*0.5) * drugged_doublevision_amount );
	color_fg = mix( color_fg, texture2D(tex_fg, tex_coord + doublevision_offset  ), 0.5 );
	color = mix( color, texture2D(tex_bg, tex_coord + doublevision_offset  ).rgb, 0.5 );
#endif

	vec3 color_orig    = color;
	vec4 color_fg_orig = color_fg;

// ============================================================================================================
// sample glow texture ========================================================================================

	vec3 glow = vec3(0.0,0.0,0.0);
	if (ENABLE_GLOW)
	{
		// fetch the glow without doing any filtering
		glow = texture2D(tex_glow, tex_coord_glow).rgb;

		#ifdef HIQ
			// fetch a blurred (less banded) version of the glow. the banding mostly occurs against dark backgrounds so we use the non-smooth glow where the sky is visible
			const float GLOW_BLUR_OFFSET  = 0.0025 * 0.5;
			const float GLOW_BLUR_OFFSET2 = 0.004  * 0.5;

			vec3 glow_smooth = glow;
			glow_smooth += texture2D(tex_glow, tex_coord_glow + vec2( 0, GLOW_BLUR_OFFSET )).rgb;
			glow_smooth += texture2D(tex_glow, tex_coord_glow + vec2( 0, -GLOW_BLUR_OFFSET)).rgb;
			glow_smooth += texture2D(tex_glow, tex_coord_glow + vec2(-GLOW_BLUR_OFFSET2,  0)).rgb;
			glow_smooth += texture2D(tex_glow, tex_coord_glow + vec2( GLOW_BLUR_OFFSET2,  0)).rgb;
			glow_smooth += texture2D(tex_glow, tex_coord_glow + vec2( 0, GLOW_BLUR_OFFSET2 )).rgb;
			glow_smooth += texture2D(tex_glow, tex_coord_glow + vec2( 0, -GLOW_BLUR_OFFSET2)).rgb;
			glow_smooth += texture2D(tex_glow, tex_coord_glow + vec2(-GLOW_BLUR_OFFSET2,  0)).rgb;
			glow_smooth += texture2D(tex_glow, tex_coord_glow + vec2( GLOW_BLUR_OFFSET2,  0)).rgb;
			glow_smooth *= 0.11111;

			// use smoothed glow when the glow doesn't overlap with sky to get rid of banding
			float smoothing_amount = (1.0 - (glow_smooth.r + glow_smooth.g + glow_smooth.b) * 0.3333) * color_fg.a;
			glow = mix(glow, glow_smooth, smoothing_amount );
			glow = dither_srgb(glow, noise.r, 128.0 );
			//glow = max( vec3(0.0), glow - vec3(1.0/128.0) );
		#endif

		glow = max( vec3(0.0), glow - 0.008 );

	#ifdef TRIPPY
		// trip "fractals"
		vec2 perlin_noise_static = texture2D(tex_perlin_noise, pos_seed*0.1+ vec2(time,time)*0.0001 ).xy - vec2(0.5,0.5);

		float fractals_alpha = sqrt( (color_fg.r + color_fg.g + color_fg.b) * 0.333 ) * 2.0;
		pos_seed = floor(pos_seed * SCREEN_W) / SCREEN_W; // pixelate
		pos_seed += perlin_noise * 0.01; // moving wave distortion
		pos_seed += perlin_noise_static * 0.15; // static wave distortion

		vec3 fractals0 = render( pos_seed * ( mix( 20.0, 20.0 - (perlin_noise_static.x+perlin_noise_static.y) * 15.0, drugged_fractals_size  ) ) ) * 0.2;
		fractals0 = max(fractals0,vec3(0.0));
		glow.rgb += fractals0.rgb * fractals_alpha * 2.5 * drugged_fractals_amount;
	#endif
	}

// ============================================================================================================
// sample light texture =======================================================================================

	vec4 light_tex_sample = texture2D(tex_lights, tex_coord);
	vec3 lights = light_tex_sample.rgb * 0.8;

// ============================================================================================================
// fetch skylight contribution from a texture =================================================================

	float sky_ambient_amount;
	float fog_amount;
	if (ENABLE_LIGHTING)
	{
		const float SKY_Y_OFFSET   = 90.0;
		const float SKY_PIXEL_SIZE = 64.0;
		const vec2  SKY_TEX_SIZE   = vec2( 32.0 );

		// world coordinates -> skylight texture coordinates // TODO: move math to CPU
		vec4 sky_value = texture2D(tex_skylight, tex_coord_skylight );

		#ifdef HIQ
			sky_value = sky_value + (
	                           + texture2D(tex_skylight, tex_coord_skylight - vec2(1.0,0.0) / SKY_TEX_SIZE.x )
	                           + texture2D(tex_skylight, tex_coord_skylight + vec2(1.0,0.0) / SKY_TEX_SIZE.y )
	                           + texture2D(tex_skylight, tex_coord_skylight - vec2(0.0,1.0) / SKY_TEX_SIZE.x )
	                           + texture2D(tex_skylight, tex_coord_skylight + vec2(0.0,1.0) / SKY_TEX_SIZE.y ) )*0.25;
		    sky_value *= 0.5;
		#endif

		sky_ambient_amount = sky_value.r;
		fog_amount = texture2D(tex_skylight, tex_coord_skylight + (noise_perlin2.xy-0.5)*0.05 ).r;
	}
	else
	{
		sky_ambient_amount = 0.0;
	}

	sky_ambient_amount *= sky_ambient_amount;

// ============================================================================================================
// calculate fog of war =======================================================================================

	// fetch fog of war and dust contribution from a texture
	float fog_of_war_amount = 1.0;
	float dust_amount = 0.0;
	if (ENABLE_FOG_OF_WAR)
	{
		vec2 FOG_TEX_SIZE = vec2( 64.0 ) * camera_inv_zoom_ratio;

		vec4 fog_value = texture2D( tex_fog, tex_coord_fogofwar );

		#ifdef HIQ
			const float s  = 0.25;
			const float s2 = 0.75;
			fog_value = fog_value + (
	                           + texture2D(tex_fog, tex_coord_fogofwar - vec2(-1.0,1.0) / FOG_TEX_SIZE.x * s )
	                           + texture2D(tex_fog, tex_coord_fogofwar - vec2(1.0,1.0) /  FOG_TEX_SIZE.y * s )
	                           + texture2D(tex_fog, tex_coord_fogofwar + vec2(-1.0,1.0) / FOG_TEX_SIZE.x * s )
	                           + texture2D(tex_fog, tex_coord_fogofwar + vec2(1.0,1.0) /  FOG_TEX_SIZE.y * s )

	                           + texture2D(tex_fog, tex_coord_fogofwar - vec2(1.0,0.0) /  FOG_TEX_SIZE.x * s2 )
	                           + texture2D(tex_fog, tex_coord_fogofwar + vec2(1.0,0.0) /  FOG_TEX_SIZE.y * s2 )
	                           + texture2D(tex_fog, tex_coord_fogofwar - vec2(0.0,1.0) /  FOG_TEX_SIZE.x * s2 )
	                           + texture2D(tex_fog, tex_coord_fogofwar + vec2(0.0,1.0) /  FOG_TEX_SIZE.y * s2 ) );
		    fog_value *= 0.1111111;
		#else
			const float s = 0.5;
			fog_value = fog_value + (
	                           + texture2D(tex_fog, tex_coord_fogofwar - vec2(-1.0,1.0) / FOG_TEX_SIZE.x * s )
	                           + texture2D(tex_fog, tex_coord_fogofwar - vec2(1.0,1.0) /  FOG_TEX_SIZE.y * s )
	                           + texture2D(tex_fog, tex_coord_fogofwar + vec2(-1.0,1.0) / FOG_TEX_SIZE.x * s )
	                           + texture2D(tex_fog, tex_coord_fogofwar + vec2(1.0,1.0) /  FOG_TEX_SIZE.y * s ) );
		    fog_value *= 0.2;
		#endif

		fog_of_war_amount = fog_value.r * (1.0-light_tex_sample.a); // light_tex_sample.a contains "fog of war holes" (for example temporary holes caused by explosions)
		dust_amount = fog_value.g;
	}

// ============================================================================================================
// get sky light color ========================================================================================
	
	lights = pow( lights, vec3( 1.5 ) );

	// apply light from the glow buffer ---
	lights += glow; 

	vec3 sky_light = sky_light_color.rgb * sky_ambient_amount;

	// apply light from the sky ---
	//sky_ambient_amount = max(0.0,sky_ambient_amount);
	lights -= sky_light;
	lights = max(lights,vec3(0.0));
	lights += sky_light;
	lights = min( lights, vec3(1.0) );

	// correct the gamma
	if (ENABLE_GAMMA_CORRECTION)
		lights = pow(lights, vec3(1.0 / 2.2));

	lights = dither_srgb(lights, noise.g, 128.0);
	
// ==========================================================================================================
// fog of war ================================================================================================

	float fog_of_war_sky_ambient_amount = sky_ambient_amount;
	float fade = clamp( (world_pos.y - 250.0) / 100.0, 0.0, 1.0 );
	fog_of_war_sky_ambient_amount *= 1.0-fade;
	float sky_ambient2 = sqrt( fog_of_war_sky_ambient_amount );
	vec3 fog_of_war = 1.4 * vec3(0.6,0.5,0.45) * vec3( max( 0.0, 1.0 - fog_of_war_amount - sky_ambient2 ) );
	// fog_of_war = min( vec3(1.0), max( dither_srgb( 1.1 * fog_of_war, noise.b, 32.0 ), fog_of_war_sky_ambient_amount ) );
	// fog_of_war = pow( fog_of_war, vec3( 0.6 ) );
	fog_of_war = min( vec3(1.0), max( dither_srgb( 2.0 * fog_of_war, noise.b, 32.0 ), fog_of_war_sky_ambient_amount ) );

	lights *= fog_of_war;
	lights += max(0.35 - fog_of_war_sky_ambient_amount, 0.0) * dither_srgb( fog_of_war, noise.b, 128.0 );

// ==========================================================================================================
// apply fog ================================================================================================

	float luminousity = sqrt(min(1.0,dot(lights, vec3(0.299, 0.587, 0.114)*1.0)));

	float fog_amount_underground = dust_amount;
	float fog_amount_fg = mix( fog_amount_underground, fog_amount_foreground, sky_ambient_amount );
	fog_amount = max(fog_amount,fog_amount_underground);
	float fog_amount_multiplier_final = max(sky_ambient_amount, fog_amount_underground * luminousity * min(1.0,noise_perlin2.x*noise_perlin2.x*2.0) );

	vec4 fog_color_fg = mix( FOG_FOREGROUND, FOG_FOREGROUND_NIGHT, max(night_amount,1.0-sky_ambient_amount) );
	vec3 fog_color_bg = mix( FOG_BACKGROUND, FOG_BACKGROUND_NIGHT, night_amount );

	fog_amount = dither_srgb(vec3(fog_amount), noise.b, 64.0).r;
	fog_amount = fog_amount_fg * fog_amount;
	
	// apply fog to bg
	color = mix(color, fog_color_bg, fog_amount_background);
	color = mix(color , dither_srgb(color, noise.a, 64.0 ), fog_amount );

// ==========================================================================================================
// nightvision ==============================================================================================

	float edge_dist = length(tex_coord - vec2(0.5)) * 2.0;
	float edge_dist_inv = 1.0 - edge_dist;
	lights += vec3(edge_dist_inv * drugged_nightvision_amount);
	edge_dist = clamp( edge_dist, 0.0, 1.0 );

// ==========================================================================================================
// blend foreground and background ==========================================================================

	// reverse the blending effects applied when composing foreground layers
	color_fg.a   = pow(color_fg.a, 0.5);
	color_fg.rgb = color_fg.rgb * ( 1.0 / color_fg.a );
	color_fg.rgb = clamp(color_fg.rgb, vec3(0.0,0.0,0.0), vec3(1.0,1.0,1.0));

	// apply the lighting to the foreground
	if (ENABLE_LIGHTING)
		color_fg.rgb *= lights;

	// fog
	color_fg.rgb = mix( color_fg.rgb, fog_color_fg.rgb, fog_amount_fg * fog_amount_multiplier_final );

	// combine foreground and background
	color = color_fg.rgb * color_fg.a + color * (1.0-color_fg.a);

// ============================================================================================================
// color correction effect ====================================================================================

	color = mix(color, vec3((color.r + color.g + color.b) * 0.3333), color_grading.a);
	color = color * color_grading.rgb;
	vec3 color2 = color;
	//color = mix(color2, color, clamp( color_grading.a - glow * 3.0, 0.0, 1.0 ) ); // min(sqrt(sky_ambient_amount) * 5.0, 1.0) - glow * 3.0);

// ============================================================================================================
// apply glow effect using a variation of screen blending. the glow is reduced on areas with bright sky light =

	if (ENABLE_GLOW)
	{
		vec3 sky_light_modulation = max( vec3(1.0 - sky_ambient_amount), sky_light_color.rgb );
		glow *= fog_of_war;
		color = max ( color + glow * 0.6 - 0.6 * lights, clamp((color + glow) - ( color * sky_light_modulation * glow), 0.0, 1.0));
	}

// ==========================================================================================================
// damage flash effect ======================================================================================

	color = mix( color, vec3(1.0,0.0,0.0), damage_flash_interpolation * edge_dist * 0.7 );

// ==========================================================================================================
// shroom color effect ======================================================================================

	float brightness_shroom = max(color.r, max(color.g, color.b) );
	color.g = mix( color.g, brightness_shroom * 2.0 * color.g * (sin( time * 1.5 ) + 1.0) * 0.5 + noise.b / 64.0, drugged_color_amount);

// ============================================================================================================
// drunken afterimage effect ==================================================================================

	//vec3 amount = drugged_afterimage_zoom_mult * mix( vec3( drugged_afterimage_amount ), min( lights + sky_ambient_amount * sky_light_color, vec3( 1.0) ) * drugged_afterimage_amount, drugged_nightvision_amount);
	//color = mix( color, color_prev, amount );

// ============================================================================================================
// additive overlay ===========================================================================================

	// color.rgb += additive_overlay_color.rgb * additive_overlay_color.a; // TODO: combine with damage flash
	color.rgb = mix( color, additive_overlay_color.rgb, additive_overlay_color.a );

// ============================================================================================================
// brightness / contrast=======================================================================================

	vec3 brightness = vec3( brightness_contrast_gamma.r, brightness_contrast_gamma.r, brightness_contrast_gamma.r );
	vec3 contrast = vec3( brightness_contrast_gamma.g );
	vec3 gamma = vec3( brightness_contrast_gamma.b, brightness_contrast_gamma.b, brightness_contrast_gamma.b );
	vec3 halfpoint = vec3( 0.5, 0.5, 0.5 );

	color += brightness;
	color = (color - halfpoint) * contrast + halfpoint;
	color = pow( color, gamma );

	color = clamp( color, 0.0, 1.0 ); // the resulting color needs to be clamped for the overlay to work correctly

// ============================================================================================================
// overlay ====================================================================================================

	color.rgb = mix( color, overlay_color.rgb, overlay_color.a );
	color.rgb = mix( color, overlay_color_blindness.rgb, overlay_color_blindness.a * 0.5 + overlay_color_blindness.a * edge_dist*edge_dist * 40.0);

// ============================================================================================================
// low health indicator =======================================================================================
{
	float a = length(tex_coord - vec2(0.5,0.5));
	a *= 1.3;
	a *= a;
	a *= a;
	color += LOW_HEALTH_INDICATOR_COLOR * a * low_health_indicator_alpha;
}

// ============================================================================================================
// various debug visualizations================================================================================

	//color.r += 1.0 - fog_of_war.r;

	//#define DEBUG_SKYLIGHT
	//#define DEBUG_NOISE
	//#define DEBUG_DEBUG
	#ifdef HIQ
		#define DEBUG_PATHFINDING
	#endif

	vec2 tex_coord_debug = gl_TexCoord[0].xy;

	#ifdef DEBUG_SKYLIGHT
		debug_tex_coord = vec2(-0.01,-0.05) + vec2(tex_coord_debug.x, 1.0 - tex_coord_debug.y) * vec2(64.0,40.0 * world_viewport_size.x / world_viewport_size.y) / 64.0 * 0.8;
		color.rgb = mix( color.rgb, texture2D(tex_skylight, debug_tex_coord * 1.3).rgb, 0.5 ); // light
		color.g += 0.5 * texture2D(tex_skylight, debug_tex_coord).g; // minimap
	#endif

	#ifdef DEBUG_NOISE
		color = vec3( noise );
	#endif

	#ifdef DEBUG_PATHFINDING
		tex_coord = vec2(tex_coord_debug.x, 1.0 - tex_coord_debug.y);
		vec3 path_data = texture2D(tex_debug, tex_coord).rgb;
		path_data.g -= path_data.b * 0.04; // highlight areas with path data access
		color += path_data * vec3(1.0, 10.0, 4.0);
	#endif

	#ifdef DEBUG_DEBUG
		debug_tex_coord = vec2(0.45,-0.1) + tex_coord * 1.5 * vec2(1.0 / 15.625 * 2.0,1.0); // vec2(-0.01,-0.05) + vec2(tex_coord_glow.x, 1.0 - tex_coord_glow.y) * vec2(64.0,40.0 * world_viewport_size.x / world_viewport_size.y) / 64.0 * 0.8;
		color.r += 0.75 * texture2D(tex_debug2, debug_tex_coord).r; // 
	#endif

// ============================================================================================================
// output =====================================================================================================

	//color.r = tex_coord_warped_lerp;
	gl_FragColor.rgb  = color;
	gl_FragColor.a = 1.0;
}