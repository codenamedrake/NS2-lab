# Fixing the co-ordinate
set val(x) 100 ;
set val(y) 100 ;

set val(stop) 10 ;

# Define options
set val(chan)           Channel/WirelessChannel    ;# channel type
set val(prop)           Propagation/TwoRayGround   ;# radio-propagation model
set val(netif)          Phy/WirelessPhy            ;# network interface type
set val(mac)            Mac/802_11                 ;# MAC type
set val(ifq)            Queue/DropTail/PriQueue    ;# interface queue type
set val(ll)             LL                         ;# link layer type
set val(ant)            Antenna/OmniAntenna        ;# antenna model
set val(ifqlen)         50                         ;# max packet in ifq
set val(nn)             10                          ;# number of mobilenodes
set val(rp)             AODV                       ;# routing protocol

#-------Event scheduler object creation--------#

set ns              [new Simulator]

# set up topography object
set topo       [new Topography]
$topo load_flatgrid $val(x) $val(y)

#creating trace file and nam file
set tracefd       [open graph.tr w]
$ns use-newtrace
$ns trace-all $tracefd

set namtrace      [open graph.nam w]   
$ns use-newtrace
$ns namtrace-all-wireless $namtrace $val(x) $val(y)

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
                   
      for {set i 0} {$i < $val(nn) } { incr i } {
            set node_($i) [$ns node]     
      }

# Provide initial location of mobilenodes
for {set i 0} {$i < $val(nn) } { incr i } {
        $node_($i) set X_ [ expr { $val(x) * rand() } ]
	$node_($i) set Y_ [ expr { $val(y) * rand() } ]
	$node_($i) set Z_ 0.0    
      }

#Setup a UDP connection
for {set i 1} {$i < $val(nn) } { incr i } {
set udp($i) [new Agent/UDP] 
      }

for {set i 1} {$i < $val(nn) } { incr i } {
$ns attach-agent $node_($i) $udp($i) 
      }

set null [new Agent/Null]
$ns attach-agent $node_(0) $null
for {set i 1} {$i < $val(nn) } { incr i } {
$ns connect $udp($i) $null    
      }

#$udp set fid_ 2

#Setup a CBR over UDP connection
for {set i 1} {$i < $val(nn) } { incr i } {
set cbr($i) [new Application/Traffic/CBR]  
      }
for {set i 1} {$i < $val(nn) } { incr i } {
$cbr($i) attach-agent $udp($i)
$cbr($i) set type_ CBR
$cbr($i) set packet_size_ 512
$cbr($i) set rate_ 180kb
$cbr($i) set random_ false   
$ns at 0.5 "$cbr($i) start"
$ns at 5.0 "$cbr($i) stop" 
 
 }



# Define node initial position in nam
for {set i 0} {$i < $val(nn)} { incr i } {
# 30 defines the node size for nam
$ns initial_node_pos $node_($i) 10
}

# Telling nodes when the simulation ends
for {set i 0} {$i < $val(nn) } { incr i } {
    $ns at $val(stop) "$node_($i) reset";
}

# ending nam and the simulation
$ns at $val(stop) "$ns nam-end-wireless $val(stop)"
#$ns at $val(stop) "stop"
$ns at 10.01 "puts \"end simulation\" ; $ns halt"


$ns run

