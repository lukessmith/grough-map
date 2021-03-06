@edge_default_border_thickness:						1.5;
@edge_default_width:								1.5;
@edge_default_fill_colour:							white;
@edge_default_casing_colour:						#707070;

@edge_bridge_border_thickness:						3.5;

@edge_lanes_line_width:								1.0;
@edge_lanes_line_colour:							@edge_default_casing_colour;
@edge_lanes_line_blend:								src-over;
@edge_lanes_line_dash_line:							5;
@edge_lanes_line_dash_space:						15;

@edge_railway_width_dual:							4.5;
@edge_railway_width_single:							3.5;
@edge_railway_fill_colour:							white;
@edge_railway_border_colour:						#b0b0b0;
@edge_railway_inner_line_width:						1.0;
@edge_railway_inner_line_colour:					#404040;

@edge_motorway_width_dual:							11;
@edge_motorway_width_single:						8;
@edge_motorway_fill_colour:							#2571F5;

@edge_trunk_width_dual:								10;
@edge_trunk_width_single:							7;
@edge_trunk_fill_colour:							#62CC53;

@edge_a_road_width_dual:							10;
@edge_a_road_width_single:							7;
@edge_a_road_fill_colour:							#E35D5D;

@edge_b_road_width_dual:							9;
@edge_b_road_width_single:							6;
@edge_b_road_fill_colour:							#FAD234;

@edge_local_street_width:							8;
@edge_local_street_fill_colour:						#EDEA1A;

@edge_minor_road_width:								6;
@edge_minor_road_fill_colour:						#e0e0e0;

@edge_service_road_width:							5;
@edge_service_road_fill_colour:						@edge_default_fill_colour;

@edge_parking_width:								3;
@edge_parking_fill_colour:							@edge_default_fill_colour;
@edge_parking_border_colour:						#a0a0a0;
@edge_parking_dash_line:							10;
@edge_parking_dash_space:							10;

@edge_track_width:									4;
@edge_track_fill_colour:							@edge_default_fill_colour;
@edge_track_border_colour:							#a0a0a0;
@edge_track_dash_line:								10;
@edge_track_dash_space:								10;

@edge_path_width:									2.0;
@edge_path_fill_colour:								@edge_default_fill_colour;
@edge_path_border_colour:							red;
@edge_path_dash_line:								5;
@edge_path_dash_space:								5;

@edge_access_decorator_construction_colour:			white;
@edge_access_decorator_construction_dash_line:		10;
@edge_access_decorator_construction_dash_space:		10;

@edge_access_decorator_minor_width:					3.25;
@edge_access_decorator_major_width:					4.75;

@edge_access_decorator_path_colour:					#808080;
@edge_access_decorator_path_dash_line:				14;
@edge_access_decorator_path_dash_space:				10;

@edge_access_decorator_legalpath_colour:			#70a050;
@edge_access_decorator_legalpath_dash_line:			18;
@edge_access_decorator_legalpath_dash_space:		13;

@edge_access_decorator_pedestrianised_width:		@edge_service_road_width;
@edge_access_decorator_pedestrianised_colour:		@edge_access_decorator_legalpath_colour;
@edge_access_decorator_pedestrianised_dash_line:	5;
@edge_access_decorator_pedestrianised_dash_space:	5;

@edge_access_decorator_bridleway_colour:			@edge_access_decorator_legalpath_colour;
@edge_access_decorator_bridleway_dash_line:			@edge_access_decorator_legalpath_dash_line * 2;
@edge_access_decorator_bridleway_dash_space:		@edge_access_decorator_legalpath_dash_space;

@edge_access_decorator_permpath_colour:				orange;
@edge_access_decorator_permpath_dash_line:			@edge_access_decorator_legalpath_dash_line;
@edge_access_decorator_permpath_dash_space: 		@edge_access_decorator_legalpath_dash_space;

@edge_tunnel_border_lighten:				 		30%;
@edge_tunnel_border_dash_line:						10;
@edge_tunnel_border_dash_space: 					10;
@edge_tunnel_fill_lighten:				 			30%;
@edge_tunnel_fill_dash_line:						0;
@edge_tunnel_fill_dash_space: 						0;

@edge_ferry_width:									2;
@edge_ferry_colour:									@river_default_casing_colour;
@edge_ferry_dash_line:								10;
@edge_ferry_dash_space:								50;

