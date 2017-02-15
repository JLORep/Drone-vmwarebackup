$servers = "Informer","hopi","yuki","blood"

Foreach($s in $servers)

{

  if(!(Test-Connection -Cn $s -BufferSize 16 -Count 1 -ea 0 -quiet))

  {

   "Problem connecting to $s"

   "Flushing DNS"

   ipconfig /flushdns | out-null

   "Registering DNS"

   ipconfig /registerdns | out-null

  "doing a NSLookup for $s"

   nslookup $s

   "Re-pinging $s"

     if(!(Test-Connection -Cn $s -BufferSize 16 -Count 1 -ea 1 -quiet))

      {"Problem still exists in connecting to $s"}

       ELSE {"Resolved problem connecting to $s"} #end if

   } # end if

} # end foreach