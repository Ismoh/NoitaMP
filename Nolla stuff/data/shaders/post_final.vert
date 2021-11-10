#version 110

uniform vec2 camera_pos;
uniform vec2 camera_subpixel_offset;
uniform vec2 world_viewport_size;
uniform float camera_inv_zoom_ratio;

uniform vec2 tex_skylight_sample_delta;
uniform vec2 skylight_subpixel_offset;

uniform vec2 tex_fog_sample_delta;
uniform vec2 fog_subpixel_offset;


varying vec2 tex_coord_;
varying vec2 tex_coord_y_inverted_;
varying vec2 tex_coord_glow_;
varying vec2 world_pos;
varying vec2 tex_coord_skylight;
varying vec2 tex_coord_fogofwar;


void main()
{
    gl_Position = gl_ProjectionMatrix * gl_ModelViewMatrix * gl_Vertex;
	gl_FrontColor = gl_Color;
	gl_TexCoord[0] = gl_MultiTexCoord0;
	gl_TexCoord[1] = gl_MultiTexCoord1;

	tex_coord_ = gl_TexCoord[0].xy;
	tex_coord_y_inverted_ = gl_TexCoord[0].zw + vec2(camera_subpixel_offset.x, camera_subpixel_offset.y);
	tex_coord_glow_ = gl_TexCoord[1].xy;
    world_pos = camera_pos + tex_coord_y_inverted_ * world_viewport_size;

    vec2 sample_pos;

    // world coordinates -> skylight texture coordinates
	const float SKY_Y_OFFSET   = 55.0;
	const float SKY_PIXEL_SIZE = 64.0;
	const vec2  SKY_TEX_SIZE   = vec2( 32.0 );

	sample_pos = tex_coord_y_inverted_ * world_viewport_size;
	sample_pos.y += SKY_Y_OFFSET;
	sample_pos   += ( ( SKY_TEX_SIZE * SKY_PIXEL_SIZE ) - world_viewport_size.x ) / 2.0;
	sample_pos   += tex_skylight_sample_delta;
	sample_pos   /= SKY_PIXEL_SIZE * SKY_TEX_SIZE;
	sample_pos   += skylight_subpixel_offset;

	tex_coord_skylight = sample_pos;

	// world coordinates -> fog  texture coordinates
	const float FOG_PIXEL_SIZE = 32.0;
	float FOG_Y_OFFSET   = 90.0 * camera_inv_zoom_ratio;
	vec2  FOG_TEX_SIZE   = vec2( 64.0 ) * camera_inv_zoom_ratio;
	
	sample_pos = tex_coord_y_inverted_ * world_viewport_size;
	sample_pos.y += FOG_Y_OFFSET;
	sample_pos   += ( ( FOG_TEX_SIZE * FOG_PIXEL_SIZE ) - world_viewport_size.x ) / 2.0;
	sample_pos   += tex_fog_sample_delta;
	sample_pos   /= FOG_PIXEL_SIZE * FOG_TEX_SIZE;
	sample_pos   += fog_subpixel_offset; // subpixel correction

	tex_coord_fogofwar = sample_pos;
}