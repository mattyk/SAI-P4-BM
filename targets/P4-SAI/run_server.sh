set -m
rm -rf log.txt
sudo -v
sudo ./simple_switch -i 0@veth0 -i 1@veth2 -i 2@veth4 -i 3@veth6 -i 4@veth8 -i 5@veth10 -i 6@veth12 -i 7@veth14 --log-file log --log-flush sai.json &
sleep 1
./runtime_CLI < p4src/DefaultConfig.txt
fg