.edge-outer[class_name!='Ferry'] {
	::outline {
		line-width: (@edge_default_width + 2 * @edge_default_border_thickness);
		line-color: @edge_default_casing_colour;
		line-join: round;
		line-cap: butt;
		[edge_tunnel=1] {
			line-color: lighten(@edge_default_casing_colour, @edge_tunnel_border_lighten); 
			line-dasharray: @edge_tunnel_border_dash_line, @edge_tunnel_border_dash_space;
		}
	}
	[edge_bridge=1] {
		::outline {
			line-width: (@edge_default_width + 2 * @edge_bridge_border_thickness);
			line-cap: butt;
		}
	}
}

.edge-inner[class_name!='Ferry'] {
	::inline {
		line-width: @edge_default_width;
		line-color: @edge_default_fill_colour;
		line-join: round;
		line-cap: square;
	}
}

.edge-inner[class_name='Motorway'],
.edge-inner[class_name='A road'],
.edge-inner[class_name='B road'],
.edge-inner[class_name='Trunk road'] {
	[edge_roundabout=0][edge_slip=0] {
		::lane-divide-left {
			line-comp-op: @edge_lanes_line_blend;
			line-color: @edge_lanes_line_colour;
			line-dasharray: @edge_lanes_line_dash_line, @edge_lanes_line_dash_space;
			line-width: @edge_lanes_line_width;
		}
		::lane-divide-right {
			line-comp-op: @edge_lanes_line_blend;
			line-color: @edge_lanes_line_colour;
			line-dasharray: @edge_lanes_line_dash_line, @edge_lanes_line_dash_space;
			line-width: @edge_lanes_line_width;
			line-dash-offset: @edge_lanes_line_dash_line;
		}
	}
	[edge_roundabout=1],
	[edge_slip=1],
	[edge_oneway=0],
	[edge_bridge=1][class_name='Railway'],
	[edge_bridge=1][class_name='Other railway'] {
		::lane-divide-left { line-opacity: 0; }
		::lane-divide-right { line-opacity: 0; }
	}
}

.edge-outer[edge_tunnel=0],
.edge-inner[edge_tunnel=0] {
	.edge-outer[class_name="Railway"],
	.edge-outer[class_name="Other railway"] {
		::outline {
			line-color: @edge_railway_border_colour;
		}
		[edge_oneway=1] { 
			[edge_bridge=1] {
				::outline { 
					line-color: @edge_default_casing_colour;
					line-width: @edge_railway_width_single + 2 * @edge_bridge_border_thickness; 
				}
			}
			[edge_bridge=0] {
				::outline { line-width: @edge_railway_width_single + 2 * @edge_default_border_thickness; }
			}
		}
		[edge_oneway=0] {
			[edge_bridge=1] {
				::outline { 
					line-color: @edge_default_casing_colour;
					line-width: @edge_railway_width_dual + 2 * @edge_bridge_border_thickness; 
				}
			}
			[edge_bridge=0] {
				::outline { line-width: @edge_railway_width_dual + 2 * @edge_default_border_thickness; }
			}
		}
	}

	.edge-inner[class_name="Railway"],
	.edge-inner[class_name="Other railway"] {
		::inline { 
			line-color: @edge_railway_fill_colour; 
			line-cap: butt;
		}
		[edge_oneway=1] { 
			::inline { line-width: @edge_railway_width_single; }
		}
		[edge_oneway=0] {
			::inline { line-width: @edge_railway_width_dual; }
		}
		decoration/line-width: @edge_railway_inner_line_width;
		decoration/line-color: @edge_railway_inner_line_colour;
		decoration/line-cap: square;
	}
}

.edge-outer[class_name="Motorway"] {
	[edge_oneway=1] { 
		[edge_bridge=1] {
			::outline { line-width: @edge_motorway_width_single + 2 * @edge_bridge_border_thickness; }
		}
		[edge_bridge=0] {
			::outline { line-width: @edge_motorway_width_single + 2 * @edge_default_border_thickness; }
		}
	}
	[edge_oneway=0] {
		[edge_bridge=1] {
			::outline { line-width: @edge_motorway_width_dual + 2 * @edge_bridge_border_thickness; }
		}
		[edge_bridge=0] {
			::outline { line-width: @edge_motorway_width_dual + 2 * @edge_default_border_thickness; }
		}
	}
}

