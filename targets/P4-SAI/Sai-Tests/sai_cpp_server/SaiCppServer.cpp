
#include <iostream>
#include <list>
#include <algorithm>
/// thrift sai server
#include "../sai_thrift_src/gen-cpp/switch_sai_rpc.h"

#include <thrift/server/TSimpleServer.h>
#include <thrift/transport/TServerSocket.h>
#include <thrift/transport/TBufferTransports.h>
#include <thrift/transport/TTransportUtils.h>
#include "../../../../thrift_src/gen-cpp/bm/Standard.h"

// thrift bm clinet
#include <thrift/protocol/TBinaryProtocol.h>
#include <thrift/protocol/TMultiplexedProtocol.h>
#include <thrift/transport/TSocket.h>

//SAI
#ifdef __cplusplus
extern "C" {
#endif
#include <sai.h>
#ifdef __cplusplus
}
#endif

#include <saifdb.h>
#include <saivlan.h>
#include <sairouter.h>
#include <sairouterintf.h>
#include <sairoute.h>
#include <saiswitch.h>
#include <saimirror.h>
#include <saistatus.h>

// INTERNAL
#include "switch_meta_data.h"




using namespace std;
using namespace ::apache::thrift;
using namespace ::apache::thrift::protocol;
using namespace ::apache::thrift::transport;
using namespace ::apache::thrift::server;

using boost::shared_ptr;
using namespace bm_runtime::standard;
using namespace  ::switch_sai;

// globals 
const int bm_port = 9090;
const int sai_port = 9092;
const int32_t cxt_id =0;

class switch_sai_rpcHandler : virtual public switch_sai_rpcIf {
 public:

  ~switch_sai_rpcHandler() {
  //deconstructor
    transport->close();
    cout << "BM clients closed\n";
  }
  switch_sai_rpcHandler():
  //constructor pre initializations
  socket(new TSocket("localhost", bm_port)),
  transport(new TBufferedTransport(socket)),
  bprotocol(new TBinaryProtocol(transport)),
  protocol (new TMultiplexedProtocol(bprotocol, "standard")),
  bm_client(protocol),
  active_vlans{}
      {
  // initialization   
    transport->open();
    cout << "BM connection started\n"; 
  //

  }

  sai_thrift_status_t sai_thrift_set_port_attribute(const sai_thrift_object_id_t port_id, const sai_thrift_attribute_t& thrift_attr) {
    // Your implementation goes here
    printf("sai_thrift_set_port_attribute\n");
  }

  void sai_thrift_get_port_attribute(sai_thrift_attribute_list_t& _return, const sai_thrift_object_id_t port_id) {
    // Your implementation goes here
    printf("sai_thrift_get_port_attribute\n");
  }

  void sai_thrift_get_port_stats(std::vector<int64_t> & _return, const sai_thrift_object_id_t port_id, const std::vector<sai_thrift_port_stat_counter_t> & counter_ids, const int32_t number_of_counters) {
    // Your implementation goes here
    printf("sai_thrift_get_port_stats\n");
  }

  sai_thrift_status_t sai_thrift_clear_port_all_stats(const sai_thrift_object_id_t port_id) {
    // Your implementation goes here
    printf("sai_thrift_clear_port_all_stats\n");
  }

  sai_thrift_status_t sai_thrift_create_fdb_entry(const sai_thrift_fdb_entry_t& thrift_fdb_entry, const std::vector<sai_thrift_attribute_t> & thrift_attr_list) {
    // Your implementation goes here
    printf("sai_thrift_create_fdb_entry\n");
  }

  sai_thrift_status_t sai_thrift_delete_fdb_entry(const sai_thrift_fdb_entry_t& thrift_fdb_entry) {
    // Your implementation goes here
    printf("sai_thrift_delete_fdb_entry\n");
  }

  sai_thrift_status_t sai_thrift_flush_fdb_entries(const std::vector<sai_thrift_attribute_t> & thrift_attr_list) {
    // Your implementation goes here
    printf("sai_thrift_flush_fdb_entries\n");
  }

