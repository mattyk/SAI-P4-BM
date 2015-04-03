#include <iostream>
#include <memory>
#include <thread>
#include <fstream>

#include "bm_sim/queue.h"
#include "bm_sim/packet.h"
#include "bm_sim/parser.h"
#include "bm_sim/P4Objects.h"
#include "bm_sim/tables.h"
#include "bm_sim/switch.h"
#include "bm_sim/event_logger.h"

#include "simple_router.h"
#include "primitives.h"
#include "simplelog.h"

#include "bm_runtime/bm_runtime.h"

class SimpleSwitch : public Switch {
public:
  SimpleSwitch(transmit_fn_t transmit_fn)
    : input_buffer(1024), output_buffer(128), transmit_fn(transmit_fn) {}

  int receive(int port_num, const char *buffer, int len) {
    static int pkt_id = 0;

    Packet *packet =
      new Packet(port_num, pkt_id++, 0, PacketBuffer(2048, buffer, len));

    ELOGGER->packet_in(*packet);

    input_buffer.push_front(std::unique_ptr<Packet>(packet));
    return 0;
  }

  void start_and_return() {
    std::thread t1(&SimpleSwitch::pipeline_thread, this);
    t1.detach();
    std::thread t2(&SimpleSwitch::transmit_thread, this);
    t2.detach();
  }

private:
  void pipeline_thread();
  void transmit_thread();

private:
  Queue<unique_ptr<Packet> > input_buffer;
  Queue<unique_ptr<Packet> > output_buffer;
  transmit_fn_t transmit_fn;
};

void SimpleSwitch::transmit_thread() {
  while(1) {
    unique_ptr<Packet> packet;
    output_buffer.pop_back(&packet);
    ELOGGER->packet_out(*packet);
    SIMPLELOG << "transmitting packet " << packet->get_packet_id() << std::endl;
    transmit_fn(packet->get_egress_port(), packet->data(), packet->get_data_size());
  }
}

void SimpleSwitch::pipeline_thread() {
  Pipeline *ingress_mau = p4objects->get_pipeline("ingress");
  Pipeline *egress_mau = p4objects->get_pipeline("egress");
  Parser *parser = p4objects->get_parser("parser");
  Deparser *deparser = p4objects->get_deparser("deparser");
  PHV &phv = p4objects->get_phv();

  while(1) {
    unique_ptr<Packet> packet;
    input_buffer.pop_back(&packet);
    SIMPLELOG << "processing packet " << packet->get_packet_id() << std::endl;
    
    parser->parse(packet.get(), &phv);
    ingress_mau->apply(*packet.get(), &phv);

    int egress_port = phv.get_field("standard_metadata.egress_port").get_int();
    SIMPLELOG << "egress port is " << egress_port << std::endl;    

    if(egress_port == 0) {
      SIMPLELOG << "dropping packet\n";
    }
    else {
      packet->set_egress_port(egress_port);
      egress_mau->apply(*packet.get(), &phv);
      deparser->deparse(&phv, packet.get());
      output_buffer.push_front(std::move(packet));
    }
  }
}

/* Switch instance */

static SimpleSwitch *simple_switch;


int packet_accept(int port_num, const char *buffer, int len) {
  return simple_switch->receive(port_num, buffer, len);
}

void start_processing(transmit_fn_t transmit_fn) {
  simple_switch = new SimpleSwitch(transmit_fn);
  simple_switch->init_objects("simple_router.json");

  bm_runtime::start_server(simple_switch, 9090);

  // add_test_entry();

  simple_switch->start_and_return();
}