.edge-inner[class_name="Motorway"] {
	::inline { 
		line-color: @edge_motorway_fill_colour; 
		[edge_tunnel=1] {
			line-color: lighten(@edge_motorway_fill_colour, @edge_tunnel_fill_lighten); 
			line-dasharray: @edge_tunnel_fill_dash_line, @edge_tunnel_fill_dash_space;
		}
	}
	[edge_oneway=1] { 
		::inline { line-width: @edge_motorway_width_single; }
		::lane-divide-left { line-offset: @edge_motorway_width_single / 2 + @edge_default_border_thickness / 2; }
		::lane-divide-right { line-offset: @edge_motorway_width_single / -2 + @edge_default_border_thickness / -2; }
		[access_name='Under construction'] {
			decoration/line-width: @edge_motorway_width_single;
			decoration/line-dasharray: @edge_access_decorator_construction_dash_line, @edge_access_decorator_construction_dash_space;
			decoration/line-color: @edge_access_decorator_construction_colour;
			decoration/line-cap: butt;		
		}
	}
	[edge_oneway=0] {
		::inline { line-width: @edge_motorway_width_dual; }
		::lane-divide-left { line-offset: @edge_motorway_width_dual / 2 + @edge_default_border_thickness / 2; }
		::lane-divide-right { line-offset: @edge_motorway_width_dual / -2 + @edge_default_border_thickness / -2; }
		[access_name='Under construction'] {
			decoration/line-width: @edge_motorway_width_dual;
			decoration/line-dasharray: @edge_access_decorator_construction_dash_line, @edge_access_decorator_construction_dash_space;
			decoration/line-color: @edge_access_decorator_construction_colour;
			decoration/line-cap: butt;		
		}
	}
}

.edge-outer[class_name="Trunk road"] {
	[edge_oneway=1] { 
		[edge_bridge=1] {
			::outline { line-width: @edge_trunk_width_single + 2 * @edge_bridge_border_thickness; }
		}
		[edge_bridge=0] {
			::outline { line-width: @edge_trunk_width_single + 2 * @edge_default_border_thickness; }
		}
	}
	[edge_oneway=0] {
		[edge_bridge=1] {
			::outline { line-width: @edge_trunk_width_dual + 2 * @edge_bridge_border_thickness; }
		}
		[edge_bridge=0] {
			::outline { line-width: @edge_trunk_width_dual + 2 * @edge_default_border_thickness; }
		}
	}
}

.edge-inner[class_name="Trunk road"] {
	::inline { 
		line-color: @edge_trunk_fill_colour; 
		[edge_tunnel=1] {
			line-color: lighten(@edge_trunk_fill_colour, @edge_tunnel_fill_lighten); 
			line-dasharray: @edge_tunnel_fill_dash_line, @edge_tunnel_fill_dash_space;
		}
	}
	[edge_oneway=1] { 
		::inline { line-width: @edge_trunk_width_single; }
		::lane-divide-left { line-offset: @edge_trunk_width_single / 2 + @edge_default_border_thickness / 2; }
		::lane-divide-right { line-offset: @edge_trunk_width_single / -2 + @edge_default_border_thickness / -2; }
		[access_name='Under construction'] {
			decoration/line-width: @edge_trunk_width_single;
			decoration/line-dasharray: @edge_access_decorator_construction_dash_line, @edge_access_decorator_construction_dash_space;
			decoration/line-color: @edge_access_decorator_construction_colour;
			decoration/line-cap: butt;		
		}
	}
	[edge_oneway=0] {
		::inline { line-width: @edge_trunk_width_dual; }
		::lane-divide-left { line-offset: @edge_trunk_width_dual / 2 + @edge_default_border_thickness / 2; }
		::lane-divide-right { line-offset: @edge_trunk_width_dual / -2 + @edge_default_border_thickness / -2; }
		[access_name='Under construction'] {
			decoration/line-width: @edge_trunk_width_dual;
			decoration/line-dasharray: @edge_access_decorator_construction_dash_line, @edge_access_decorator_construction_dash_space;
			decoration/line-color: @edge_access_decorator_construction_colour;
			decoration/line-cap: butt;		
		}
	}
}

