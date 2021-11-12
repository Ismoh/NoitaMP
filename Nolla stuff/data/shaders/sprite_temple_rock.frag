#version 110
#define PIXEL_ART_FILTER

uniform sampler2D tex;
uniform sampler2D tex2; // perlin noise
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


void main()
{
	vec2 uv = pixel_art_filter_uv( gl_TexCoord[0].xy, tex_size );
	vec4 color = texture2D( tex, uv );
	vec4 color_perlin = texture2D( tex2, uv );

	vec4 color_desaturated = vec4( dot( vec3(0.2126,0.7152,0.0722), color.rgb ) );
	color = vec4( mix( color, color_desaturated, 0.5 ).rgb, color.a ); // desaturate a little
	color *= vec4(0.85,0.7,0.6,0.5); // tint warmer, reduce opacity

	float dissolve_alpha = step( color_perlin.r, gl_Color.a ) * gl_Color.a;
	gl_FragColor = color * vec4( gl_Color.rgb, dissolve_alpha );
}
