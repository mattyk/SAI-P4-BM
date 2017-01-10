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
	  	uint32_t list[]={0,1,2,3,4,5,6,7};
  		switch_metatdata.hw_port_list.list=list;
  		switch_metatdata.hw_port_list.count=8;
  		port_api.create_port  = &create_port;
  		// create_port2 = &create_port;
    	transport->open();
    	cout << "BM connection started\n"; 
	  }
	~sai_object(){
	 	  //deconstructor
    	transport->close();
    	cout << "BM clients closed\n";
	 }

	sai_status_t sai_api_query(sai_api_t sai_api_id,void** api_method_table){
		switch (sai_api_id) {
              case SAI_API_PORT:
              *api_method_table=&port_api;
         }
		return SAI_STATUS_SUCCESS;
	}


	sai_status_t static create_port (sai_object_id_t *port_id, sai_object_id_t switch_id,uint32_t attr_count,const sai_attribute_t *attr_list){
		printf("bbb\n");
		*port_id = (sai_object_id_t) 1;
		return SAI_STATUS_SUCCESS;
	}
	sai_create_port_fn create_port2;
	sai_port_api_t port_api;
	StandardClient bm_client;
	boost::shared_ptr<TTransport> socket;
  	boost::shared_ptr<TTransport> transport;
  	boost::shared_ptr<TProtocol>  bprotocol;
  	boost::shared_ptr<TProtocol>  protocol;
	sai_id_map_t sai_id_map;
    switch_metatdata_t switch_metatdata;  // TODO expand to array for multiple switch support
};