  sai_thrift_status_t sai_thrift_create_vlan(const sai_thrift_vlan_id_t vlan_id) {
  
  // Your implementation goes here
    auto it = std::find_if( std::begin( active_vlans ),
                            std::end( active_vlans ),
                            vlan_id );

    if ( myList.end() == it )
    {
        std::cout << "creating vlan" << std::endl;
    }
    else
    {
        const int pos = std::distance( myList.begin(), it ) + 1;
        printf("vlan id %d already exists \n",vlan_id);
    }
  //  std::string table_name = "table_ingress_lag"; 
  //  BmEntryHandle handle = 0;
  
  //  bm_client.bm_mt_delete_entry(cxt_id, table_name, handle);

    printf("sai_thrift_create_vlan\n");
    return 0;
  }

  sai_thrift_status_t sai_thrift_delete_vlan(const sai_thrift_vlan_id_t vlan_id) {
    // Your implementation goes here
    printf("sai_thrift_delete_vlan\n");
  }

  void sai_thrift_get_vlan_stats(std::vector<int64_t> & _return, const sai_thrift_vlan_id_t vlan_id, const std::vector<sai_thrift_vlan_stat_counter_t> & counter_ids, const int32_t number_of_counters) {
    // Your implementation goes here
    printf("sai_thrift_get_vlan_stats\n");
  }

  sai_thrift_object_id_t sai_thrift_create_vlan_member(const std::vector<sai_thrift_attribute_t> & thrift_attr_list) {
    // Your implementation goes here
    printf("sai_thrift_create_vlan_member\n");
  }

  sai_thrift_status_t sai_thrift_remove_vlan_member(const sai_thrift_object_id_t vlan_member_id) {
    // Your implementation goes here
    printf("sai_thrift_remove_vlan_member\n");
  }

  void sai_thrift_get_vlan_attribute(sai_thrift_attribute_list_t& _return, const sai_thrift_object_id_t vlan_id) {
    // Your implementation goes here
    printf("sai_thrift_get_vlan_attribute\n");
  }

  sai_thrift_object_id_t sai_thrift_create_virtual_router(const std::vector<sai_thrift_attribute_t> & thrift_attr_list) {
    // Your implementation goes here
    printf("sai_thrift_create_virtual_router\n");
  }

  sai_thrift_status_t sai_thrift_remove_virtual_router(const sai_thrift_object_id_t vr_id) {
    // Your implementation goes here
    printf("sai_thrift_remove_virtual_router\n");
  }

  sai_thrift_status_t sai_thrift_create_route(const sai_thrift_unicast_route_entry_t& thrift_unicast_route_entry, const std::vector<sai_thrift_attribute_t> & thrift_attr_list) {
    // Your implementation goes here
    printf("sai_thrift_create_route\n");
  }

  sai_thrift_status_t sai_thrift_remove_route(const sai_thrift_unicast_route_entry_t& thrift_unicast_route_entry) {
    // Your implementation goes here
    printf("sai_thrift_remove_route\n");
  }

  sai_thrift_object_id_t sai_thrift_create_router_interface(const std::vector<sai_thrift_attribute_t> & thrift_attr_list) {
    // Your implementation goes here
    printf("sai_thrift_create_router_interface\n");
  }

  sai_thrift_status_t sai_thrift_remove_router_interface(const sai_thrift_object_id_t rif_id) {
    // Your implementation goes here
    printf("sai_thrift_remove_router_interface\n");
  }

  sai_thrift_object_id_t sai_thrift_create_next_hop(const std::vector<sai_thrift_attribute_t> & thrift_attr_list) {
    // Your implementation goes here
    printf("sai_thrift_create_next_hop\n");
  }

  sai_thrift_status_t sai_thrift_remove_next_hop(const sai_thrift_object_id_t next_hop_id) {
    // Your implementation goes here
    printf("sai_thrift_remove_next_hop\n");
  }

  sai_thrift_object_id_t sai_thrift_create_next_hop_group(const std::vector<sai_thrift_attribute_t> & thrift_attr_list) {
    // Your implementation goes here
    printf("sai_thrift_create_next_hop_group\n");
  }

  sai_thrift_status_t sai_thrift_remove_next_hop_group(const sai_thrift_object_id_t next_hop_group_id) {
    // Your implementation goes here
    printf("sai_thrift_remove_next_hop_group\n");
  }

  sai_thrift_status_t sai_thrift_add_next_hop_to_group(const sai_thrift_object_id_t next_hop_group_id, const std::vector<sai_thrift_object_id_t> & thrift_nexthops) {
    // Your implementation goes here
    printf("sai_thrift_add_next_hop_to_group\n");
  }

