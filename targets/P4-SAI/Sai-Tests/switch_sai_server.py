import sys
sys.path.append('sai_thrift_src/gen-py')
sys.path.append('../')
sys.path.append('../../../tools/')
from cli_driver import SwitchThriftClient
from switch_sai import switch_sai_rpc
from switch_sai.ttypes import *

from thrift.transport import TSocket
from thrift.transport import TTransport
from thrift.protocol import TBinaryProtocol
from thrift.server import TServer

import socket

def list_to_str(num_list):
  st = ''
  for num in num_list:
    st = st + str(num) + ' '
  return st


def GetNewIndex(num_list):
  return min(set(xrange(len(num_list)+1)) - set(num_list))

class SaiHandler:
  def __init__(self):
    self.switch_id = 0
    self.log = {}
    print "connecting to cli thrift"
    self.cli_client = SwitchThriftClient(json='../sai.json')
    self.hw_port_list = [0, 1, 2, 3, 4, 5, 6, 7]
    self.ports = {}
    self.active_vlans = {}
    self.vlan_oids = {}
    self.bridge_ports = []
    self.bridge_ids = []

  def sai_thrift_create_switch(self, thrift_attr_list):
    self.switch_id

  def sai_thrift_get_switch_attribute(self, thrift_attr_list):
    hw_port_list = sai_thrift_u32_list_t(u32list=self.hw_port_list, count=len(self.hw_port_list))
    for attr in thrift_attr_list:
      if attr.id == sai_switch_attr.SAI_SWITCH_ATTR_PORT_LIST:
        attr.value = sai_thrift_attribute_value_t(u32list=hw_port_list)
        new_attr = sai_thrift_attribute_t(id=attr.id, value=attr.value)
    new_attr_list = sai_thrift_attribute_list_t(attr_list = [new_attr], attr_count=1)
    return new_attr_list

  def sai_thrift_create_vlan(self, thrift_attr_list):
    for attr in thrift_attr_list:
      if attr.id == sai_vlan_attr.SAI_VLAN_ATTR_VLAN_ID:
        vid = attr.value.u16
    if vid in self.active_vlans:
      print "vlan id %d already exists" % vid
      return -1
    else:
      print "vlan id %d created" % vid
      vlan_oid = GetNewIndex(self.vlan_oids.keys())
      self.vlan_oids.update({vlan_oid: vid})
      self.active_vlans.update({vid: []})
      return vlan_oid

  def sai_thrift_create_fdb_entry(self, thrift_fdb_entry, thrift_attr_list):
    # fdb_entry = sai_thrift_fdb_entry_t(mac_address=mac, vlan_id=vlan_id)
    for attr in thrift_attr_list:
      if attr.id == sai_fdb_entry_attr.SAI_FDB_ENTRY_ATTR_TYPE:
        entry_type = attr.value.s32
      elif attr.id == sai_fdb_entry_attr.SAI_FDB_ENTRY_ATTR_BRIDGE_PORT_ID:
        bridge_port = attr.value.oid
      elif attr.id == sai_fdb_entry_attr.SAI_FDB_ENTRY_ATTR_PACKET_ACTION:
        packet_action = attr.value.s32

    bridge_type = thrift_fdb_entry.bridge_type
    bridge_id = thrift_fdb_entry.bridge_id
    mac = thrift_fdb_entry.mac_address
    vlan_id = thrift_fdb_entry.vlan_id
    out_if_type = 0 # port_type (not lag or router). TODO: check how to do it with SAI

    match_str = thrift_fdb_entry.mac_address + ' ' + str(bridge_id)
    action_str = str(bridge_port)
    if packet_action == sai_packet_action.SAI_PACKET_ACTION_FORWARD:
      if entry_type == sai_fdb_entry_type.SAI_FDB_ENTRY_TYPE_STATIC:
        self.cli_client.AddTable('table_fdb', 'action_set_egress_br_port', match_str, action_str)
  	return 0

  def sai_thrift_delete_fdb_entry(self, thrift_fdb_entry):
    match_str = thrift_fdb_entry.mac_address + ' ' + str(thrift_fdb_entry.bridge_id)
    print "RemoveTableEntry: %s" % match_str
    self.cli_client.RemoveTableEntry('table_fdb', match_str)
    return 0

  def sai_thrift_delete_vlan(self, vlan_oid):
    vlan_id = self.vlan_oids[vlan_oid]
    self.active_vlans.pop(vlan_id, None)
    self.vlan_oids.pop(vlan_oid, None)
    return 0

  def sai_thrift_remove_vlan_member(self, vlan_member_id):
    for vlan_id, vlan_members in self.active_vlans.iteritems():
      if vlan_member_id in vlan_members:
        self.active_vlans[vlan_id].remove(vlan_member_id)
    # TODO, update tables as well?
    return 0

  def sai_thrift_create_vlan_member(self, vlan_member_attr_list):
  	# sai_vlan_tagging_mode.SAI_VLAN_TAGGING_MODE_TAGGED
  	# sai_vlan_tagging_mode.SAI_VLAN_TAGGING_MODE_UNTAGGED
    for attr in vlan_member_attr_list:
      if attr.id == sai_vlan_member_attr.SAI_VLAN_MEMBER_ATTR_VLAN_ID:
        vlan_oid = attr.value.oid
      elif attr.id == sai_vlan_member_attr.SAI_VLAN_MEMBER_ATTR_BRIDGE_PORT_ID:
        bridge_id = attr.value.oid
      elif attr.id == sai_vlan_member_attr.SAI_VLAN_MEMBER_ATTR_VLAN_TAGGING_MODE:
        tagging_mode = attr.value.s32
    all_vlan_members = [item for sublist in self.active_vlans.values() for item in sublist]
    vlan_member_id = GetNewIndex(all_vlan_members)
    vlan_id = self.vlan_oids[vlan_oid]
    self.active_vlans[vlan_id].append(vlan_member_id)
    print "test1"
    self.cli_client.AddTable('table_ingress_vlan_filtering','_nop',list_to_str([bridge_id, vlan_id]),'')
    print "test2"
    if tagging_mode == sai_vlan_tagging_mode.SAI_VLAN_TAGGING_MODE_TAGGED:
      vlan_pcp = 0 
      vlan_cfi = 0
      self.cli_client.AddTable('table_egress_vlan_filtering','action_set_vlan_tag_mode',
                               list_to_str([bridge_id, vlan_id, 0]), list_to_str([vlan_pcp, vlan_cfi]))
    else:
      self.cli_client.AddTable('table_egress_vlan_filtering','_nop',
                              list_to_str([bridge_id, vlan_id, 0]),'')

    self.cli_client.AddTable('table_egress_vlan_filtering','_nop',
                              list_to_str([bridge_id, vlan_id, 1]),'')
    return vlan_member_id

  def sai_thrift_set_port_attribute(self, port, attr):
    if attr.id == sai_port_attr.SAI_PORT_ATTR_PORT_VLAN_ID:
      vlan_id = attr.value.u16
    #self.cli_client.AddTable('table_ingress_lag', 'action_set_lag_l2if', str(port), list_to_str([0, 0,port]))  # TODO - this needs to be somehwere else
    self.cli_client.AddTable('table_accepted_frame_type', 'action_set_pvid', str(port), str(vlan_id))
    return 0

  def sai_thrift_create_bridge_port(self, thrift_attr_list):
    for attr in thrift_attr_list:
      if attr.id == sai_bridge_port_attr.SAI_BRIDGE_PORT_ATTR_VLAN_ID:
        vlan_id = attr.value.s32
      elif attr.id == sai_bridge_port_attr.SAI_BRIDGE_PORT_ATTR_BRIDGE_ID:
        bridge_id = attr.value.s32
      elif attr.id == sai_bridge_port_attr.SAI_BRIDGE_PORT_ATTR_TYPE:
        bridge_port_type = attr.value.s32
      elif attr.id == sai_bridge_port_attr.SAI_BRIDGE_PORT_ATTR_PORT_ID:
        port_id = attr.value.s32
    #TODO: Connect Thrift constants to P4 ?
    if bridge_port_type == sai_bridge_port_type.SAI_BRIDGE_PORT_TYPE_SUB_PORT:
      l2_if_type = 2  
    elif bridge_port_type == sai_bridge_port_type.SAI_BRIDGE_PORT_TYPE_PORT:
      l2_if_type = 3
    br_port = GetNewIndex(self.bridge_ports)
    self.bridge_ports.append(br_port)
    self.cli_client.AddTable('table_ingress_l2_interface_type', 'action_set_l2_if_type',
                             list_to_str([port_id, vlan_id]), list_to_str([l2_if_type, br_port]))
    self.cli_client.AddTable('table_vbridge', 'action_set_bridge_id', str(br_port), str(bridge_id))
    self.cli_client.AddTable('table_egress_br_port', 'action_forward_set_outIfType', str(br_port), list_to_str([self.ports[port_id], 0]))
    return br_port

  def sai_thrift_create_bridge(self, thrift_attr_list):
    for attr in thrift_attr_list:
      if attr.id == sai_bridge_attr.SAI_BRIDGE_ATTR_TYPE:
        bridge_type = attr.value.s32
    # bridge_type = sai_bridge_type.SAI_BRIDGE_TYPE_1D
    bridge_id = GetNewIndex(self.bridge_ids)
    return bridge_id

  def sai_thrift_create_port(self, thrift_attr_list):
    for attr in thrift_attr_list:
      if attr.id == sai_port_attr.SAI_PORT_ATTR_PORT_VLAN_ID:
        vlan_id = attr.value.u16
      elif attr.id == sai_port_attr.SAI_PORT_ATTR_BIND_MODE:
        bind_mode = attr.value.s32
      elif attr.id == sai_port_attr.SAI_PORT_ATTR_HW_LANE_LIST:
        hw_port_list = attr.value.u32list.u32list
    hw_port = hw_port_list[0]
    port = GetNewIndex(self.ports.keys())
    self.ports.update({port: hw_port})
    # TODO: Add support to ingress LAG.
    print "create port (%d): vlan - %d" % (port, vlan_id)
    self.cli_client.AddTable('table_ingress_lag', 'action_set_lag_l2if', str(hw_port), list_to_str([0, 0,port]))
    self.cli_client.AddTable('table_accepted_frame_type_default_internal', 'action_set_pvid', str(port), str(vlan_id))
    return port

handler = SaiHandler()
processor = switch_sai_rpc.Processor(handler)
transport = TSocket.TServerSocket(port=9092)
tfactory = TTransport.TBufferedTransportFactory()
pfactory = TBinaryProtocol.TBinaryProtocolFactory()

server = TServer.TSimpleServer(processor, transport, tfactory, pfactory)

print "Starting python server..."
server.serve()
print "done!"