.edge-outer[class_name="A road"] {
	[edge_oneway=1] { 
		[edge_bridge=1] {
			::outline { line-width: @edge_a_road_width_single + 2 * @edge_bridge_border_thickness; }
		}
		[edge_bridge=0] {
			::outline { line-width: @edge_a_road_width_single + 2 * @edge_default_border_thickness; }
		}
	}
	[edge_oneway=0] {
		[edge_bridge=1] {
			::outline { line-width: @edge_a_road_width_dual + 2 * @edge_bridge_border_thickness; }
		}
		[edge_bridge=0] {
			::outline { line-width: @edge_a_road_width_dual + 2 * @edge_default_border_thickness; }
		}
	}
}

.edge-inner[class_name="A road"] {
	::inline { 
		line-color: @edge_a_road_fill_colour; 
		[edge_tunnel=1] {
			line-color: lighten(@edge_a_road_fill_colour, @edge_tunnel_fill_lighten); 
			line-dasharray: @edge_tunnel_fill_dash_line, @edge_tunnel_fill_dash_space;
		}
	}
	[edge_oneway=1] { 
		::inline { line-width: @edge_a_road_width_single; }
		::lane-divide-left { line-offset: @edge_a_road_width_single / 2 + @edge_default_border_thickness / 2; }
		::lane-divide-right { line-offset: @edge_a_road_width_single / -2 + @edge_default_border_thickness / -2; }
	}
	[edge_oneway=0] {
		::inline { line-width: @edge_a_road_width_dual; }
		::lane-divide-left { line-offset: @edge_a_road_width_dual / 2 + @edge_default_border_thickness / 2; }
		::lane-divide-right { line-offset: @edge_a_road_width_dual / -2 + @edge_default_border_thickness / -2; }
	}
}

.edge-outer[class_name="B road"] {
	[edge_oneway=1] { 
		[edge_bridge=1] {
			::outline { line-width: @edge_b_road_width_single + 2 * @edge_bridge_border_thickness; }
		}
		[edge_bridge=0] {
			::outline { line-width: @edge_b_road_width_single + 2 * @edge_default_border_thickness; }
		}
	}
	[edge_oneway=0] {
		[edge_bridge=1] {
			::outline { line-width: @edge_b_road_width_dual + 2 * @edge_bridge_border_thickness; }
		}
		[edge_bridge=0] {
			::outline { line-width: @edge_b_road_width_dual + 2 * @edge_default_border_thickness; }
		}
	}
}

.edge-inner[class_name="B road"] {
	::inline { 
		line-color: @edge_b_road_fill_colour; 
		[edge_tunnel=1] {
			line-color: lighten(@edge_b_road_fill_colour, @edge_tunnel_fill_lighten); 
			line-dasharray: @edge_tunnel_fill_dash_line, @edge_tunnel_fill_dash_space;
		}
	}
	[edge_oneway=1] { 
		::inline { line-width: @edge_b_road_width_single; }
		::lane-divide-left { line-offset: @edge_b_road_width_single / 2 + @edge_default_border_thickness / 2; }
		::lane-divide-right { line-offset: @edge_b_road_width_single / -2 + @edge_default_border_thickness / -2; }
		[access_name='Under construction'] {
			decoration/line-width: @edge_b_road_width_single;
			decoration/line-dasharray: @edge_access_decorator_construction_dash_line, @edge_access_decorator_construction_dash_space;
			decoration/line-color: @edge_access_decorator_construction_colour;
			decoration/line-cap: butt;		
		}
	}
	[edge_oneway=0] {
		::inline { line-width: @edge_b_road_width_dual; }
		::lane-divide-left { line-offset: @edge_b_road_width_dual / 2 + @edge_default_border_thickness / 2; }
		::lane-divide-right { line-offset: @edge_b_road_width_dual / -2 + @edge_default_border_thickness / -2; }
		[access_name='Under construction'] {
			decoration/line-width: @edge_b_road_width_dual;
			decoration/line-dasharray: @edge_access_decorator_construction_dash_line, @edge_access_decorator_construction_dash_space;
			decoration/line-color: @edge_access_decorator_construction_colour;
			decoration/line-cap: butt;		
		}
	}
}

.edge-outer[class_name="Minor road"] {
	[edge_bridge=1] {
		::outline { 
			line-width: @edge_minor_road_width + 2 * @edge_bridge_border_thickness; 
		}
	}
	[edge_bridge=0] {
		::outline { 
			line-width: @edge_minor_road_width + 2 * @edge_default_border_thickness; 
			line-cap: square;
		}
	}
}

