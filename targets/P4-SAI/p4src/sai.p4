// This is P4 sample source for sai
// Fill in these files with your P4 code


// includes
#include "headers.p4"
#include "parser.p4"
#include "tables.p4"
#include "actions.p4"
#include "defines.p4"
#include "field_lists.p4"

// headers
header 		ethernet_t 			ethernet;
header 		vlan_t 				vlan;
header 		ipv4_t 				ipv4;
header 		tcp_t 				tcp;
header 		udp_t				udp;

// metadata
metadata 	ingress_metadata_t 	 ingress_metadata;
metadata 	egress_metadata_t 	 egress_metadata;
metadata 	router_metadata_t 	 router_metadata;

control ingress {
	// phy
	control_ingress_port();
	// dot1br 
	//	control_dot1br_ingress();

	// bridging
	if ((ingress_metadata.l2_if_type == L2_1Q_BRIDGE) or (ingress_metadata.l2_if_type == L2_1D_BRIDGE)) {
		if (ingress_metadata.l2_if_type == L2_1D_BRIDGE)	{
			control_1d_bridge_flow();
		} else  {
			control_1q_bridge_flow();
		}

		control_fdb();
		control_egress_bridge();
	}

	// router
	if (ingress_metadata.l2_if_type == L2_ROUTER_TYPE) { 
		control_router_flow();
	}

	// Add another bridge flow - copy of tables again? :S
	// if egress_metadata.erif_type == L3_1D_BRIDGE {
	// }
	// if egress_metadata.erif_type == L3_1Q_BRIDGE {
	// }
}

control control_ingress_port{
	apply(table_ingress_lag);
	apply(table_accepted_frame_type) {
		miss {
			apply(table_accepted_frame_type_default_internal);
		}
	}
	//apply(table_ingress_acl); // TODO
	apply(table_ingress_l2_interface_type);
}

// control control_egress_port {
	// apply(table_egress_)
// }
//control control_dot1br_ingress{
	//apply(table_dot1br_port_type);
	//apply(table_extended_port_determination);
	//apply(table_dot1br_lag);
//}

control control_1d_bridge_flow{
	apply(table_bridge_id_1d);
	apply(table_vbridge_STP);
}

control control_1q_bridge_flow{
	apply(table_bridge_id_1q);
 	apply(table_ingress_vlan_filtering);
 	apply(table_ingress_vlan);
 	apply(table_xSTP_instance);
 	apply(table_xSTP);
}

control control_router_flow {
	apply(table_ingress_vrf);
	apply(table_router);
	if (router_metadata.is_next_hop_group == 1) {
		apply(table_next_hop_group);
	}
	apply(table_next_hop);
	apply(table_erif_check_ttl);
	// apply(table_erif_check_mtu);
	apply(table_neighbor);
	apply(table_egress_l3_if);
}

control control_fdb{
	apply(table_learn_fdb);
	apply(table_l3_interface){
		hit{
			apply(table_l3_if);
		}
		miss{
			// action_go_to_fdb_table{
			if((ethernet.srcAddr>>47) == UNICAST){ //TODO unicast - mac msb is off lsb of 1st byte should be 0.
				apply(table_fdb){
					miss { // if packet not in fdb
						apply(table_unknown_unicast);
					}
				}
			} else if(ingress_metadata.mcast_snp & ingress_metadata.ipmc){
				apply(table_mc_l2_sg_g);	
			} else if( not (ingress_metadata.mcast_snp & ingress_metadata.ipmc)){ // MC flow
				apply(table_mc_fdb);	
			}
			if(ingress_metadata.mc_fdb_miss == 1) {
				apply(table_unknown_multicast);
			}
			//TODO duplicate to multiple egress according to fdb list
		}

	}
}

control control_egress_bridge {
	if(ingress_metadata.l2_if_type == L2_1D_BRIDGE){
		apply(table_egress_vbridge_STP);
	}
	if(ingress_metadata.l2_if_type == L2_1Q_BRIDGE){
		apply(table_egress_xSTP);
		apply(table_egress_vlan_filtering);
	}

	apply(table_egress_br_port_to_if);
	if(ingress_metadata.l2_if_type == L2_1D_BRIDGE){
		apply(table_egress_set_vlan);
	}
}

control egress{
	apply(table_egress_vlan_tag);
	if (egress_metadata.out_if_type == OUT_IF_IS_LAG) { 
		apply(table_lag_hash);
		apply(table_egress_lag);
	}
	//apply(egress_acl); // TODO
	//if((egress_metadata.stp_state == STP_FORWARDING) and (egress_metadata.tag_mode == TAG) ){
		// TODO: go to egress
	//}
}

