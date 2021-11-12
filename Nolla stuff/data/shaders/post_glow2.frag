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
const float EDGE_AFTER_IMAGE_REDUCTION_AMOUNT   = 2.0;
const float EDGE_AFTER_IMAGE_REDUCTION_SIZE     = 0.05;
const float EDGE_AFTER_IMAGE_REDUCTION_SIZE_INV = 1.0 - EDGE_AFTER_IMAGE_REDUCTION_SIZE;

// inputs
uniform sampler2D 	tex_glow_source;
uniform sampler2D 	tex_glow_source_particles;
uniform sampler2D 	tex_glow_prev_frame;
uniform vec2        one_per_glow_texture_size;
uniform float		time;


void main()
{
	// calculate tex coords
	vec2 tex_coord_source     = gl_TexCoord[0].xy;
	vec2 tex_coord_source_inv = vec2( tex_coord_source.x, 1.0 - tex_coord_source.y );
	vec2 tex_coord_prev_frame = gl_TexCoord[0].zw;

	// get a new sample
	vec4 new_tap = texture2D( tex_glow_source, tex_coord_source ) * 4.0; // colors are remapped to "HDR" range in cell blitting. gfx_glow in CellData can go up to 1000, 255 represents old default brightness
	new_tap += texture2D( tex_glow_source_particles, tex_coord_source_inv ) * 2.5;

	// slightly darken accumulated samples near the edge to reduce after image
	// when the camera is moving and a glowy area previously overlapping with the edge stop overlapping
	float weight = 1.0;
	if (tex_coord_prev_frame.x > EDGE_AFTER_IMAGE_REDUCTION_SIZE_INV)
		weight = 1.0 - (tex_coord_prev_frame.x - EDGE_AFTER_IMAGE_REDUCTION_SIZE_INV) * EDGE_AFTER_IMAGE_REDUCTION_AMOUNT;
	else if (tex_coord_prev_frame.x < EDGE_AFTER_IMAGE_REDUCTION_SIZE)
		weight = 1.0 - (EDGE_AFTER_IMAGE_REDUCTION_SIZE - tex_coord_prev_frame.x)     * EDGE_AFTER_IMAGE_REDUCTION_AMOUNT;

	if (tex_coord_prev_frame.y > EDGE_AFTER_IMAGE_REDUCTION_SIZE_INV)
		weight = 1.0 - (tex_coord_prev_frame.y - EDGE_AFTER_IMAGE_REDUCTION_SIZE_INV) * EDGE_AFTER_IMAGE_REDUCTION_AMOUNT;
	else if (tex_coord_prev_frame.y < EDGE_AFTER_IMAGE_REDUCTION_SIZE)
		weight = 1.0 - (EDGE_AFTER_IMAGE_REDUCTION_SIZE - tex_coord_prev_frame.y)     * EDGE_AFTER_IMAGE_REDUCTION_AMOUNT;

	// accumulate glow by merging the results of previous frame to the new sample
	vec4 decayed = vec4(0.0,0.0,0.0,0.0);
	vec2 offset = one_per_glow_texture_size * 1.5;
	for(float y = -BLUR_RADIUS; y <= BLUR_RADIUS; y += STEP)
		decayed += texture2D( tex_glow_prev_frame, tex_coord_source + vec2(0.0, y) * offset ) * weight;

	decayed *= 1.0 / 12.2;

	gl_FragColor = new_tap * 0.125 + vec4( mix(decayed, new_tap, 0.05).rgb, 1.0 );

	// DEBUG:
	//tex_coord_prev_frame -= fract( camera_pos ) * one_per_glow_texture_size;
	//gl_FragColor = vec4( new_tap.rgb, 1.0 );
	//gl_FragColor = texture2D( tex_glow_prev_frame, tex_coord_prev_frame );
}