  sai_thrift_status_t sai_thrift_remove_next_hop_from_group(const sai_thrift_object_id_t next_hop_group_id, const std::vector<sai_thrift_object_id_t> & thrift_nexthops) {
    // Your implementation goes here
    printf("sai_thrift_remove_next_hop_from_group\n");
  }

  sai_thrift_object_id_t sai_thrift_create_lag(const std::vector<sai_thrift_attribute_t> & thrift_attr_list) {
    // Your implementation goes here
    printf("sai_thrift_create_lag\n");
  }

  sai_thrift_status_t sai_thrift_remove_lag(const sai_thrift_object_id_t lag_id) {
    // Your implementation goes here
    printf("sai_thrift_remove_lag\n");
  }

  sai_thrift_object_id_t sai_thrift_create_lag_member(const std::vector<sai_thrift_attribute_t> & thrift_attr_list) {
    // Your implementation goes here
    printf("sai_thrift_create_lag_member\n");
  }

  sai_thrift_status_t sai_thrift_remove_lag_member(const sai_thrift_object_id_t lag_member_id) {
    // Your implementation goes here
    printf("sai_thrift_remove_lag_member\n");
  }

  sai_thrift_object_id_t sai_thrift_create_stp_entry(const std::vector<sai_thrift_attribute_t> & thrift_attr_list) {
    // Your implementation goes here
    printf("sai_thrift_create_stp_entry\n");
  }

  sai_thrift_status_t sai_thrift_remove_stp_entry(const sai_thrift_object_id_t stp_id) {
    // Your implementation goes here
    printf("sai_thrift_remove_stp_entry\n");
  }

  sai_thrift_status_t sai_thrift_set_stp_port_state(const sai_thrift_object_id_t stp_id, const sai_thrift_object_id_t port_id, const sai_thrift_port_stp_port_state_t stp_port_state) {
    // Your implementation goes here
    printf("sai_thrift_set_stp_port_state\n");
  }

  sai_thrift_port_stp_port_state_t sai_thrift_get_stp_port_state(const sai_thrift_object_id_t stp_id, const sai_thrift_object_id_t port_id) {
    // Your implementation goes here
    printf("sai_thrift_get_stp_port_state\n");
  }

  sai_thrift_status_t sai_thrift_create_neighbor_entry(const sai_thrift_neighbor_entry_t& thrift_neighbor_entry, const std::vector<sai_thrift_attribute_t> & thrift_attr_list) {
    // Your implementation goes here
    printf("sai_thrift_create_neighbor_entry\n");
  }

  sai_thrift_status_t sai_thrift_remove_neighbor_entry(const sai_thrift_neighbor_entry_t& thrift_neighbor_entry) {
    // Your implementation goes here
    printf("sai_thrift_remove_neighbor_entry\n");
  }

  void sai_thrift_get_switch_attribute(sai_thrift_attribute_list_t& _return) {
    // Your implementation goes here
    printf("sai_thrift_get_switch_attribute\n");
  }

  void sai_thrift_get_port_list_by_front_port(sai_thrift_attribute_t& _return) {
    // Your implementation goes here
    printf("sai_thrift_get_port_list_by_front_port\n");
  }

  sai_thrift_object_id_t sai_thrift_get_cpu_port_id() {
    // Your implementation goes here
    printf("sai_thrift_get_cpu_port_id\n");
  }

  sai_thrift_object_id_t sai_thrift_get_default_trap_group() {
    // Your implementation goes here
    printf("sai_thrift_get_default_trap_group\n");
  }

  sai_thrift_object_id_t sai_thrift_get_default_router_id() {
    // Your implementation goes here
    printf("sai_thrift_get_default_router_id\n");
  }

  sai_thrift_object_id_t sai_thrift_get_port_id_by_front_port(const std::string& port_name) {
    // Your implementation goes here
    printf("sai_thrift_get_port_id_by_front_port\n");
  }

  sai_thrift_status_t sai_thrift_set_switch_attribute(const sai_thrift_attribute_t& attribute) {
    // Your implementation goes here
    printf("sai_thrift_set_switch_attribute\n");
  }

  sai_thrift_object_id_t sai_thrift_create_hostif(const std::vector<sai_thrift_attribute_t> & thrift_attr_list) {
    // Your implementation goes here
    printf("sai_thrift_create_hostif\n");
  }

  sai_thrift_status_t sai_thrift_remove_hostif(const sai_thrift_object_id_t hif_id) {
    // Your implementation goes here
    printf("sai_thrift_remove_hostif\n");
  }