.edge-inner[class_name="Minor road"] {
	::inline { 
		line-color: @edge_minor_road_fill_colour;
		line-width: @edge_minor_road_width; 
		[edge_tunnel=1] {
			line-color: lighten(@edge_minor_road_fill_colour, @edge_tunnel_fill_lighten); 
			line-dasharray: @edge_tunnel_fill_dash_line, @edge_tunnel_fill_dash_space;
		}
		[access_name='Under construction'] {
			decoration/line-width: @edge_minor_road_width;
			decoration/line-dasharray: @edge_access_decorator_construction_dash_line, @edge_access_decorator_construction_dash_space;
			decoration/line-color: @edge_access_decorator_construction_colour;
			decoration/line-cap: butt;		
		}
	}
}

.edge-outer[class_name="Local street"] {
	[edge_bridge=1] {
		::outline { 
			line-width: @edge_local_street_width + 2 * @edge_bridge_border_thickness; 
		}
	}
	[edge_bridge=0] {
		::outline { 
			line-width: @edge_local_street_width + 2 * @edge_default_border_thickness; 
			line-cap: square;
		}
	}
}

.edge-inner[class_name="Local street"] {
	::inline { 
		line-color: @edge_local_street_fill_colour; 
		line-width: @edge_local_street_width; 
		[edge_tunnel=1] {
			line-color: lighten(@edge_local_street_fill_colour, @edge_tunnel_fill_lighten); 
			line-dasharray: @edge_tunnel_fill_dash_line, @edge_tunnel_fill_dash_space;
		}
		[access_name='Under construction'] {
			decoration/line-width: @edge_local_street_width;
			decoration/line-dasharray: @edge_access_decorator_construction_dash_line, @edge_access_decorator_construction_dash_space;
			decoration/line-color: @edge_access_decorator_construction_colour;
			decoration/line-cap: butt;		
		}
	}
}

.edge-outer[class_name="Service road"] {
	[edge_bridge=1] {
		::outline { line-width: @edge_service_road_width + 2 * @edge_bridge_border_thickness; }
	}
	[edge_bridge=0] {
		::outline { 
			line-width: @edge_service_road_width + 2 * @edge_default_border_thickness; 
			line-cap: square;
		}
	}
}

.edge-inner[class_name="Service road"] {
	::inline { 
		line-color: @edge_service_road_fill_colour;
		line-width: @edge_service_road_width;
		[edge_tunnel=1] {
			line-color: lighten(@edge_service_road_fill_colour, @edge_tunnel_fill_lighten); 
			line-dasharray: @edge_tunnel_fill_dash_line, @edge_tunnel_fill_dash_space;
		}
		[access_name='Under construction'] {
			decoration/line-width: @edge_service_road_width;
			decoration/line-dasharray: @edge_access_decorator_construction_dash_line, @edge_access_decorator_construction_dash_space;
			decoration/line-color: @edge_access_decorator_construction_colour;
			decoration/line-cap: butt;		
		}
	}
}

.edge-outer[class_name="Parking"] {
	[edge_bridge=1] {
		::outline { 
			line-width: @edge_parking_width + 2 * @edge_bridge_border_thickness; 
		}
	}
	[edge_bridge=0] {
		::outline { 
			line-width: @edge_parking_width + 2 * @edge_default_border_thickness; 
			line-dasharray: @edge_parking_dash_line, @edge_parking_dash_space;
			line-color: @edge_parking_border_colour;
			line-cap: square;
		}
	}
}

.edge-inner[class_name="Parking"] {
	::inline { 
		line-width: @edge_parking_width;
		line-color: @edge_parking_fill_colour; 
		[edge_tunnel=1] {
			line-color: lighten(@edge_parking_fill_colour, @edge_tunnel_fill_lighten); 
			line-dasharray: @edge_tunnel_fill_dash_line, @edge_tunnel_fill_dash_space;
		}
	}
}

.edge-outer[class_name="Track"] {
	[edge_bridge=1] {
		::outline { 
			line-width: @edge_track_width + 2 * @edge_bridge_border_thickness; 
		}
	}
	[edge_bridge=0] {
		::outline { 
			line-width: @edge_track_width + 2 * @edge_default_border_thickness; 
			line-dasharray: @edge_track_dash_line, @edge_track_dash_space;
			line-color: @edge_track_border_colour;
			line-cap: square;
		}
	}
}

