# 默认 bridge, lxcbr0，威联通 lxc 和 docker 应用网络
docker network create -d bridge --ipam-driver=default \
    --subnet=10.0.3.0/24 --gateway=10.0.3.1 \
    --opt="com.docker.network.bridge.default_bridge=true"
    --opt="com.docker.network.bridge.enable_icc=true"
    --opt="com.docker.network.bridge.enable_ip_masquerade=true" 
    --opt="com.docker.network.bridge.host_binding_ipv4=0.0.0.0" 
    --opt="com.docker.network.bridge.name=lxcbr0" 
    --opt="com.docker.network.driver.mtu=1500" 
    bridge

# docker0, 威联通内置 docker 应用网络 
docker network create -d bridge --ipam-driver=default \
    --subnet=10.0.5.0/24 --gateway=10.0.5.1 \
    --opt="com.docker.network.bridge.default_bridge=true" 
    --opt="com.docker.network.bridge.enable_icc=true" 
    --opt="com.docker.network.bridge.enable_ip_masquerade=true" 
    --opt="com.docker.network.bridge.host_binding_ipv4=0.0.0.0" 
    --opt="com.docker.network.bridge.name=docker0" 
    --opt="com.docker.network.driver.mtu=1500" 
    docker0

# lxdbr0，威联通 lxd 应用网络
docker network create -d bridge --ipam-driver=default \
    --subnet=10.0.7.0/24 --gateway=10.0.7.1 \
    --opt="com.docker.network.bridge.default_bridge=true" 
    --opt="com.docker.network.bridge.enable_icc=true" 
    --opt="com.docker.network.bridge.enable_ip_masquerade=true" 
    --opt="com.docker.network.bridge.host_binding_ipv4=0.0.0.0" 
    --opt="com.docker.network.bridge.name=lxdbr0" 
    --opt="com.docker.network.driver.mtu=1500" 
    lxdbr0

# traefik
docker network create -d bridge --ipam-driver=default \
    --subnet=10.0.3.0/24 --gateway=10.0.3.1 \
    --opt="com.docker.network.bridge.default_bridge=true" \
    --opt="com.docker.network.bridge.enable_icc=true" \
    --opt="com.docker.network.bridge.enable_ip_masquerade=true" \
    --opt="com.docker.network.bridge.host_binding_ipv4=0.0.0.0" \
    --opt="com.docker.network.bridge.name=lxcbr0" \
    --opt="com.docker.network.driver.mtu=1500" \
    traefik

# dhcp
docker network create -d qnet --ipam-driver=qnet --ipam-opt=iface=eth0 \
    qnet-dhcp-eth0

# static
docker network create -d qnet --ipam-driver=qnet --ipam-opt=iface=eth0 \
    --subnet=192.168.68.0/23 --gateway=192.168.68.254 \
    qnet-static-eth0

# static 链路聚合
docker network create -d qnet --ipam-driver=qnet --ipam-opt=iface=bond0 \
    --subnet 192.168.68.0/23 --gateway 192.168.68.254 \
    qnet-static-bond0