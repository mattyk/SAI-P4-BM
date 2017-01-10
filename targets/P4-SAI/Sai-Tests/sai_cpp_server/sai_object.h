#include <iostream>

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

// thrift bm clinet
#include "../../../../thrift_src/gen-cpp/bm/Standard.h"
#include <thrift/protocol/TBinaryProtocol.h>
#include <thrift/protocol/TMultiplexedProtocol.h>
#include <thrift/transport/TBufferTransports.h>
#include <thrift/transport/TSocket.h>

using namespace std;
using namespace ::apache::thrift;
using namespace ::apache::thrift::protocol;
using namespace ::apache::thrift::transport;

using boost::shared_ptr;
using namespace bm_runtime::standard;
//using namespace  ::switch_sai;


const int32_t cxt_id =0;
const int bm_port = 9090;

class sai_object {
public:
	sai_object():  //constructor pre initializations
	  socket(new TSocket("localhost", bm_port)),
	  transport(new TBufferedTransport(socket)),
	  bprotocol(new TBinaryProtocol(transport)),
	  protocol (new TMultiplexedProtocol(bprotocol, "standard")),
	  bm_client(protocol)
	  {
    	transport->open();
    	cout << "BM connection started\n"; 
	  }
	~sai_object(){
	 	  //deconstructor
    	transport->close();
    	cout << "BM clients closed\n";
	 }
	StandardClient bm_client;
	boost::shared_ptr<TTransport> socket;
  	boost::shared_ptr<TTransport> transport;
  	boost::shared_ptr<TProtocol>  bprotocol;
  	boost::shared_ptr<TProtocol>  protocol;
	sai_id_map_t sai_id_map;
    switch_metatdata_t switch_metatdata;  // TODO expand to array for multiple switch support
  	
};