  sai_thrift_object_id_t sai_thrift_create_hostif_trap_group(const std::vector<sai_thrift_attribute_t> & thrift_attr_list) {
    // Your implementation goes here
    printf("sai_thrift_create_hostif_trap_group\n");
  }

  sai_thrift_status_t sai_thrift_remove_hostif_trap_group(const sai_thrift_object_id_t trap_group_id) {
    // Your implementation goes here
    printf("sai_thrift_remove_hostif_trap_group\n");
  }

  sai_thrift_status_t sai_thrift_create_hostif_trap(const std::vector<sai_thrift_attribute_t> & thrift_attr_list) {
    // Your implementation goes here
    printf("sai_thrift_create_hostif_trap\n");
  }

  sai_thrift_status_t sai_thrift_remove_hostif_trap(const sai_thrift_hostif_trap_id_t trap_id) {
    // Your implementation goes here
    printf("sai_thrift_remove_hostif_trap\n");
  }

  sai_thrift_status_t sai_thrift_set_hostif_trap(const sai_thrift_hostif_trap_id_t trap_id, const sai_thrift_attribute_t& thrift_attr) {
    // Your implementation goes here
    printf("sai_thrift_set_hostif_trap\n");
  }

  sai_thrift_status_t sai_thrift_set_hostif_trap_group(const sai_thrift_object_id_t trap_group_id, const sai_thrift_attribute_t& thrift_attr) {
    // Your implementation goes here
    printf("sai_thrift_set_hostif_trap_group\n");
  }

  sai_thrift_object_id_t sai_thrift_create_acl_table(const std::vector<sai_thrift_attribute_t> & thrift_attr_list) {
    // Your implementation goes here
    printf("sai_thrift_create_acl_table\n");
  }

  sai_thrift_status_t sai_thrift_delete_acl_table(const sai_thrift_object_id_t acl_table_id) {
    // Your implementation goes here
    printf("sai_thrift_delete_acl_table\n");
  }

  sai_thrift_object_id_t sai_thrift_create_acl_entry(const std::vector<sai_thrift_attribute_t> & thrift_attr_list) {
    // Your implementation goes here
    printf("sai_thrift_create_acl_entry\n");
  }

  sai_thrift_status_t sai_thrift_delete_acl_entry(const sai_thrift_object_id_t acl_entry) {
    // Your implementation goes here
    printf("sai_thrift_delete_acl_entry\n");
  }

  sai_thrift_object_id_t sai_thrift_create_acl_counter(const std::vector<sai_thrift_attribute_t> & thrift_attr_list) {
    // Your implementation goes here
    printf("sai_thrift_create_acl_counter\n");
  }

  sai_thrift_status_t sai_thrift_delete_acl_counter(const sai_thrift_object_id_t acl_counter_id) {
    // Your implementation goes here
    printf("sai_thrift_delete_acl_counter\n");
  }

  void sai_thrift_get_acl_counter_attribute(std::vector<sai_thrift_attribute_value_t> & _return, const sai_thrift_object_id_t acl_counter_id, const std::vector<int32_t> & thrift_attr_ids) {
    // Your implementation goes here
    printf("sai_thrift_get_acl_counter_attribute\n");
  }

  sai_thrift_object_id_t sai_thrift_create_mirror_session(const std::vector<sai_thrift_attribute_t> & thrift_attr_list) {
    // Your implementation goes here
    printf("sai_thrift_create_mirror_session\n");
  }

  sai_thrift_status_t sai_thrift_remove_mirror_session(const sai_thrift_object_id_t session_id) {
    // Your implementation goes here
    printf("sai_thrift_remove_mirror_session\n");
  }

  sai_thrift_object_id_t sai_thrift_create_policer(const std::vector<sai_thrift_attribute_t> & thrift_attr_list) {
    // Your implementation goes here
    printf("sai_thrift_create_policer\n");
  }

  sai_thrift_status_t sai_thrift_remove_policer(const sai_thrift_object_id_t policer_id) {
    // Your implementation goes here
    printf("sai_thrift_remove_policer\n");
  }

  void sai_thrift_get_policer_stats(std::vector<int64_t> & _return, const sai_thrift_object_id_t policer_id, const std::vector<sai_thrift_policer_stat_counter_t> & counter_ids) {
    // Your implementation goes here
    printf("sai_thrift_get_policer_stats\n");
  }

