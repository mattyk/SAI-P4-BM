sudo ./ptf/ptf --test-dir wip_tests/ --pypath sai_thrift_src/gen-py --interface 0@veth1 --interface 1@veth3 --interface 2@veth5 \
    	 --interface 3@veth7 --interface 4@veth9 --interface 5@veth11 --interface 6@veth13 --interface 7@veth15  \
    	 sail3_new.L3IPv4SubPortRif2SubPortRif
    	 