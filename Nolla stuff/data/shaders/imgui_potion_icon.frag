#version 110
#define PIXEL_ART_FILTER

uniform sampler2D tex;
uniform vec4 data;
uniform vec2 tex_size;


#ifdef PIXEL_ART_FILTER
	// generates a pixel art friendly texture coordinate ala https://csantosbh.wordpress.com/2014/01/25/manual-texture-filtering-for-pixelated-games-in-webgl/
	// NOTE: texture filtering mode must be set to bilinear for this trick to work
	vec2 pixel_art_filter_uv( vec2 uv, vec2 tex_size_pixels )
	{
		const vec2 alpha = vec2(0.08); // 'alpha' affects the size of the smoothly filtered border between virtual (art) pixels.

		uv *= tex_size_pixels;
		{
		  	vec2 x = fract(uv);
		  	x = clamp(0.5 / alpha * x, 0.0, 0.5) + clamp(0.5 / alpha * (x - 1.0) + 0.5, 0.0, 0.5);
			uv = floor(uv) + x;
		}
		uv /= tex_size_pixels;

		return uv;
	}
#else
	vec2 pixel_art_filter_uv( vec2 uv, vec2 tex_size_pixels )
	{
		return uv;
	}
#endif


vec4 to_luminosity_based_grayscale( vec4 color)
{
	float l = 0.21 * color.r + 0.72 * color.g + 0.07 * color.b; // perception-based grayscale conversion
	return vec4( l, l, l, color.a );
}


void main()
{
	vec2 uv = pixel_art_filter_uv( gl_TexCoord[0].xy, tex_size );
	vec2 uv2 = gl_TexCoord[0].xy;
	vec4 color = texture2D( tex, uv );
	vec4 color_orig = color;
	color *= gl_Color;
	
	color.rgb = mix( color.rgb * 0.85, vec3(1.0,1.0,1.0), data.y ); // flash potion when drinking

	float status_amount = max(0.1, data.x); // [ 0.2, 0.8 ]

	float uv_min = 0.18;
	float uv_max = 0.85;
	float status_uv = (uv2.y-uv_min) / (uv_max-uv_min);
	if ( status_amount < (1.0-status_uv) )
		color.rgb = color_orig.rgb * 0.85;

	gl_FragColor = color;
}
