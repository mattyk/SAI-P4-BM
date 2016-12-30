#include "defines.p4"
// primitives
action _drop() {
    drop();
}

action _nop() {
	no_op();
}

// ingres L2
action action_set_lag_l2if(in bit is_lag, in bit<16> lag_id,in bit<3> l2_if){
	ingress_metadata.is_lag	=	is_lag;
	ingress_metadata.lag_id =	lag_id;
	ingress_metadata.l2_if 	=	l2_if;
}

action action_set_pvid(in bit<12> pvid){
	ingress_metadata.vid 	=	pvid;
}
action action_set_packet_vid(){
	ingress_metadata.vid 	=	vlan.vid;
}

action action_set_l2_if_type(in bit<2> l2_if_type, in bit<8> bridge_port){
	// L2_BRIDGE_PORT_WDT
	ingress_metadata.l2_if_type = l2_if_type;
	ingress_metadata.bridge_port = bridge_port; 
}

action action_set_bridge_id(in bit<3> bridge_id){
	ingress_metadata.bridge_id = bridge_id;
}
action action_set_bridge_id_with_vid() {
	ingress_metadata.bridge_id = ingress_metadata.vid;
}

action action_set_mcast_snp(in bit<1> mcast_snp){
	ingress_metadata.mcast_snp = mcast_snp;
}
action action_set_stp_state(in bit<3> stp_state){
	ingress_metadata.stp_state = stp_state;
}

action action_set_stp_id(in bit<3> stp_id){
	ingress_metadata.stp_id = stp_id;
}

action action_go_to_in_l3_if_table(){
	no_op();
}
//action action_go_to_fdb_table(){
//	no_op();
//}

//modify_field (ingress_metadata.,);

// L2
action action_learn_mac() {
    generate_digest(MAC_LEARN_RECEIVER, mac_learn_digest);
}

action action_set_egress_br_port(in bit<8> br_port){
	egress_metadata.bridge_port = br_port;
}

action action_forward_set_outIfType(in bit<6> out_if,in bit<1> out_if_type){
	egress_metadata.out_if 			= out_if;
	egress_metadata.out_if_type 	= out_if_type;
	standard_metadata.egress_spec = out_if; 
}

action action_ste_fdb_miss(in bit mc_fdb_miss){
	ingress_metadata.mc_fdb_miss = mc_fdb_miss;
}

action action_forward(in bit<6> port) {
    standard_metadata.egress_spec 	= port;	
    egress_metadata.out_if 			= port;
}

action action_forward_mc_set_if_list(){
	// TODO add set egress if list
}

action action_set_egress_stp_state(in bit<2> stp_state){
	egress_metadata.stp_state = stp_state;
}

action action_untag_vlan() {
	no_op();
}

action action_forward_vlan_tag(in bit<3> pcp, in bit cfi){
	add_header(vlan);
	vlan.pcp = pcp;
	vlan.cfi = cfi;
	vlan.vid = ingress_metadata.vid;
	vlan.etherType = ethernet.etherType;
	ethernet.etherType = VLAN_TYPE;
	// egress_metadata.tag_mode = tag_mode;
}

action action_set_lag_hash_size(in bit<6> lag_size) {
	modify_field_with_hash_based_offset(egress_metadata.hash_val, 0, lag_hash, lag_size);
}

action action_set_out_port(in bit<6> port){
	standard_metadata.egress_spec 	= port;
}

action broadcast() {
    modify_field(egress_metadata.mcast_grp, 1);
}

action set_egr(in bit<6> egress_spec) {
    modify_field(standard_metadata.egress_spec, egress_spec);
}

// mc
action action_set_mc_fdb_miss() {
	no_op();
}
