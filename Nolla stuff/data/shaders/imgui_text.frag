#version 110

uniform sampler2D tex;
uniform vec2 tex_size;


void main()
{
	vec2 uv = gl_TexCoord[0].xy;
	
	vec4 color = texture2D( tex, uv );
	gl_FragColor = vec4( gl_Color.r, gl_Color.g, gl_Color.b, color.r * gl_Color.a );
}
