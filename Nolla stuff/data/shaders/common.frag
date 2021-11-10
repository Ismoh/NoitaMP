// generates a pixel art friendly texture coordinate ala https://csantosbh.wordpress.com/2014/01/25/manual-texture-filtering-for-pixelated-games-in-webgl/
// NOTE: texture filtering mode must be set to bilinear for this trick to work
vec2 pixel_art_filter_uv( vec2 uv, vec2 tex_size_pixels )
{
	const vec2 alpha = vec2(0.07); // 'alpha' affects the size of the smoothly filtered border between virtual (art) pixels.

	uv *= tex_size_pixels;
	{
	  	vec2 x = fract(uv);
	  	x = clamp(0.5 / alpha * x, 0.0, 0.5) + clamp(0.5 / alpha * (x - 1.0) + 0.5, 0.0, 0.5);
		uv = floor(uv) + x;
	}
	uv /= tex_size_pixels;

	return uv;
}
