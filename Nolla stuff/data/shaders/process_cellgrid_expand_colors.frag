#version 110

uniform sampler2D tex;
uniform vec2 tex_size;


void main()
{
	vec2 uv = gl_TexCoord[0].xy;
	vec4 color = texture2D( tex, uv );

	// if the pixel has 0 alpha, set the color to the average of nearest pixels.
	// otherwise it would be black, which causes black edges to appear when pixel art anti-aliasing is done.


	if ( color.a == 0.0 )
	{
		float px = 1.0 / tex_size.x;
		vec4 color1 = texture2D( tex, uv + vec2( -px, 0.0 ) );
		vec4 color2 = texture2D( tex, uv + vec2( +px, 0.0 ) );
		vec4 color3 = texture2D( tex, uv + vec2( 0.0, -px ) );
		vec4 color4 = texture2D( tex, uv + vec2( 0.0, +px ) );

		vec4 color_near = (
			color1 * color1.a +
			color2 * color2.a +
			color3 * color3.a +
			color4 * color4.a );

		color_near /= color1.a + color2.a + color3.a + color4.a;
		color_near.a = 0.0;

		color = color_near;
		//float color_or_color_near_selector = step( 0.01, color.a );
		//color = mix( color_near, color, color_or_color_near_selector );
	}

	gl_FragColor = color;
}
