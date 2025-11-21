#!/bin/bash

# =================================================================
# CATATAN KONFIGURASI IP ADDRESS (IP PLAN) - KELOMPOK 2
# Topologi: Core-Edge OSPF & Firewall ACL
# =================================================================

# -----------------------------------------------------------------
# 1. JALUR BACKBONE (Router-to-Router)
# Subnet Mask: /30 (255.255.255.252)
# -----------------------------------------------------------------

EdgeRouter <-> CoreRouter (Network: 10.20.99.0)
Edge (f1/0) : 10.20.99.1
Core (f0/0) : 10.20.99.2

CoreRouter <-> RouterMahasiswa (Network: 10.20.99.4)
Core (f1/0) : 10.20.99.5
Mhs  (f0/0) : 10.20.99.6

CoreRouter <-> AkademikRouter (Network: 10.20.99.8)
Core (f1/1) : 10.20.99.9
Akad (f0/0) : 10.20.99.10

CoreRouter <-> ResearchRouter (Network: 10.20.99.12)
Core (f2/0) : 10.20.99.13
Riset(f0/0) : 10.20.99.14

CoreRouter <-> AdminRouter (Network: 10.20.99.16)
Core (f2/1) : 10.20.99.17
Admin(f0/0) : 10.20.99.18


# -----------------------------------------------------------------
# 2. JALUR LAN & GATEWAY (End Devices)
# Subnet Mask: /24 (255.255.255.0)
# DNS Server : 192.168.122.1
# -----------------------------------------------------------------

# ZONA EDGE & GUEST
Gateway (Edge f1/1) : 10.20.50.1
Client (Guest-1/2)  : DHCP

# ZONA MAHASISWA
Gateway (Mhs f1/0)  : 10.20.10.1
Client (PC-Mhs-1/2) : DHCP

# ZONA AKADEMIK
Gateway (Akad f1/0) : 10.20.20.1
Server (Database)   : 10.20.20.10 (STATIC)
Client (PC-Akad)    : DHCP

# ZONA RISET
Gateway (Riset f1/0): 10.20.30.1
Server (Web Riset)  : 10.20.30.10 (STATIC)
Client (PC-Riset)   : DHCP

# ZONA ADMIN
Gateway (Admin f1/0): 10.20.40.1
Server (Log/NMS)    : 10.20.40.10 (STATIC)
Client (PC-Admin)   : DHCP
