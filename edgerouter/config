firewall {
    all-ping enable
    broadcast-ping disable
    group {
        network-group DMZ {
            description "Public VLAN"
            network 10.40.0.0/24
        }
        network-group INTER_VLAN {
            description "Traffic between VLANs"
            network 10.20.0.0/24
            network 10.40.0.0/24
            network 10.10.0.0/24
            network 10.50.0.0/24
            network 10.30.0.0/24
        }
        network-group LAN_Networks {
            description "Internal VLANs"
            network 10.10.0.0/24
            network 10.20.0.0/24
            network 10.50.0.0/24
        }
        network-group Private_Networks {
            description "Private Home Subnets"
            network 10.30.0.0/24
        }
    }
    ipv6-receive-redirects disable
    ipv6-src-route disable
    ip-src-route disable
    log-martians enable
    modify PBR {
        rule 10 {
            action modify
            description inter-vlan
            destination {
                group {
                    network-group INTER_VLAN
                }
            }
            modify {
                table main
            }
        }
        rule 20 {
            action modify
            description vlan40
            modify {
                table 11
            }
            source {
                address 10.40.0.0/24
            }
        }
        rule 30 {
            action modify
            description vlan20
            modify {
                table 10
            }
            source {
                address 10.20.0.0/24
            }
        }
    }
    name DMZ_IN {
        default-action accept
        description ""
        enable-default-log
        rule 10 {
            action accept
            description "Accept Established/Related"
            log disable
            protocol all
            state {
                established enable
                invalid disable
                new disable
                related enable
            }
        }
        rule 20 {
            action drop
            description "Drop LAN_NETWORKS"
            destination {
                group {
                    network-group LAN_Networks
                }
            }
            log enable
            protocol all
        }
    }
    name DMZ_LOCAL {
        default-action drop
        description ""
        rule 1 {
            action accept
            description "allow DNS"
            destination {
                port 53
            }
            log disable
            protocol tcp_udp
        }
        rule 2 {
            action accept
            description "allow DHCP"
            destination {
                port 67
            }
            log disable
            protocol udp
        }
    }
    name PROTECT_IN {
        default-action drop
        description ""
        rule 1 {
            action accept
            description "Accept Established/Related"
            log disable
            protocol all
            state {
                established enable
                invalid disable
                new disable
                related enable
            }
        }
        rule 2 {
            action drop
            description "Drop LAN_NETWORKS"
            log disable
            protocol all
        }
    }
    name PROTECT_LOCAL {
        default-action drop
        description ""
        rule 1 {
            action accept
            description "Accept DNS"
            destination {
                port 53
            }
            log disable
            protocol udp
        }
        rule 2 {
            action accept
            description "Accept DHCP"
            destination {
                port 67
            }
            log disable
            protocol udp
        }
    }
    name WAN_IN {
        default-action drop
        description "WAN to internal"
        rule 10 {
            action accept
            description "Allow established/related"
            state {
                established enable
                related enable
            }
        }
        rule 20 {
            action drop
            description "Drop invalid state"
            state {
                invalid enable
            }
        }
    }
    name WAN_IN_2 {
        default-action drop
        description "WAN to internal"
        rule 10 {
            action accept
            description "Allow established/related"
            state {
                established enable
                related enable
            }
        }
        rule 20 {
            action accept
            description "Allow HTTP"
            destination {
                port 80
            }
            log disable
            protocol tcp
        }
        rule 30 {
            action accept
            description "Allow HTTPS"
            destination {
                port 443
            }
            log disable
            protocol tcp
        }
        rule 40 {
            action drop
            description "Drop invalid state"
            state {
                invalid enable
            }
        }
    }
    name WAN_LOCAL {
        default-action drop
        description "WAN to router"
        rule 10 {
            action accept
            description "Allow established/related"
            state {
                established enable
                related enable
            }
        }
        rule 20 {
            action drop
            description "Drop invalid state"
            state {
                invalid enable
            }
        }
    }
    name WAN_LOCAL_2 {
        default-action drop
        description "WAN to router"
        rule 10 {
            action accept
            description "Allow established/related"
            state {
                established enable
                related enable
            }
        }
        rule 20 {
            action drop
            description "Drop invalid state"
            state {
                invalid enable
            }
        }
    }
    options {
        mss-clamp {
            mss 1412
        }
    }
    receive-redirects disable
    send-redirects enable
    source-validation disable
    syn-cookies enable
}
interfaces {
    ethernet eth0 {
        address 10.30.0.2/24
        description "Private home network (downstream)"
        duplex auto
        firewall {
            in {
                name PROTECT_IN
            }
            local {
                name PROTECT_LOCAL
            }
        }
        pppoe 0 {
            default-route none
            firewall {
                in {
                    name WAN_IN
                }
                local {
                    name WAN_LOCAL
                }
            }
            mtu 1492
            name-server auto
            password <password>
            user-id <user-id>
        }
        pppoe 1 {
            default-route none
            firewall {
                in {
                    name WAN_IN_2
                }
                local {
                    name WAN_LOCAL_2
                }
            }
            mtu 1492
            name-server auto
            password <password>
            user-id <user-id>
        }
        speed auto
    }
    ethernet eth1 {
        duplex auto
        speed auto
        vif 10 {
            address 10.10.0.1/24
            description "Infrastructure maintenance network"
            mtu 1500
        }
        vif 20 {
            address 10.20.0.1/24
            description "Private development network"
            firewall {
                in {
                    modify PBR
                }
            }
        }
        vif 30 {
            description "Private home network (upstream)"
        }
        vif 40 {
            address 10.40.0.1/24
            description "Public network (DMZ)"
            firewall {
                in {
                    modify PBR
                    name DMZ_IN
                }
                local {
                    name DMZ_LOCAL
                }
            }
        }
        vif 50 {
            description "VPN network"
        }
    }
    ethernet eth2 {
        disable
        duplex auto
        firewall {
            in {
            }
        }
        speed auto
    }
    loopback lo {
    }
}
port-forward {
    auto-firewall enable
    hairpin-nat enable
    lan-interface eth1.20
    rule 1 {
        description HTTP
        forward-to {
            address 10.20.0.8
            port 8080
        }
        original-port 80
        protocol tcp_udp
    }
    rule 2 {
        description HTTPS
        forward-to {
            address 10.20.0.8
            port 443
        }
        original-port 443
        protocol tcp_udp
    }
    rule 3 {
        description "OpenVPN Server"
        forward-to {
            address 10.20.0.8
            port 1194
        }
        original-port 1194
        protocol udp
    }
    rule 4 {
        description "Plex Server"
        forward-to {
            address 10.20.0.8
            port 32400
        }
        original-port 32400
        protocol tcp_udp
    }
    rule 5 {
        description Transmission
        forward-to {
            address 10.20.0.8
            port 51413
        }
        original-port 51413
        protocol tcp_udp
    }
    rule 6 {
        description "Minecraft Server"
        forward-to {
            address 10.20.0.8
            port 25565
        }
        original-port 25565
        protocol tcp
    }
    rule 7 {
        description "Factorio Server"
        forward-to {
            address 10.20.0.8
            port 34197
        }
        original-port 34197
        protocol tcp_udp
    }
    wan-interface pppoe0
}
protocols {
    static {
        interface-route 0.0.0.0/0 {
            next-hop-interface pppoe0 {
                description WAN
            }
            next-hop-interface pppoe1 {
                description DMZ
            }
        }
        table 10 {
            interface-route 0.0.0.0/0 {
                next-hop-interface pppoe0 {
                }
            }
        }
        table 11 {
            interface-route 0.0.0.0/0 {
                next-hop-interface pppoe1 {
                }
            }
        }
    }
}
service {
    dhcp-server {
        disabled false
        hostfile-update disable
        shared-network-name Infrastructure-maintenance {
            authoritative disable
            subnet 10.10.0.0/24 {
                default-router 10.10.0.1
                dns-server 1.1.1.1
                dns-server 8.8.8.8
                lease 86400
                start 10.10.0.10 {
                    stop 10.10.0.254
                }
                unifi-controller 10.10.0.2
            }
        }
        shared-network-name dmz {
            authoritative disable
            subnet 10.40.0.0/24 {
                default-router 10.40.0.1
                dns-server 1.1.1.1
                dns-server 8.8.8.8
                lease 86400
                start 10.40.0.200 {
                    stop 10.40.0.254
                }
                static-mapping pi-cluster-node01 {
                    ip-address 10.40.0.11
                    mac-address dc:a6:32:6a:f8:d7
                }
                static-mapping pi-cluster-node02 {
                    ip-address 10.40.0.12
                    mac-address dc:a6:32:6a:fb:50
                }
                static-mapping pi-cluster-node03 {
                    ip-address 10.40.0.13
                    mac-address dc:a6:32:6b:18:39
                }
            }
        }
        shared-network-name private-home-network {
            authoritative disable
            subnet 10.20.0.0/24 {
                default-router 10.20.0.1
                dns-server 10.20.0.5
                dns-server 1.1.1.1
                domain-name wouterstemgee.be
                lease 86400
                start 10.20.0.11 {
                    stop 10.20.0.254
                }
                static-mapping {}
                unifi-controller 10.20.0.2
            }
        }
        static-arp disable
        use-dnsmasq disable
    }
    dns {
        forwarding {
            cache-size 150
            listen-on eth1.20
            listen-on pppoe0
            listen-on pppoe1
        }
    }
    gui {
        http-port 80
        https-port 443
        older-ciphers enable
    }
    nat {
        rule 1 {
            description INGRESS_HTTP
            destination {
                port 80
            }
            inbound-interface pppoe1
            inside-address {
                address 10.40.0.50
                port 80
            }
            log disable
            protocol tcp
            type destination
        }
        rule 2 {
            description INGRESS_HTTPS
            destination {
                port 443
            }
            inbound-interface pppoe1
            inside-address {
                address 10.40.0.50
                port 443
            }
            log disable
            protocol tcp
            type destination
        }
        rule 5000 {
            destination {
                group {
                    network-group DMZ
                }
            }
            log enable
            outbound-interface eth1.40
            protocol all
            source {
                group {
                    network-group LAN_Networks
                }
            }
            type masquerade
        }
        rule 5001 {
            destination {
                group {
                    network-group Private_Networks
                }
            }
            log enable
            outbound-interface eth0
            protocol all
            source {
                group {
                    network-group LAN_Networks
                }
            }
            type masquerade
        }
        rule 5002 {
            description "masquerade for WAN"
            log enable
            outbound-interface pppoe0
            protocol all
            source {
                group {
                    network-group LAN_Networks
                }
            }
            type masquerade
        }
        rule 5003 {
            description "masquerade for WAN"
            log enable
            outbound-interface pppoe1
            protocol all
            source {
                group {
                    network-group DMZ
                }
            }
            type masquerade
        }
    }
    ssh {
        port 22
        protocol-version v2
    }
    ubnt-discover {
        disable
    }
    unms {
        connection <wss://>
    }
    upnp {
        listen-on eth1 {
            outbound-interface pppoe0
        }
    }
}
system {
    analytics-handler {
        send-analytics-report false
    }
    crash-handler {
        send-crash-report false
    }
    domain-name wouterstemgee.be
    host-name ostiarius
    login {
        user wouter {
            authentication {
                encrypted-password <encrypted-password>
                plaintext-password <plaintext-password>
            }
            full-name "Wouter Stemgée"
            level admin
        }
    }
    name-server 1.1.1.1
    name-server 8.8.8.8
    ntp {
        server 0.ubnt.pool.ntp.org {
        }
        server 1.ubnt.pool.ntp.org {
        }
        server 2.ubnt.pool.ntp.org {
        }
        server 3.ubnt.pool.ntp.org {
        }
    }
    offload {
        hwnat disable
        ipv4 {
            forwarding disable
            pppoe disable
        }
    }
    syslog {
        global {
            facility all {
                level notice
            }
            facility protocols {
                level debug
            }
        }
    }
    time-zone Europe/Brussels
    traffic-analysis {
        dpi disable
        export disable
    }
}