.edge-inner[class_name="Track"] {
	::inline { 
		line-color: @edge_track_fill_colour;
		line-width: @edge_track_width; 
		[edge_tunnel=1] {
			line-color: lighten(@edge_track_fill_colour, @edge_tunnel_fill_lighten); 
			line-dasharray: @edge_tunnel_fill_dash_line, @edge_tunnel_fill_dash_space;
		}
	}
}

.edge-outer[class_name="Path"] {
	[edge_bridge=1] {
		::outline { 
			line-width: @edge_track_width + 2 * @edge_bridge_border_thickness; 
		}
	}
	[edge_bridge=0] {
		::outline { 
			line-opacity: 0;
		}
	}
}

.edge-inner[class_name="Path"] {
	::inline { 
		line-color: @edge_path_fill_colour; 
		line-width: @edge_path_width; 
		[edge_tunnel=1] {
			line-color: lighten(@edge_path_fill_colour, @edge_tunnel_fill_lighten); 
			line-dasharray: @edge_tunnel_fill_dash_line, @edge_tunnel_fill_dash_space;
		}
	}
}

.edge-outer[class_name="Right of way"] {
	[edge_bridge=1] {
		::outline { 
			line-width: @edge_path_width + 2 * @edge_bridge_border_thickness; 
		}
	}
	[edge_bridge=0] {
		::outline { 
			line-opacity: 0;
		}
	}
}

.edge-inner[class_name="Right of way"] {
	[edge_bridge=1] {
		::inline { 
			line-color: @edge_path_fill_colour;
			line-width: @edge_path_width + 2 * @edge_bridge_border_thickness; 
		}
	}
	[edge_bridge=0] {
		::inline { 
			line-opacity: 0;
		}
	}
}

.edge-inner[class_name="Path"],
.edge-inner[class_name="Right of way"],
.edge-inner[class_name="Track"],
.edge-inner[access_name="Pedestrianised road"] {
	::inline {
		decoration/line-width: @edge_access_decorator_minor_width;
		decoration/line-dasharray: @edge_access_decorator_path_dash_line, @edge_access_decorator_path_dash_space;
		decoration/line-color: @edge_access_decorator_path_colour;
		decoration/line-cap: butt;		
		
		[class_name="Track"] {
			[access_name="Byway open to all traffic"],
			[access_name="Unknown access"],
			[access_name="Public road"], 
			[access_name="Private road"] {
				decoration/line-width: 0;
			}
		}
		
		/*
		 *	We only mark 'footpath' as though it were a legal footpath in areas where it probably
		 *  is, which is those where we don't have the definitive record from the authority.
		 */
		/*
		[access_name="Footpath"] {
			decoration/line-width: @edge_access_decorator_major_width;
			decoration/line-dasharray: @edge_access_decorator_legalpath_dash_line, @edge_access_decorator_legalpath_dash_space;
			decoration/line-color: @edge_access_decorator_legalpath_colour;
		}
		*/
		
		[access_name="Pedestrianised road"] {
			decoration/line-width: @edge_access_decorator_pedestrianised_width;
			decoration/line-dasharray: @edge_access_decorator_pedestrianised_dash_line, @edge_access_decorator_pedestrianised_dash_space;
			decoration/line-color: @edge_access_decorator_pedestrianised_colour;
		}
		
		[access_name="Legal footpath"] {
			decoration/line-width: @edge_access_decorator_major_width;
			decoration/line-dasharray: @edge_access_decorator_legalpath_dash_line, @edge_access_decorator_legalpath_dash_space;
			decoration/line-color: @edge_access_decorator_legalpath_colour;
		}
		
		[access_name="Bridleway or cycle path"] {
			decoration/line-width: @edge_access_decorator_major_width;
			decoration/line-dasharray: @edge_access_decorator_bridleway_dash_line, @edge_access_decorator_bridleway_dash_space;
			decoration/line-color: @edge_access_decorator_bridleway_colour;
		}
		
		[access_name="Permissive path"] {
			decoration/line-width: @edge_access_decorator_major_width;
			decoration/line-dasharray: @edge_access_decorator_permpath_dash_line, @edge_access_decorator_permpath_dash_space;
			decoration/line-color: @edge_access_decorator_permpath_colour;
		}
	}
}

.edge-inner[class_name="Ferry"] {
	decoration/line-width: @edge_ferry_width;
	decoration/line-dasharray: @edge_ferry_dash_line, @edge_ferry_dash_space;
	decoration/line-color: @edge_ferry_colour;
	decoration/line-cap: butt;	
}