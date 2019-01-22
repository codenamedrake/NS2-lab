



# Simulator Instance Creation
set ns [new Simulator]

#Fixing the co-ordinate of simutaion area
set val(x) 500
set val(y) 500
# Define options
set val(chan) Channel/WirelessChannel ;# channel type
set val(prop) Propagation/TwoRayGround ;# radio-propagation model

set val(netif) Phy/WirelessPhy ;# network interface type
set val(mac) Mac/802_11 ;# MAC type
set val(ifq) Queue/DropTail/PriQueue ;# interface queue type
set val(ll) LL ;# link layer type
set val(ant) Antenna/OmniAntenna ;# antenna model
set val(ifqlen) 50 ;# max packet in ifq
set val(nn) 10 ;# number of mobilenodes
set val(rp) DSR ;# routing protocol
set val(x) 500 ;# X dimension of topography
set val(y) 500 ;# Y dimension of topography
set val(stop) 10.0 ;# time of simulation end

# set up topography object
set topo [new Topography]
$topo load_flatgrid $val(x) $val(y)

#Nam File Creation nam – network animator
set namfile [open dsr.nam w]

#Tracing all the events and cofiguration
$ns namtrace-all-wireless $namfile $val(x) $val(y)

#Trace File creation
set tracefile [open dsr.tr w]

#Tracing all the events and cofiguration
$ns trace-all $tracefile

# general operational descriptor- storing the hop details in the network
create-god $val(nn)

# configure the nodes
$ns node-config -adhocRouting $val(rp) \
-llType $val(ll) \
-macType $val(mac) \
-ifqType $val(ifq) \
-ifqLen $val(ifqlen) \
-antType $val(ant) \
-propType $val(prop) \
-phyType $val(netif) \
-channelType $val(chan) \
-topoInstance $topo \
-agentTrace ON \
-routerTrace ON \
-macTrace OFF \
-movementTrace ON

# Node Creation
set node0 [$ns node]
$node0 color blue
$node0 set X_ 100
$node0 set Y_ 100
$node0 set Z_ 0

set node1 [$ns node]
$node1 color black
$node1 set X_ 100
$node1 set Y_ 200
$node1 set Z_ 0

set node2 [$ns node]
$node2 color black
$node2 set X_ 100
$node2 set Y_ 300
$node2 set Z_ 0

set node3 [$ns node]
$node3 color black
$node3 set X_ 100
$node3 set Y_ 400
$node3 set Z_ 0

set node4 [$ns node]
$node4 color black
$node4 set X_ 200
$node4 set Y_ 100
$node4 set Z_ 0

set node5 [$ns node]
$node5 color black
$node5 set X_ 200
$node5 set Y_ 200
$node5 set Z_ 0

set node6 [$ns node]
$node6 color black
$node6 set X_ 200
$node6 set Y_ 300
$node6 set Z_ 0

set node7 [$ns node]
$node7 color black
$node7 set X_ 200
$node7 set Y_ 400
$node7 set Z_ 0

set node8 [$ns node]
$node8 color black
$node8 set X_ 300
$node8 set Y_ 200
$node8 set Z_ 0

set node9 [$ns node]
$node9 color black
$node9 set X_ 300
$node9 set Y_ 300
$node9 set Z_ 0
# Label and coloring
#$ns at 0.1 "$node1 color blue"
#$ns at 0.1 "$node1 label Node1"
#$ns at 0.1 "$node2 label Node2"
#Size of the node
$ns initial_node_pos $node0 30
$ns initial_node_pos $node1 30
$ns initial_node_pos $node2 30
$ns initial_node_pos $node3 30
$ns initial_node_pos $node4 30
$ns initial_node_pos $node5 30
$ns initial_node_pos $node6 30
$ns initial_node_pos $node7 30
$ns initial_node_pos $node8 30
$ns initial_node_pos $node9 30

set tcp [new Agent/TCP]
$tcp set class_ 2
set sink [new Agent/TCPSink]
$ns attach-agent $node0 $tcp
$ns attach-agent $node9 $sink
$tcp set fid_ 1
$ns connect $tcp $sink
set ftp [new Application/FTP]
$ftp attach-agent $tcp
$ftp set type_ FTP

$ns at 1.0 "$ftp start"
$ns at 6.0 "$ftp stop"  
# ending nam and the simulation
#$ns at $val(stop) "$ns nam-end-wireless $val(stop)"
#$ns at $val(stop) "stop"

#Stopping the scheduler
$ns at 10.01 "$ns halt"
#$ns at 10.01 "$ns halt"


#Starting scheduler
$ns run