  sai_thrift_object_id_t sai_thrift_create_scheduler_profile(const std::vector<sai_thrift_attribute_t> & thrift_attr_list) {
    // Your implementation goes here
    printf("sai_thrift_create_scheduler_profile\n");
  }

  sai_thrift_status_t sai_thrift_remove_scheduler_profile(const sai_thrift_object_id_t scheduler_id) {
    // Your implementation goes here
    printf("sai_thrift_remove_scheduler_profile\n");
  }

  void sai_thrift_get_queue_stats(std::vector<int64_t> & _return, const sai_thrift_object_id_t queue_id, const std::vector<sai_thrift_queue_stat_counter_t> & counter_ids, const int32_t number_of_counters) {
    // Your implementation goes here
    printf("sai_thrift_get_queue_stats\n");
  }

  sai_thrift_status_t sai_thrift_clear_queue_stats(const sai_thrift_object_id_t queue_id, const std::vector<sai_thrift_queue_stat_counter_t> & counter_ids, const int32_t number_of_counters) {
    // Your implementation goes here
    printf("sai_thrift_clear_queue_stats\n");
  }

  sai_thrift_status_t sai_thrift_set_queue_attribute(const sai_thrift_object_id_t queue_id, const sai_thrift_attribute_t& thrift_attr) {
    // Your implementation goes here
    printf("sai_thrift_set_queue_attribute\n");
  }

  sai_thrift_object_id_t sai_thrift_create_buffer_profile(const std::vector<sai_thrift_attribute_t> & thrift_attr_list) {
    // Your implementation goes here
    printf("sai_thrift_create_buffer_profile\n");
  }

  sai_thrift_object_id_t sai_thrift_create_pool_profile(const std::vector<sai_thrift_attribute_t> & thrift_attr_list) {
    // Your implementation goes here
    printf("sai_thrift_create_pool_profile\n");
  }

  sai_thrift_status_t sai_thrift_set_priority_group_attribute(const sai_thrift_object_id_t pg_id, const sai_thrift_attribute_t& thrift_attr) {
    // Your implementation goes here
    printf("sai_thrift_set_priority_group_attribute\n");
  }

  void sai_thrift_get_pg_stats(std::vector<int64_t> & _return, const sai_thrift_object_id_t pg_id, const std::vector<sai_thrift_pg_stat_counter_t> & counter_ids, const int32_t number_of_counters) {
    // Your implementation goes here
    printf("sai_thrift_get_pg_stats\n");
  }

  sai_thrift_object_id_t sai_thrift_create_wred_profile(const std::vector<sai_thrift_attribute_t> & thrift_attr_list) {
    // Your implementation goes here
    printf("sai_thrift_create_wred_profile\n");
  }

  sai_thrift_status_t sai_thrift_remove_wred_profile(const sai_thrift_object_id_t wred_id) {
    // Your implementation goes here
    printf("sai_thrift_remove_wred_profile\n");
  }

  sai_thrift_object_id_t sai_thrift_create_qos_map(const std::vector<sai_thrift_attribute_t> & thrift_attr_list) {
    // Your implementation goes here
    printf("sai_thrift_create_qos_map\n");
  }

  sai_thrift_status_t sai_thrift_remove_qos_map(const sai_thrift_object_id_t qos_map_id) {
    // Your implementation goes here
    printf("sai_thrift_remove_qos_map\n");
  }
private:
  boost::shared_ptr<TTransport> socket;
  boost::shared_ptr<TTransport> transport;
  boost::shared_ptr<TProtocol>  bprotocol;
  boost::shared_ptr<TProtocol>  protocol;
  std::list<sai_thrift_vlan_id_t> active_vlans;

public:
  StandardClient bm_client;
};


int main(int argc, char **argv) {
  // open server to sai functions
  printf("creating server for SAI on port %d \n", sai_port);
  boost::shared_ptr<switch_sai_rpcHandler> handler(new switch_sai_rpcHandler());
  boost::shared_ptr<TProcessor> processor(new switch_sai_rpcProcessor(handler));
  boost::shared_ptr<TServerTransport> serverTransport(new TServerSocket(sai_port));
  boost::shared_ptr<TTransportFactory> transportFactory(new TBufferedTransportFactory());
  boost::shared_ptr<TProtocolFactory> protocolFactory(new TBinaryProtocolFactory());

  TSimpleServer server(processor, serverTransport, transportFactory, protocolFactory);
  printf("sai server started \n");
  server.serve();
  
  
  printf("thrift done\n");
    return 0;
}

