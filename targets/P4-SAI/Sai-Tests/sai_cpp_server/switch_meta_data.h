#ifndef SWITCH_MAETA_DATA_H
#define SWITCH_MAETA_DATA_H

#include  <sai.h>
#include <list>


typedef std::map<sai_object_id_t, bool>            sai_id_map_t;


sai_object_id_t get_first_free_id(sai_id_map_t sai_id_map){
  sai_object_id_t i = 0;
  for (auto it = sai_id_map.cbegin(), end = sai_id_map.cend();
                           it != end && i == it->first; ++it, ++i)
  { 
    sai_id_map[i]=true;
    
  }
  return i;
}

class Sai_obj {
  public:
    sai_object_id_t sai_object_id;
    Sai_obj(sai_id_map_t sai_id_map){
      sai_object_id = get_first_free_id(sai_id_map); // sai_id_map. set map to true.
    }
  
};


class Port_obj : public Sai_obj{
  public:
    int hw_port;
    int pvid;
    Port_obj(sai_id_map_t id_map,int hw_port, int pvid) : Sai_obj(id_map) {
      this->hw_port=hw_port;
      this->pvid=pvid;
    }
    Port_obj(sai_id_map_t id_map): Sai_obj(id_map) {
      this->hw_port=0;
      this->pvid=1;
    }
};

class BridgePort_obj : public Sai_obj {
public:
  sai_object_id_t port_id;
  sai_object_id_t vlan_id;
  sai_port_type_t br_port_type;
  BridgePort_obj(sai_id_map_t id_map,sai_object_id_t port_id,sai_object_id_t vlan_id, sai_port_type_t br_port_type) : Sai_obj(id_map) {
    this->port_id=port_id;
    this->vlan_id=vlan_id;
    this->br_port_type=br_port_type;
  }
  BridgePort_obj(sai_id_map_t id_map) : Sai_obj(id_map) {
    this->port_id=0;
    this->vlan_id=1;
    this->br_port_type=SAI_PORT_TYPE_LOGICAL;
  }
};

class Bridge_obj : public Sai_obj {
public:
  sai_bridge_type_t bridge_type;
  Bridge_obj(sai_id_map_t id_map,sai_bridge_type_t bridge_type) : Sai_obj(id_map) {
    this->bridge_type=bridge_type;
  }
};



typedef std::map<sai_object_id_t, BridgePort_obj*>  bridge_port_id_map_t;
typedef std::map<sai_object_id_t, Port_obj*>        port_id_map_t;
typedef std::map<sai_object_id_t, Bridge_obj*>      bridge_id_map_t;


struct switch_metatdata_t{
public:
  //sai_id_map_t sai_id_map; // TODO should come from higher hirarchy (for multiple switch config)
  Sai_obj switch_id(sai_id_map_t sai_id_map);
  int hw_port_list [8] ={0,1,2,3,4,5,6,7};
  port_id_map_t ports;
  bridge_port_id_map_t bridge_ports;
  bridge_id_map_t bridges;
};


#endif
//
//
