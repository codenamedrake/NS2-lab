set ns [new Simulator]

#Define different colors for data flows (for NAM)
$ns color 1 Blue
$ns color 2 Red

#Open the Trace file
set file1 [open out.tr w]
$ns trace-all $file1

#Open the NAM trace file
set file2 [open out.nam w]
$ns namtrace-all $file2

#Define a 'finish' procedure
proc finish {} {
        global ns file1 file2
        $ns flush-trace
        close $file1
        close $file2
        exec nam out.nam &
        exit 0
}

# Next line should be commented out to have the static routing
$ns rtproto DV

#Create six nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]


#Create links between the nodes
$ns duplex-link $n0 $n1 0.5Mb 50ms DropTail
$ns duplex-link $n0 $n2 0.5Mb 50ms DropTail
$ns duplex-link $n0 $n3 0.5Mb 50ms DropTail
$ns duplex-link $n0 $n4 0.5Mb 50ms DropTail
$ns duplex-link $n3 $n4 0.5Mb 50ms DropTail

#Give node position (for NAM)
$ns duplex-link-op  $n0 $n1 orient left
$ns duplex-link-op  $n0 $n2 orient right
$ns duplex-link-op $n0 $n3 orient up
$ns duplex-link-op $n0 $n4 orient down


#Setup a TCP connection
set tcp [new Agent/TCP/Newreno]
$ns attach-agent $n0 $tcp
set sink [new Agent/TCPSink/DelAck]
$ns attach-agent $n4 $sink
$ns connect $tcp $sink
$tcp set fid_ 1

#Setup a FTP over TCP connection
set ftp [new Application/FTP]
$ftp attach-agent $tcp
$ftp set type_ FTP

$ns rtmodel-at 1.0 down $n0 $n4
$ns rtmodel-at 4.5 up $n0 $n4

$ns at 0.1 "$ftp start"

$ns at 6.0 "finish"

$ns run
