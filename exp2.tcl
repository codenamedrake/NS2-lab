set ns [new Simulator]

set tr [open exp2.tr w]
$ns trace-all $tr

set namtr [open exp2.nam w]
$ns namtrace-all $namtr

#Define different colors for data flows (for NAM)
$ns color 1 Blue
$ns color 2 Red

#Open the NAM trace file
set nf [open out.nam w]
$ns namtrace-all $nf

#Define a 'finish' procedure
proc finish {} {
        global ns nf
        $ns flush-trace
        #Close the NAM trace file
        close $nf
        #Execute NAM on the trace file
        exec nam out.nam &
        exit 0
}

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]

$ns duplex-link $n0 $n2 2mb 10ms DropTail
$ns duplex-link $n1 $n2 2mb 10ms DropTail
$ns duplex-link $n2 $n3 300kb 100ms DropTail
$ns duplex-link $n3 $n4 500kb 40ms DropTail
$ns duplex-link $n3 $n5 500kb 30ms DropTail

$ns duplex-link-op $n2 $n3 orient right
$ns duplex-link-op $n2 $n0 orient left-up
$ns duplex-link-op $n2 $n1 orient left-down
$ns duplex-link-op $n3 $n4 orient right-up
$ns duplex-link-op $n3 $n5 orient right-down


#Set Queue Size of link (n2-n3) to 10
#$ns queue-limit $n0 $n1 10

#Monitor the queue for link (n2-n3). (for NAM)
#$ns duplex-link-op $n0 $n1 queuePos 0.5

#Setup a TCP connection
set tcp [new Agent/TCP]
$tcp set class_ 2
$ns attach-agent $n0 $tcp
set sink [new Agent/TCPSink]
$ns attach-agent $n4 $sink
$ns connect $tcp $sink
$tcp set fid_ 1

#Setup a FTP over TCP connection
set ftp [new Application/FTP]
$ftp attach-agent $tcp
$ftp set type_ FTP
$ftp set packet_size_ 1000
$ftp set rate_ 2mb
$ftp set random_ false


#Setup a UDP connection
set udp [new Agent/UDP]
$ns attach-agent $n1 $udp
set null [new Agent/Null]
$ns attach-agent $n5 $null
$ns connect $udp $null
$udp set fid_ 2

#Setup a CBR over UDP connection
set cbr [new Application/Traffic/CBR]
$cbr attach-agent $udp
$cbr set type_ CBR
$cbr set packet_size_ 1000
$cbr set rate_ 100kb
$cbr set random_ false

#Schedule events for the CBR and FTP agents
$ns at 1.0 "$cbr start"
$ns at 0.1 "$ftp start"
$ns at 4.0 "$ftp stop"
$ns at 4.5 "$cbr stop"

#Detach tcp and sink agents (not really necessary)
#$ns at 4.5 "$ns detach-agent $n2 $tcp ; $ns detach-agent $n4 $sink"

#Call the finish procedure after 5 seconds of simulation time
$ns at 5.0 "finish"

#Print CBR packet size and interval
puts "CBR packet size = [$cbr set packet_size_]"
puts "CBR interval = [$cbr set interval_]"

#Run the simulation
$ns run


