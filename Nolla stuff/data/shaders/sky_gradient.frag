#version 110
#define HIQ


void main()
{
	vec2 tex_coord = gl_TexCoord[0].xy;
	vec4 in_color = gl_Color;
	vec4 in_color_dark = in_color * vec4(0.5, 0.55, 0.7, 1.0);
	float lerp =  clamp(tex_coord.y * 0.15, 0.0, 1.4) - 0.05;

	vec4 color = mix( in_color_dark, in_color, lerp );
	//color = in_color;
	gl_FragColor = color;
}
