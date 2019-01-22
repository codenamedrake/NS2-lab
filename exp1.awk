
BEGIN{cbr_send=0;cbr_recv=0;tcp_send=0;tcp_recv=0;}

{
if($1=="+"&&$3==3&&$4==0&&$5=="cbr"){cbr_send++;}
if($1=="r"&&$3==1&&$4==5&&$5=="cbr"){cbr_recv++;}
if($1=="+"&&$3==2&&$4==0&&$5=="tcp"){tcp_send++;}
if($1=="r"&&$3==1&&$4==4&&$5=="tcp"){tcp_recv++;}
}

END{
print "No of CBR packets send\t\t:" cbr_send
print "No of CBR packets recieved\t\t:" cbr_recv
print "Pacaket Delivery ratio\t\t:"(cbr_recv/cbr_send*100)

print "\n\n\n No of TCP packets send\t\t:"tcp_send
print "No of TCP packets recieved\t\t:"tcp_recv
print"Packet delivery ratio \t\t:"(tcp_recv/tcp_send*100)

}
