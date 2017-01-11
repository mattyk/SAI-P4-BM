# Copyright 2013-present Barefoot Networks, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

"""
Thrift SAI interface L3 tests
"""
import socket
import sys
from struct import pack, unpack

from switch import *

import sai_base_test
from ptf.mask import Mask

@group('l3')
class L3IPv4SubPortRif2SubPortRif(sai_base_test.ThriftInterfaceDataPlane):
    def runTest(self):
        print "Sending packet port 0 -> port 1 (192.168.0.1 -> 10.10.10.1 [id = 101])"
        v4_enabled = 1
        v6_enabled = 0
        router_mac = '00:11:22:33:44:55'
        mac1 = '00:12:23:34:45:56'
        vid = 21
        ip_addr1 = '10.10.10.1'
        ip_addr1_subnet = '10.10.10.0'
        ip_mask1 = '255.255.255.0'
        dmac1 = '00:11:22:33:44:55'

        # Get HW ports
        attr_list = [sai_thrift_attribute_t(id=sai_switch_attr.SAI_SWITCH_ATTR_PORT_LIST)]
        attr_list = self.client.sai_thrift_get_switch_attribute(attr_list)
        for attr in attr_list.attr_list:
            if attr.id == sai_switch_attr.SAI_SWITCH_ATTR_PORT_LIST:
                hw_port_list = attr.value.u32list.u32list
            # sai_switch_attr.SAI_SWITCH_ATTR_PORT_NUMBER
        hw_port1 = hw_port_list[0]
        hw_port2 = hw_port_list[1]

        # Create Ports
        bind_mode = sai_port_bind_mode.SAI_PORT_BIND_MODE_SUB_PORT
        port1 = sai_thrift_create_port(self.client, bind_mode, hw_port1, vid)
        port2 = sai_thrift_create_port(self.client, bind_mode, hw_port2, vid)

        # Create Router entries
        vr_id = sai_thrift_create_virtual_router(self.client, v4_enabled, v6_enabled)

        # Create RIFs
        rif_type = sai_router_interface_type.SAI_ROUTER_INTERFACE_TYPE_SUB_PORT
        rif_id1 = sai_thrift_create_router_interface(self.client, vr_id, rif_type, port1, vid, v4_enabled, v6_enabled, router_mac)
        rif_id2 = sai_thrift_create_router_interface(self.client, vr_id, rif_type, port2, vid, v4_enabled, v6_enabled, router_mac)
        print "vr_id %d ,rif1 %d, rif2 %d" % (vr_id, rif_id1, rif_id2)
        # Create next hop and route
        addr_family = sai_ip_addr_family_t.SAI_IP_ADDR_FAMILY_IPV4
        nhop_type = sai_next_hop_type.SAI_NEXT_HOP_TYPE_IP
        nhop1 = sai_thrift_create_nhop(self.client, nhop_type, addr_family, ip_addr1, rif_id1)
        sai_thrift_create_route(self.client, vr_id, addr_family, ip_addr1_subnet, ip_mask1, rif_id1)

        # send the test packet(s)
        pkt = simple_tcp_packet(eth_dst=router_mac,
                                eth_src='00:22:22:22:22:22',
                                ip_dst='10.10.10.1',
                                ip_src='192.168.0.1',
                                ip_id=105,
                                ip_ttl=64)
        exp_pkt = simple_tcp_packet(
                                eth_dst='00:11:22:33:44:55',
                                eth_src=router_mac,
                                ip_dst='10.10.10.1',
                                ip_src='192.168.0.1',
                                ip_id=105,
                                ip_ttl=63)
        try:
            send_packet(self, 1, str(pkt))
            verify_packets(self, exp_pkt, [0])
        finally:
            sai_thrift_remove_route(self.client, vr_id, addr_family, ip_addr1_subnet, ip_mask1, rif_id1)
            self.client.sai_thrift_remove_next_hop(nhop1)
            sai_thrift_remove_neighbor(self.client, addr_family, rif_id1, ip_addr1, dmac1)

            self.client.sai_thrift_remove_router_interface(rif_id1)
            self.client.sai_thrift_remove_router_interface(rif_id2)

            self.client.sai_thrift_remove_virtual_router(vr_id)