BEGIN {
		
		cbr_recv = 0 ;
		cbr_send = 0 ;
		cbr_end = 0 ;

	 }

{
	if($1=="s" && $35=="cbr"){ cbr_send++;}
	if($1=="r" && $35=="cbr"){ cbr_recv++;}

	
}

END	{
	print "Number of CBR packets sent \t : " cbr_send
	print "Number of CBR packets received \t : " cbr_recv
	print "Packet delivery ratio \t : " (cbr_recv/cbr_send*100)
	#print "CBR Throughput \t : " (cbr_recv*210*8/10)

}
