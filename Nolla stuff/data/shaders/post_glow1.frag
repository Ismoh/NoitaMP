#version 110
#define HIQ

// constants
#ifdef HIQ
	const float STEP        = 1.0;
	const float DECAY_COEFF = 1.0;
#else
	const float STEP        = 1.0;
	const float DECAY_COEFF = 1.0;
#endif

const float BLUR_RADIUS = 5.0;

// inputs
uniform sampler2D 	tex_glow_prev_frame;
uniform vec2        one_per_glow_texture_size;
uniform float		time;


void main()
{
	vec2 tex_coord_prev_frame = gl_TexCoord[0].xy;

	vec4 decayed = vec4(0.0,0.0,0.0,0.0);
	vec2 offset = one_per_glow_texture_size * 1.5;
	for(float x = -BLUR_RADIUS; x <= BLUR_RADIUS; x += STEP)
			decayed += texture2D( tex_glow_prev_frame, tex_coord_prev_frame + vec2(x, 0.0) * offset );

	decayed *= 0.1;

	gl_FragColor = decayed;
}
