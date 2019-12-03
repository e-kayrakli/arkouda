/* arkouda server
backend chapel program to mimic ndarray from numpy
This is the main driver for the arkouda server */

use ServerConfig;

use Time only;
use ZMQ only;
use Memory;

use MultiTypeSymbolTable;
use MultiTypeSymEntry;
use MsgProcessing;
use GenSymIO;
use SymArrayDmap;
use ServerErrorStrings;

proc main() {
    writeln("arkouda server version = ",arkoudaVersion); try! stdout.flush();
    writeln("memory tracking = ", memTrack); try! stdout.flush();
    if (memTrack) {
        writeln("getMemLimit() = ",getMemLimit());
        writeln("bytes of memoryUsed() = ",memoryUsed());
        try! stdout.flush();
    }
    
    var st = new owned SymTab();
    var shutdownServer = false;

    // create and connect ZMQ socket
    var context: ZMQ.Context;
    var socket = context.socket(ZMQ.REP);
    socket.bind("tcp://*:%t".format(ServerPort));
    writeln("server listening on %s:%t".format(serverHostname, ServerPort)); try! stdout.flush();

    var reqCount: int = 0;
    var repCount: int = 0;
    while !shutdownServer {
        // receive requests
        var reqMsg = socket.recv(bytes);

        // start timer for command processing
        var t1 = Time.getCurrentTime();

        reqCount += 1;

        // shutdown server
        if reqMsg == b"shutdown" {
            if v {writeln("reqMsg: ", reqMsg); try! stdout.flush();}
            shutdownServer = true;
            repCount += 1;
            socket.send("shutdown server (%i req)".format(repCount));
            //socket.close(1000); /// error for some reason on close
            break;
        }

        var repMsg: bytes;
        
        // peel off the command
        var fields = reqMsg.split(1);
        var cmd = fields[1];
        
        if v {
            if cmd == b"array" { // has binary data in it's payload
                writeln("reqMsg: ", cmd, " <binary-data>");
            }
            else {
                writeln("reqMsg: ", reqMsg);
            }
            writeln(">>> ",cmd," started at ",t1,"sec");
            try! stdout.flush();
        }

        try {
        
            // parse requests, execute requests, format responses
            select cmd
            {
                when b"lshdf"             {repMsg = lshdfMsg(reqMsg, st);}
                when b"readhdf"           {repMsg = readhdfMsg(reqMsg, st);}
                when b"tohdf"             {repMsg = tohdfMsg(reqMsg, st);}
                when b"array"             {repMsg = arrayMsg(reqMsg, st);}
                when b"create"            {repMsg = createMsg(reqMsg, st);}
                when b"delete"            {repMsg = deleteMsg(reqMsg, st);}
                when b"binopvv"           {repMsg = binopvvMsg(reqMsg, st);}
                when b"binopvs"           {repMsg = binopvsMsg(reqMsg, st);}
                when b"binopsv"           {repMsg = binopsvMsg(reqMsg, st);}
                when b"opeqvv"            {repMsg = opeqvvMsg(reqMsg, st);}
                when b"opeqvs"            {repMsg = opeqvsMsg(reqMsg, st);}
                when b"efunc"             {repMsg = efuncMsg(reqMsg, st);}
                when b"efunc3vv"          {repMsg = efunc3vvMsg(reqMsg, st);}
                when b"efunc3vs"          {repMsg = efunc3vsMsg(reqMsg, st);}
                when b"efunc3sv"          {repMsg = efunc3svMsg(reqMsg, st);}
                when b"efunc3ss"          {repMsg = efunc3ssMsg(reqMsg, st);}
                when b"reduction"         {repMsg = reductionMsg(reqMsg, st);}
                when b"countReduction"    {repMsg = countReductionMsg(reqMsg, st);}
                when b"countLocalRdx"     {repMsg = countLocalRdxMsg(reqMsg, st);}
                when b"findSegments"      {repMsg = findSegmentsMsg(reqMsg, st);}
                when b"findLocalSegments" {repMsg = findLocalSegmentsMsg(reqMsg, st);}
                when b"segmentedReduction"{repMsg = segmentedReductionMsg(reqMsg, st);}
                when b"segmentedLocalRdx" {repMsg = segmentedLocalRdxMsg(reqMsg, st);}
                when b"arange"            {repMsg = arangeMsg(reqMsg, st);}
                when b"linspace"          {repMsg = linspaceMsg(reqMsg, st);}
                when b"randint"           {repMsg = randintMsg(reqMsg, st);}
                when b"histogram"         {repMsg = histogramMsg(reqMsg, st);}
                when b"in1d"              {repMsg = in1dMsg(reqMsg, st);}
                when b"unique"            {repMsg = uniqueMsg(reqMsg, st);}
                when b"value_counts"      {repMsg = value_countsMsg(reqMsg, st);}
                when b"set"               {repMsg = setMsg(reqMsg, st);}
                when b"info"              {repMsg = infoMsg(reqMsg, st);}
                when b"str"               {repMsg = strMsg(reqMsg, st);}
                when b"repr"              {repMsg = reprMsg(reqMsg, st);}
                when b"tondarray"         {repMsg = tondarrayMsg(reqMsg, st);}
                when b"[int]"             {repMsg = intIndexMsg(reqMsg, st);}
                when b"[slice]"           {repMsg = sliceIndexMsg(reqMsg, st);}
                when b"[pdarray]"         {repMsg = pdarrayIndexMsg(reqMsg, st);}
                when b"[int]=val"         {repMsg = setIntIndexToValueMsg(reqMsg, st);}
                when b"[pdarray]=val"     {repMsg = setPdarrayIndexToValueMsg(reqMsg, st);}            
                when b"[pdarray]=pdarray" {repMsg = setPdarrayIndexToPdarrayMsg(reqMsg, st);}            
                when b"[slice]=val"       {repMsg = setSliceIndexToValueMsg(reqMsg, st);}            
                when b"[slice]=pdarray"   {repMsg = setSliceIndexToPdarrayMsg(reqMsg, st);}
                when b"argsort"           {repMsg = argsortMsg(reqMsg, st);}
                when b"coargsort"         {repMsg = coargsortMsg(reqMsg, st);}
                when b"concatenate"       {repMsg = concatenateMsg(reqMsg, st);}
                when b"localArgsort"      {repMsg = localArgsortMsg(reqMsg, st);}
                when b"sort"              {repMsg = sortMsg(reqMsg, st);}
                when b"getconfig"         {repMsg = getconfigMsg(reqMsg, st);}
                when b"getmemused"        {repMsg = getmemusedMsg(reqMsg, st);}
                when b"connect" {
                    repMsg = "connected to arkouda server tcp://*:%t".format(ServerPort);
                }
                when b"disconnect" {
                    repMsg = "disconnected from arkouda server tcp://*:%t".format(ServerPort);
                }
                otherwise {
                    if v {writeln("Error: unrecognized command: %s".format(reqMsg)); try! stdout.flush();}
                }
            }
            
        } catch (e: ErrorWithMsg) {
            repMsg = e.msg;
        } catch {
            repMsg = unknownError("");
        }
        
        // send responses
        // send count for now
        repCount += 1;
        if v {
	  if cmd == b"tondarray" {
              writeln("repMsg:"," <binary-data>");
	  } else {
	    writeln("repMsg:",repMsg);
	  }
	  try! stdout.flush();
	}
        socket.send(repMsg);

        if (memTrack) {writeln("bytes of memoryUsed() = ",memoryUsed()); try! stdout.flush();}

        // end timer for command processing
        if v{writeln("<<< ", cmd," took ", Time.getCurrentTime() - t1,"sec"); try! stdout.flush();}
    }

    writeln("requests = ",reqCount," responseCount = ",repCount);
}

