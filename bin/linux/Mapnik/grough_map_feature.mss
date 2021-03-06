@feature_wall_thickness:			3.0;
@feature_wall_colour:				#A0A0A0;
@feature_wall_blend:				src-over;
@feature_wall_opacity:				1.0;
@feature_wall_dash_line:			6;
@feature_wall_dash_space:			4;

@feature_hedge_thickness:			@feature_wall_thickness;
@feature_hedge_colour:				@feature_wall_colour;
@feature_hedge_blend:				@feature_wall_blend;
@feature_hedge_opacity:				@feature_wall_opacity;
@feature_hedge_dash_line:			@feature_wall_dash_line;
@feature_hedge_dash_space:			@feature_wall_dash_space;

@feature_fence_thickness:			@feature_wall_thickness;
@feature_fence_colour:				@feature_wall_colour;
@feature_fence_blend:				@feature_wall_blend;
@feature_fence_opacity:				@feature_wall_opacity;
@feature_fence_dash_line:			@feature_wall_dash_line;
@feature_fence_dash_space:			@feature_wall_dash_space;

@feature_cable_thickness:			2.0;
@feature_cable_colour:				red;
@feature_cable_blend:				multiply;
@feature_cable_opacity:				0.5;
@feature_cable_dash_line:			10;
@feature_cable_dash_space:			20;

@feature_watermark_thickness:		5.0;
@feature_watermark_colour:			@contour_label_default_colour;
@feature_watermark_blend:			multiply;
@feature_watermark_opacity:			1.0;
@feature_watermark_dash_line:		50;
@feature_watermark_dash_space:		75;

@feature_pylon_shape:				ellipse;
@feature_pylon_size:				6.0;
@feature_pylon_colour:				@feature_cable_colour;
@feature_pylon_blend:				src-over;
@feature_pylon_opacity:				1.0;

@feature_label_default_size:		30;
@feature_label_default_margin:		30;
@feature_label_default_wrap_width:	1;
@feature_label_source:				[feature_name];
@feature_label_colour:				black;
@feature_label_opacity:				1.0;
@feature_label_placement_type:		simple;
@feature_label_placement:			interior;
@feature_label_typeface:			'Open Sans Italic';
@feature_label_avoid_edges:			false;
@feature_label_character_spacing:	2;
@feature_label_minimum_padding:		75;
@feature_label_displacement:		50;
@feature_label_halo_radius:			5;
@feature_label_halo_colour:			rgba(255, 255, 255, 0.6);
@feature_label_alignment:			left;

@feature_label_water_size:			30;
@feature_label_water_colour:		@watercourse_label_default_colour;

.feature-label {
	text-name: @feature_label_source;
	text-min-distance: @feature_label_default_margin;
	text-face-name: @feature_label_typeface;
	text-fill: @feature_label_colour;
	text-opacity: @feature_label_opacity;
	text-size: @feature_label_default_size;
	text-placement-type: @feature_label_placement_type;
	text-placement: @feature_label_placement;
	text-wrap-width: @feature_label_default_wrap_width;
	text-avoid-edges: @feature_label_avoid_edges;
	text-character-spacing: @feature_label_character_spacing;
	text-min-padding: @feature_label_minimum_padding;
	text-label-position-tolerance: @feature_label_displacement;
	text-halo-radius: @feature_label_halo_radius;
	text-halo-fill: @feature_label_halo_colour;
	text-horizontal-alignment: @feature_label_alignment;
	
	[class_name='Spring'],
	[class_name='Pond']	{
		text-size: @feature_label_water_size;
		text-fill: @feature_label_water_colour;
	}
}

.feature-line {
	[class_name='Wall'],
	[class_name='Obstruction']	{
		line-width: @feature_wall_thickness;
		line-color: @feature_wall_colour;
		line-opacity: @feature_wall_opacity;
		line-comp-op: @feature_wall_blend;
		line-dasharray: @feature_wall_dash_line, @feature_wall_dash_space;
	}
	
	[class_name='Hedge'] {
		line-width: @feature_hedge_thickness;
		line-color: @feature_hedge_colour;
		line-opacity: @feature_hedge_opacity;
		line-comp-op: @feature_hedge_blend;
		line-dasharray: @feature_hedge_dash_line, @feature_hedge_dash_space;
	}
	
	[class_name='Fence'] {
		line-width: @feature_fence_thickness;
		line-color: @feature_fence_colour;
		line-opacity: @feature_fence_opacity;
		line-comp-op: @feature_fence_blend;
		line-dasharray: @feature_fence_dash_line, @feature_fence_dash_space;
	}
	
	[class_name='Overhead cables'] {
		line-width: @feature_cable_thickness;
		line-color: @feature_cable_colour;
		line-opacity: @feature_cable_opacity;
		line-comp-op: @feature_cable_blend;
		line-dasharray: @feature_cable_dash_line, @feature_cable_dash_space;
	}
	
	[class_name='Mean High Water'],
	[class_name='Mean Low Water']	{
		line-width: @feature_watermark_thickness;
		line-color: @feature_watermark_colour;
		line-opacity: @feature_watermark_opacity;
		line-comp-op: @feature_watermark_blend;
		line-dasharray: @feature_watermark_dash_line, @feature_watermark_dash_space;
	}
}

.feature-point {
	[class_name='Pylon'] {
		marker-type: @feature_pylon_shape;
		marker-width: @feature_pylon_size;
		marker-fill: @feature_pylon_colour;
		marker-opacity: @feature_pylon_opacity;
		marker-comp-op: @feature_pylon_blend;
	}
}