#version 110
#define PIXEL_ART_FILTER

uniform sampler2D tex;
uniform vec2 tex_size;


void main()
{
	vec2 uv = gl_TexCoord[0].xy;
	vec4 color = texture2D( tex, uv ) * gl_Color;
	gl_FragColor = color;
}
