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

def CreateNewItem(obj_list, obj_class):
    new_id = GetNewIndex(obj_list.keys())
    new_obj = obj_class(id=new_id)
    obj_list[new_id] = new_obj
    # obj_list.update({new_id: new_obj})
    return new_id, new_obj

class Sai_obj():
    def __init__(self, id):
        self.id = id


class Port_obj(Sai_obj):
    def __init__(self, id, hw_port=0, pvid=0):
        Sai_obj.__init__(self, id)
        self.hw_port = hw_port
        self.pvid = pvid


class VlanMember_obj(Sai_obj):
    def __init__(self, id, vid=0, bridge_id=0,vlan_oid=0):
        Sai_obj.__init__(self, id)
        self.vlan_oid = vlan_oid 
        self.vid = vid
        self.bridge_id = bridge_id


class Vlan_obj(Sai_obj):
    def __init__(self, id, vid=0, vlan_members=None):
        Sai_obj.__init__(self, id)
        self.vid = vid
        self.vlan_members = vlan_members


class BridgePort_obj(Sai_obj):
    def __init__(self, id):
        Sai_obj.__init__(self, id)


class Bridge_obj(Sai_obj):
    def __init__(self, id, bridge_type=0):
        Sai_obj.__init__(self, id)
        self.bridge_type = bridge_type


class SaiHandler():
  def __init__(self):
    self.switch_id = 0
    self.log = {}
    print "connecting to cli thrift"
    self.cli_client = SwitchThriftClient(json='../sai.json')
    self.hw_port_list = [0, 1, 2, 3, 4, 5, 6, 7]
    self.ports = {}
    self.vlans = {}
    self.vlan_members = {}
    self.bridge_ports = {}
    self.bridge_ids = {}


  def sai_thrift_create_switch(self, thrift_attr_list):
    return self.switch_id

  def sai_thrift_get_switch_attribute(self, thrift_attr_list):
    hw_port_list = sai_thrift_u32_list_t(u32list=self.hw_port_list, count=len(self.hw_port_list))
    for attr in thrift_attr_list:
      if attr.id == sai_switch_attr.SAI_SWITCH_ATTR_PORT_LIST:
        attr.value = sai_thrift_attribute_value_t(u32list=hw_port_list)
        new_attr = sai_thrift_attribute_t(id=attr.id, value=attr.value)
    new_attr_list = sai_thrift_attribute_list_t(attr_list = [new_attr], attr_count=1)
    return new_attr_list


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
    self.cli_client.RemoveTableEntry('table_fdb', match_str)
    return 0

  def sai_thrift_flush_fdb_entries(self, thrift_attr_list):
#    /**
 # * @brief Attribute for FDB flush API to specify the type of FDB entries being flushed.
 # *
 # * For example, if you want to flush all static entries, set #SAI_FDB_FLUSH_ATTR_ENTRY_TYPE
 # * = #SAI_FDB_FLUSH_ENTRY_TYPE_STATIC. If you want to flush both static and dynamic entries,
 # * then there is no need to specify the #SAI_FDB_FLUSH_ATTR_ENTRY_TYPE attribute.
 # * The API uses AND operation when multiple attributes are specified. For
 # * exmaple,
 # * 1) Flush all entries in fdb table - Do not specify any attribute
 # * 2) Flush all entries by port - Set #SAI_FDB_FLUSH_ATTR_PORT_ID
 # * 3) Flush all entries by VLAN - Set #SAI_FDB_FLUSH_ATTR_VLAN_ID
 # * 4) Flush all entries by port and VLAN - Set #SAI_FDB_FLUSH_ATTR_PORT_ID and
 # *    #SAI_FDB_FLUSH_ATTR_VLAN_ID
 # * 5) Flush all static entries by port and VLAN - Set #SAI_FDB_FLUSH_ATTR_ENTRY_TYPE,
 # *    #SAI_FDB_FLUSH_ATTR_PORT_ID, and #SAI_FDB_FLUSH_ATTR_VLAN_ID
 
    # sai_fdb_flush_attr.SAI_FDB_FLUSH_ATTR_PORT_ID,
    # sai_fdb_flush_attr.SAI_FDB_FLUSH_ATTR_VLAN_ID,
    # sai_fdb_flush_attr.SAI_FDB_FLUSH_ATTR_ENTRY_TYPE
    return 0

  def sai_thrift_create_vlan(self, thrift_attr_list):
    for attr in thrift_attr_list:
      if attr.id == sai_vlan_attr.SAI_VLAN_ATTR_VLAN_ID:
        vid = attr.value.u16
    if vid in [x.vid for x in self.vlans]:
      print "vlan id %d already exists" % vid
      return -1
    else:
      print "vlan id %d created" % vid
      vlan_oid, vlan_obj = CreateNewItem(self.vlans, Vlan_obj)
      vlan_obj.vid = vid
      vlan_obj.vlan_members = []
      return vlan_oid

  def sai_thrift_delete_vlan(self, vlan_oid):
    self.vlans.pop(vlan_oid, None)
    return 0

  def sai_thrift_remove_vlan_member(self, vlan_member_id):
    print "test1 %d" % vlan_member_id
    vlan_member = self.vlan_members[vlan_member_id]
    print "test2"
    bridge_id = vlan_member.bridge_id
    print "test3"
    vid = vlan_member.vid
    print "test4"
    self.cli_client.RemoveTableEntry('table_egress_vlan_filtering', list_to_str([bridge_id, vid, 0]))
    self.cli_client.RemoveTableEntry('table_egress_vlan_filtering', list_to_str([bridge_id, vid, 1]))
    print "test5"
    print self.vlans[vlan_member.vlan_oid].vlan_members
    self.vlans[vlan_member.vlan_oid].vlan_members.remove(vlan_member_id)
    print "test6"
    self.vlan_members.pop(vlan_member_id, None)
    print "test7"
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
    vlan_obj = self.vlans[vlan_oid]
    vlan_id = vlan_obj.vid
    vlan_member_id, vlan_member_obj = CreateNewItem(self.vlan_members, VlanMember_obj)
    vlan_member_obj.bridge_id = bridge_id
    vlan_member_obj.vid = vlan_id
    vlan_member_obj.vlan_oid = vlan_oid
    vlan_obj.vlan_members.append(vlan_member_id)

    self.cli_client.AddTable('table_ingress_vlan_filtering','_nop',list_to_str([bridge_id, vlan_id]),'')
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

    br_port, br_port_obj = CreateNewItem(self.bridge_ports, BridgePort_obj)
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
    print "test1 bridge_type = %d" % bridge_type
    bridge_id, bridge_obj = CreateNewItem(self.bridge_ids, Bridge_obj)
    print "test2 1"
    # bridge_obj.bridge_type = bridge_type
    print bridge_id
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
    port, port_obj = CreateNewItem(self.ports, Port_obj)
    port_obj.pvid = vlan_id
    port_obj.hw_port = hw_port
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