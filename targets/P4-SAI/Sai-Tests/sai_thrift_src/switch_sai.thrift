/*
Copyright 2013-present Barefoot Networks, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

namespace py switch_sai
namespace cpp switch_sai

typedef i64 sai_thrift_object_id_t
typedef i16 sai_thrift_vlan_id_t
typedef string sai_thrift_mac_t
typedef byte sai_thrift_vlan_tagging_mode_t
typedef i32 sai_thrift_status_t
typedef string sai_thrift_ip4_t
typedef string sai_thrift_ip6_t
typedef byte sai_thrift_ip_addr_family_t
typedef byte sai_thrift_port_stp_port_state_t
typedef i32 sai_thrift_hostif_trap_id_t
typedef i32 sai_thrift_next_hop_type_t
typedef i32 sai_thrift_vlan_stat_counter_t
typedef i32 sai_thrift_policer_stat_counter_t
typedef i32 sai_thrift_port_stat_counter_t
typedef i32 sai_thrift_queue_stat_counter_t
typedef i32 sai_thrift_pg_stat_counter_t

enum sai_ip_addr_family_t {
    SAI_IP_ADDR_FAMILY_IPV4,
    SAI_IP_ADDR_FAMILY_IPV6
}

enum sai_switch_attr {
    SAI_SWITCH_ATTR_PORT_NUMBER,
    SAI_SWITCH_ATTR_PORT_LIST
}

enum sai_next_hop_type {
    SAI_NEXT_HOP_TYPE_IP,
    SAI_NEXT_HOP_TYPE_MPLS,
    SAI_NEXT_HOP_TYPE_TUNNEL_ENCAP
}

enum sai_next_hop_attr {
    SAI_NEXT_HOP_ATTR_TYPE,
    SAI_NEXT_HOP_ATTR_IP,
    SAI_NEXT_HOP_ATTR_ROUTER_INTERFACE_ID
}

enum sai_virtual_router_attr {
    SAI_VIRTUAL_ROUTER_ATTR_ADMIN_V4_STATE,
    SAI_VIRTUAL_ROUTER_ATTR_ADMIN_V6_STATE
}

enum sai_router_interface_attr {
    SAI_ROUTER_INTERFACE_ATTR_VIRTUAL_ROUTER_ID,
    SAI_ROUTER_INTERFACE_ATTR_TYPE,
    SAI_ROUTER_INTERFACE_ATTR_PORT_ID,
    SAI_ROUTER_INTERFACE_ATTR_VLAN_ID,
    SAI_ROUTER_INTERFACE_ATTR_SRC_MAC_ADDRESS,
    SAI_ROUTER_INTERFACE_ATTR_ADMIN_V4_STATE,
    SAI_ROUTER_INTERFACE_ATTR_ADMIN_V6_STATE
}

enum sai_router_interface_type {
    SAI_ROUTER_INTERFACE_TYPE_PORT,
    SAI_ROUTER_INTERFACE_TYPE_VLAN,
    SAI_ROUTER_INTERFACE_TYPE_LOOPBACK,
    SAI_ROUTER_INTERFACE_TYPE_SUB_PORT,
    SAI_ROUTER_INTERFACE_TYPE_BRIDGE

}

enum sai_bridge_port_type {
    SAI_BRIDGE_PORT_TYPE_PORT,
    SAI_BRIDGE_PORT_TYPE_SUB_PORT,
    SAI_BRIDGE_PORT_TYPE_1Q_ROUTER,
    SAI_BRIDGE_PORT_TYPE_1D_ROUTER,
    SAI_BRIDGE_PORT_TYPE_TUNNEL
}

enum sai_bridge_port_attr {
    SAI_BRIDGE_PORT_ATTR_TYPE,
    SAI_BRIDGE_PORT_ATTR_PORT_ID,
    SAI_BRIDGE_PORT_ATTR_VLAN_ID,
    SAI_BRIDGE_PORT_ATTR_RIF_ID,
    SAI_BRIDGE_PORT_ATTR_TUNNEL_ID,
    SAI_BRIDGE_PORT_ATTR_BRIDGE_ID,
    SAI_BRIDGE_PORT_ATTR_FDB_LEARNING_MODE,
}

enum sai_lag_member_attr { 
    SAI_LAG_MEMBER_ATTR_PORT_ID,
    SAI_LAG_MEMBER_ATTR_LAG_ID
}

enum sai_fdb_entry_attr {
    SAI_FDB_ENTRY_ATTR_TYPE,
    SAI_FDB_ENTRY_ATTR_PACKET_ACTION,
    SAI_FDB_ENTRY_ATTR_BRIDGE_PORT_ID,
    SAI_FDB_ENTRY_ATTR_META_DATA,
    SAI_FDB_ENTRY_ATTR_END
}
enum sai_fdb_entry_type {
    SAI_FDB_ENTRY_TYPE_DYNAMIC,
    SAI_FDB_ENTRY_TYPE_STATIC
}
enum sai_fdb_flush_attr{
    SAI_FDB_FLUSH_ATTR_PORT_ID,
    SAI_FDB_FLUSH_ATTR_VLAN_ID,
    SAI_FDB_FLUSH_ATTR_ENTRY_TYPE
}

enum sai_vlan_member_attr {
    SAI_VLAN_MEMBER_ATTR_VLAN_ID,
    SAI_VLAN_MEMBER_ATTR_BRIDGE_PORT_ID,
    SAI_VLAN_MEMBER_ATTR_VLAN_TAGGING_MODE
}

enum sai_vlan_attr {
    SAI_VLAN_ATTR_VLAN_ID,
    SAI_VLAN_ATTR_MEMBER_LIST
}

enum sai_port_attr {
    SAI_PORT_ATTR_BIND_MODE,
    SAI_PORT_ATTR_PORT_VLAN_ID,
    SAI_PORT_ATTR_HW_LANE_LIST
}

enum sai_bridge_attr {
    SAI_BRIDGE_ATTR_TYPE
}

enum sai_bridge_type {
    SAI_BRIDGE_TYPE_1Q,
    SAI_BRIDGE_TYPE_1D
}

enum sai_port_bind_mode {
    SAI_PORT_BIND_MODE_PORT,
    SAI_PORT_BIND_MODE_SUB_PORT
}

enum sai_fdb_entry_bridge_type
{
    SAI_FDB_ENTRY_BRIDGE_TYPE_1Q,
    SAI_FDB_ENTRY_BRIDGE_TYPE_1D
} 

enum sai_packet_action {
    SAI_PACKET_ACTION_DROP,
    SAI_PACKET_ACTION_FORWARD,
    SAI_PACKET_ACTION_COPY,
    SAI_PACKET_ACTION_COPY_CANCEL,
    SAI_PACKET_ACTION_TRAP,
    SAI_PACKET_ACTION_LOG,
    SAI_PACKET_ACTION_DENY,
    SAI_PACKET_ACTION_TRANSIT
}

enum sai_vlan_tagging_mode {
    SAI_VLAN_TAGGING_MODE_UNTAGGED ,
    SAI_VLAN_TAGGING_MODE_TAGGED ,
    SAI_VLAN_TAGGING_MODE_PRIORITY_TAGGED 
}

struct sai_thrift_fdb_entry_t {
    1: sai_thrift_mac_t mac_address;
    2: sai_thrift_vlan_id_t vlan_id;
    3: sai_fdb_entry_bridge_type bridge_type;
    4: sai_thrift_object_id_t bridge_id;
}

struct sai_thrift_vlan_port_t {
    1: sai_thrift_object_id_t port_id;
    2: sai_thrift_vlan_tagging_mode_t tagging_mode;
}

union sai_thrift_ip_t {
    1: sai_thrift_ip4_t ip4;
    2: sai_thrift_ip6_t ip6;
}

struct sai_thrift_ip_address_t {
    1: sai_thrift_ip_addr_family_t addr_family;
    2: sai_thrift_ip_t addr;
}

struct sai_thrift_ip_prefix_t {
    1: sai_thrift_ip_addr_family_t addr_family;
    2: sai_thrift_ip_t addr;
    3: sai_thrift_ip_t mask;
}

struct sai_thrift_object_list_t {
    1: i32 count;
    2: list<sai_thrift_object_id_t> object_id_list;
}

struct sai_thrift_vlan_list_t {
    1: i32 vlan_count;
    2: list<sai_thrift_vlan_id_t> vlan_list;
}

union sai_thrift_acl_mask_t {
    1: byte u8;
    2: byte s8;
    3: i16 u16;
    4: i16 s16;
    5: i32 u32;
    6: i32 s32;
    7: sai_thrift_mac_t mac;
    8: sai_thrift_ip4_t ip4;
    9: sai_thrift_ip6_t ip6;
}

union sai_thrift_acl_data_t {
    1: byte u8;
    2: byte s8;
    3: i16 u16;
    4: i16 s16;
    5: i32 u32;
    6: i32 s32;
    7: sai_thrift_mac_t mac;
    8: sai_thrift_ip4_t ip4;
    9: sai_thrift_ip6_t ip6;
    10: sai_thrift_object_id_t oid;
    11: sai_thrift_object_list_t objlist;
}

struct sai_thrift_acl_field_data_t
{
    1: bool enable;
    2: sai_thrift_acl_mask_t mask;
    3: sai_thrift_acl_data_t data;
}

union sai_thrift_acl_parameter_t {
    1: byte u8;
    2: byte s8;
    3: i16 u16;
    4: i16 s16;
    5: i32 u32;
    6: i32 s32;
    7: sai_thrift_mac_t mac;
    8: sai_thrift_ip4_t ip4;
    9: sai_thrift_ip6_t ip6;
    10: sai_thrift_object_id_t oid;
}

struct sai_thrift_acl_action_data_t {
    1: bool enable;
    2: sai_thrift_acl_parameter_t parameter;
}

struct sai_thrift_u32_list_t {
    1: i32 count;
    2: list<i32> u32list;
}

struct sai_thrift_qos_map_params_t {
    1: byte tc;
    2: byte dscp;
    3: byte dot1p;
    4: byte prio;
    5: byte pg;
    6: byte queue_index;
    7: byte color;
}

struct sai_thrift_qos_map_t {
    1: sai_thrift_qos_map_params_t key;
    2: sai_thrift_qos_map_params_t value;
}

struct sai_thrift_qos_map_list_t {
    1: i32 count;
    2: list<sai_thrift_qos_map_t> map_list;
}

union sai_thrift_attribute_value_t {
    1:  bool booldata;
    2:  string chardata;
    3:  byte u8;
    4:  byte s8;
    5:  i16 u16;
    6:  i16 s16;
    7:  i32 u32;
    8:  i32 s32;
    9:  i64 u64;
    10: i64 s64;
    11: sai_thrift_mac_t mac;
    12: sai_thrift_object_id_t oid;
    13: sai_thrift_ip4_t ip4;
    14: sai_thrift_ip6_t ip6;
    15: sai_thrift_ip_address_t ipaddr;
    16: sai_thrift_object_list_t objlist;
    17: sai_thrift_vlan_list_t vlanlist;
    18: sai_thrift_acl_field_data_t aclfield;
    19: sai_thrift_acl_action_data_t aclaction;
    20: sai_thrift_u32_list_t u32list;
    21: sai_thrift_qos_map_list_t qosmap;
}

struct sai_thrift_attribute_t {
    1: i32 id;
    2: sai_thrift_attribute_value_t value;
}

struct sai_thrift_unicast_route_entry_t {
    1: sai_thrift_object_id_t vr_id;
    2: sai_thrift_ip_prefix_t destination;
}

struct sai_thrift_neighbor_entry_t {
    1: sai_thrift_object_id_t rif_id;
    2: sai_thrift_ip_address_t ip_address;
}

struct sai_thrift_attribute_list_t {
    1: list<sai_thrift_attribute_t> attr_list;
    2: i32 attr_count; // redundant
}

service switch_sai_rpc {
    //port API
    sai_thrift_status_t sai_thrift_set_port_attribute(1: sai_thrift_object_id_t port_id, 2: sai_thrift_attribute_t thrift_attr);
    sai_thrift_attribute_list_t sai_thrift_get_port_attribute(1: sai_thrift_object_id_t port_id);
    list<i64> sai_thrift_get_port_stats(
                             1: sai_thrift_object_id_t port_id,
                             2: list<sai_thrift_port_stat_counter_t> counter_ids,
                             3: i32 number_of_counters);
    sai_thrift_status_t sai_thrift_clear_port_all_stats(1: sai_thrift_object_id_t port_id);

    sai_thrift_status_t sai_thrift_remove_port(1: sai_thrift_object_id_t port_id);
    sai_thrift_object_id_t sai_thrift_create_port(1: list<sai_thrift_attribute_t> thrift_attr_list);

    //bridge API
    sai_thrift_object_id_t sai_thrift_create_bridge(1: list<sai_thrift_attribute_t> thrift_attr_list);
    sai_thrift_status_t sai_thrift_remove_bridge(1: sai_thrift_object_id_t bridge_id);
    sai_thrift_object_id_t sai_thrift_create_bridge_port(1: list<sai_thrift_attribute_t> thrift_attr_list);
    sai_thrift_status_t sai_thrift_remove_bridge_port(1: sai_thrift_object_id_t bridge_port_id);

    //fdb API
    sai_thrift_status_t sai_thrift_create_fdb_entry(1: sai_thrift_fdb_entry_t thrift_fdb_entry, 2: list<sai_thrift_attribute_t> thrift_attr_list);
    sai_thrift_status_t sai_thrift_delete_fdb_entry(1: sai_thrift_fdb_entry_t thrift_fdb_entry);
    sai_thrift_status_t sai_thrift_flush_fdb_entries(1: list <sai_thrift_attribute_t> thrift_attr_list);

    //vlan API
    sai_thrift_object_id_t sai_thrift_create_vlan(1: list<sai_thrift_attribute_t> thrift_attr_list);
    sai_thrift_status_t sai_thrift_delete_vlan(1: sai_thrift_object_id_t vlan_id);
    
    list<i64> sai_thrift_get_vlan_stats(
                             1: sai_thrift_vlan_id_t vlan_id,
                             2: list<sai_thrift_vlan_stat_counter_t> counter_ids,
                             3: i32 number_of_counters);
    sai_thrift_object_id_t sai_thrift_create_vlan_member(1: list<sai_thrift_attribute_t> thrift_attr_list);
    sai_thrift_status_t sai_thrift_remove_vlan_member(1: sai_thrift_object_id_t vlan_member_id);
    sai_thrift_attribute_list_t sai_thrift_get_vlan_attribute(1: sai_thrift_object_id_t vlan_id);

    //virtual router API
    sai_thrift_object_id_t sai_thrift_create_virtual_router(1: list<sai_thrift_attribute_t> thrift_attr_list);
    sai_thrift_status_t sai_thrift_remove_virtual_router(1: sai_thrift_object_id_t vr_id);

    //route API
    sai_thrift_status_t sai_thrift_create_route(1: sai_thrift_unicast_route_entry_t thrift_unicast_route_entry, 2: list<sai_thrift_attribute_t> thrift_attr_list);
    sai_thrift_status_t sai_thrift_remove_route(1: sai_thrift_unicast_route_entry_t thrift_unicast_route_entry);

    //router interface API
    sai_thrift_object_id_t sai_thrift_create_router_interface(1: list<sai_thrift_attribute_t> thrift_attr_list);
    sai_thrift_status_t sai_thrift_remove_router_interface(1: sai_thrift_object_id_t rif_id);

    //next hop API
    sai_thrift_object_id_t sai_thrift_create_next_hop(1: list<sai_thrift_attribute_t> thrift_attr_list);
    sai_thrift_status_t sai_thrift_remove_next_hop(1: sai_thrift_object_id_t next_hop_id);

    //next hop group API
    sai_thrift_object_id_t sai_thrift_create_next_hop_group(1: list<sai_thrift_attribute_t> thrift_attr_list);
    sai_thrift_status_t sai_thrift_remove_next_hop_group(1: sai_thrift_object_id_t next_hop_group_id);
    sai_thrift_status_t sai_thrift_add_next_hop_to_group(1: sai_thrift_object_id_t next_hop_group_id, 2: list<sai_thrift_object_id_t> thrift_nexthops);
    sai_thrift_status_t sai_thrift_remove_next_hop_from_group(1: sai_thrift_object_id_t next_hop_group_id, 2: list<sai_thrift_object_id_t> thrift_nexthops);

    //lag API
    sai_thrift_object_id_t sai_thrift_create_lag(1: list<sai_thrift_attribute_t> thrift_attr_list);
    sai_thrift_status_t sai_thrift_remove_lag(1: sai_thrift_object_id_t lag_id);
    sai_thrift_object_id_t sai_thrift_create_lag_member(1: list<sai_thrift_attribute_t> thrift_attr_list);
    sai_thrift_status_t sai_thrift_remove_lag_member(1: sai_thrift_object_id_t lag_member_id);

    //stp API
    sai_thrift_object_id_t sai_thrift_create_stp_entry(1: list<sai_thrift_attribute_t> thrift_attr_list);
    sai_thrift_status_t sai_thrift_remove_stp_entry(1: sai_thrift_object_id_t stp_id);
    sai_thrift_status_t sai_thrift_set_stp_port_state(1: sai_thrift_object_id_t stp_id, 2: sai_thrift_object_id_t port_id, 3: sai_thrift_port_stp_port_state_t stp_port_state);
    sai_thrift_port_stp_port_state_t sai_thrift_get_stp_port_state(1: sai_thrift_object_id_t stp_id, 2: sai_thrift_object_id_t port_id);

    //neighbor API
    sai_thrift_status_t sai_thrift_create_neighbor_entry(1: sai_thrift_neighbor_entry_t thrift_neighbor_entry, 2: list<sai_thrift_attribute_t> thrift_attr_list);
    sai_thrift_status_t sai_thrift_remove_neighbor_entry(1: sai_thrift_neighbor_entry_t thrift_neighbor_entry);

    //switch API
    sai_thrift_object_id_t sai_thrift_create_switch(1: list<sai_thrift_attribute_t> thrift_attr_list);
    sai_thrift_attribute_list_t sai_thrift_get_switch_attribute(1: list<sai_thrift_attribute_t> thrift_attr_list);
    sai_thrift_attribute_t sai_thrift_get_port_list_by_front_port();
    sai_thrift_object_id_t sai_thrift_get_cpu_port_id();
    sai_thrift_object_id_t sai_thrift_get_default_trap_group();
    sai_thrift_object_id_t sai_thrift_get_default_router_id();
    sai_thrift_object_id_t sai_thrift_get_port_id_by_front_port(1: string port_name);
    sai_thrift_status_t sai_thrift_set_switch_attribute(1: sai_thrift_attribute_t attribute);

    //Trap API
    sai_thrift_object_id_t sai_thrift_create_hostif(1: list<sai_thrift_attribute_t> thrift_attr_list);
    sai_thrift_status_t sai_thrift_remove_hostif(1: sai_thrift_object_id_t hif_id);
    sai_thrift_object_id_t sai_thrift_create_hostif_trap_group(1: list<sai_thrift_attribute_t> thrift_attr_list);
    sai_thrift_status_t sai_thrift_remove_hostif_trap_group(1: sai_thrift_object_id_t trap_group_id);
    sai_thrift_status_t sai_thrift_create_hostif_trap(1: list<sai_thrift_attribute_t> thrift_attr_list);
    sai_thrift_status_t sai_thrift_remove_hostif_trap(1: sai_thrift_hostif_trap_id_t trap_id);
    sai_thrift_status_t sai_thrift_set_hostif_trap(1: sai_thrift_hostif_trap_id_t trap_id, 2: sai_thrift_attribute_t thrift_attr);
    sai_thrift_status_t sai_thrift_set_hostif_trap_group(1: sai_thrift_object_id_t trap_group_id, 2: sai_thrift_attribute_t thrift_attr);

    // ACL API
    sai_thrift_object_id_t sai_thrift_create_acl_table(1: list<sai_thrift_attribute_t> thrift_attr_list);
    sai_thrift_status_t sai_thrift_delete_acl_table(1: sai_thrift_object_id_t acl_table_id);

    sai_thrift_object_id_t sai_thrift_create_acl_entry(1: list<sai_thrift_attribute_t> thrift_attr_list);
    sai_thrift_status_t sai_thrift_delete_acl_entry(1: sai_thrift_object_id_t acl_entry);

    sai_thrift_object_id_t sai_thrift_create_acl_counter(1: list<sai_thrift_attribute_t> thrift_attr_list);
    sai_thrift_status_t sai_thrift_delete_acl_counter(1: sai_thrift_object_id_t acl_counter_id);
    list<sai_thrift_attribute_value_t> sai_thrift_get_acl_counter_attribute(
                             1: sai_thrift_object_id_t acl_counter_id,
                             2: list<i32> thrift_attr_ids);

    // Mirror API
    sai_thrift_object_id_t sai_thrift_create_mirror_session(1: list<sai_thrift_attribute_t> thrift_attr_list);
    sai_thrift_status_t sai_thrift_remove_mirror_session(1: sai_thrift_object_id_t session_id);

    // Policer API
    sai_thrift_object_id_t sai_thrift_create_policer(1: list<sai_thrift_attribute_t> thrift_attr_list);
    sai_thrift_status_t sai_thrift_remove_policer(1: sai_thrift_object_id_t policer_id);
    list<i64> sai_thrift_get_policer_stats(
                             1: sai_thrift_object_id_t policer_id,
                             2: list<sai_thrift_policer_stat_counter_t> counter_ids);

    // Scheduler API
    sai_thrift_object_id_t sai_thrift_create_scheduler_profile(1: list<sai_thrift_attribute_t> thrift_attr_list);
    sai_thrift_status_t sai_thrift_remove_scheduler_profile(1: sai_thrift_object_id_t scheduler_id);

    // Queue API
    list<i64> sai_thrift_get_queue_stats(
                             1: sai_thrift_object_id_t queue_id,
                             2: list<sai_thrift_queue_stat_counter_t> counter_ids,
                             3: i32 number_of_counters);
    sai_thrift_status_t sai_thrift_clear_queue_stats(
                             1: sai_thrift_object_id_t queue_id,
                             2: list<sai_thrift_queue_stat_counter_t> counter_ids,
                             3: i32 number_of_counters);
    sai_thrift_status_t sai_thrift_set_queue_attribute(1: sai_thrift_object_id_t queue_id,
                                                       2: sai_thrift_attribute_t thrift_attr)

    // Buffer API
    sai_thrift_object_id_t sai_thrift_create_buffer_profile(1: list<sai_thrift_attribute_t> thrift_attr_list);
    sai_thrift_object_id_t sai_thrift_create_pool_profile(1: list<sai_thrift_attribute_t> thrift_attr_list);
    sai_thrift_status_t sai_thrift_set_priority_group_attribute(1: sai_thrift_object_id_t pg_id,
                                                                2: sai_thrift_attribute_t thrift_attr)
    list<i64> sai_thrift_get_pg_stats(
                         1: sai_thrift_object_id_t pg_id,
                         2: list<sai_thrift_pg_stat_counter_t> counter_ids,
                         3: i32 number_of_counters);

    // WRED API
    sai_thrift_object_id_t sai_thrift_create_wred_profile(1: list<sai_thrift_attribute_t> thrift_attr_list);
    sai_thrift_status_t sai_thrift_remove_wred_profile(1: sai_thrift_object_id_t wred_id);

    // QoS Map API
    sai_thrift_object_id_t sai_thrift_create_qos_map(1: list<sai_thrift_attribute_t> thrift_attr_list);
    sai_thrift_status_t sai_thrift_remove_qos_map(1: sai_thrift_object_id_t qos_map_id);
}
