
module OperatorMsg
{
    use ServerConfig;

    use Time;
    use Math;

    use MultiTypeSymbolTable;
    use MultiTypeSymEntry;
    use ServerErrorStrings;

    // parse and respond to binopvv message
    // vv == vector op vector
    proc binopvvMsg(req_msg: string, st: borrowed SymTab): string {
        var rep_msg: string; // response message
        var fields = req_msg.split(); // split request into fields
        var cmd = fields[1];
        var op = fields[2];
        var aname = fields[3];
        var bname = fields[4];
        var rname = st.next_name();
        if v {try! writeln("%s %s %s %s : %s".format(cmd,op,aname,bname,rname));try! stdout.flush();}

        var left: borrowed GenSymEntry = st.lookup(aname);
        if (left == nil) {return try! "Error: binopvv: unkown symbol %s".format(aname);}
        var right: borrowed GenSymEntry = st.lookup(bname);
        if (right == nil) {return try! "Error: binopvv: unkown symbol %s".format(bname);}

        select (left.dtype, right.dtype) {
            when (DType.Int64, DType.Int64) {
                var l = toSymEntry(left,int);
                var r = toSymEntry(right,int);
                select op
                {
                    when "+" {
                        var a = l.a + r.a;
                        st.addEntry(rname, new shared SymEntry(a));
                    }
                    when "-" {
                        var a = l.a - r.a;
                        st.addEntry(rname, new shared SymEntry(a));
                    }
                    when "*" {
                        var a = l.a * r.a;
                        st.addEntry(rname, new shared SymEntry(a));
                    }
                    when "/" { // truediv
                        var a = l.a:real / r.a:real;
                        st.addEntry(rname, new shared SymEntry(a));
                    } 
                    when "//" { // floordiv
                        var a = l.a / r.a;
                        st.addEntry(rname, new shared SymEntry(a));                        
                    }
                    when "<" {
                        var a = l.a < r.a;
                        st.addEntry(rname, new shared SymEntry(a));                        
                    }
                    when ">" {
                        var a = l.a > r.a;
                        st.addEntry(rname, new shared SymEntry(a));                        
                    }
                    when "<=" {
                        var a = l.a <= r.a;
                        st.addEntry(rname, new shared SymEntry(a));                        
                    }
                    when ">=" {
                        var a = l.a >= r.a;
                        st.addEntry(rname, new shared SymEntry(a));                        
                    }
                    when "==" {
                        var a = l.a == r.a;
                        st.addEntry(rname, new shared SymEntry(a));                        
                    }
                    when "!=" {
                        var a = l.a != r.a;
                        st.addEntry(rname, new shared SymEntry(a));                        
                    }                    
                    when "<<" {
                        var a = l.a << r.a;
                        st.addEntry(rname, new shared SymEntry(a));                        
                    }                    
                    when ">>" {
                        var a = l.a >> r.a;
                        st.addEntry(rname, new shared SymEntry(a));                        
                    }                    
                    when "&" {
                        var a = l.a & r.a;
                        st.addEntry(rname, new shared SymEntry(a));                        
                    }                    
                    when "|" {
                        var a = l.a | r.a;
                        st.addEntry(rname, new shared SymEntry(a));                        
                    }                    
                    when "^" {
                        var a = l.a ^ r.a;
                        st.addEntry(rname, new shared SymEntry(a));
                    }                    
                    otherwise {return notImplementedError("binopvv",left.dtype,op,right.dtype);}
                }
            }
            when (DType.Int64, DType.Float64) {
                var l = toSymEntry(left,int);
                var r = toSymEntry(right,real);
                select op
                {
                    when "+" {
                        var a = l.a + r.a;
                        st.addEntry(rname, new shared SymEntry(a));
                    }
                    when "-" {
                        var a = l.a - r.a;
                        st.addEntry(rname, new shared SymEntry(a));
                    }
                    when "*" {
                        var a = l.a * r.a;
                        st.addEntry(rname, new shared SymEntry(a));
                    }
                    when "/" { // truediv
                        var a = l.a:real / r.a;
                        st.addEntry(rname, new shared SymEntry(a));
                    } 
                    when "//" { // floordiv
                        var a = floor((l.a / r.a));
                        st.addEntry(rname, new shared SymEntry(a));                        
                    }
                    when "<" {
                        var a = l.a < r.a;
                        st.addEntry(rname, new shared SymEntry(a));                        
                    }
                    when ">" {
                        var a = l.a > r.a;
                        st.addEntry(rname, new shared SymEntry(a));                        
                    }
                    when "<=" {
                        var a = l.a <= r.a;
                        st.addEntry(rname, new shared SymEntry(a));                        
                    }
                    when ">=" {
                        var a = l.a >= r.a;
                        st.addEntry(rname, new shared SymEntry(a));                        
                    }
                    when "==" {
                        var a = l.a == r.a;
                        st.addEntry(rname, new shared SymEntry(a));                        
                    }
                    when "!=" {
                        var a = l.a != r.a;
                        st.addEntry(rname, new shared SymEntry(a));                        
                    }
                    otherwise {return notImplementedError("binopvv",left.dtype,op,right.dtype);}
                }
            }
            when (DType.Float64, DType.Int64) {
                var l = toSymEntry(left,real);
                var r = toSymEntry(right,int);
                select op
                {
                    when "+" {
                        var a = l.a + r.a;
                        st.addEntry(rname, new shared SymEntry(a));
                    }
                    when "-" {
                        var a = l.a - r.a;
                        st.addEntry(rname, new shared SymEntry(a));
                    }
                    when "*" {
                        var a = l.a * r.a;
                        st.addEntry(rname, new shared SymEntry(a));
                    }
                    when "/" { // truediv
                        var a = l.a / r.a:real;
                        st.addEntry(rname, new shared SymEntry(a));
                    } 
                    when "//" { // floordiv
                        var a = floor(l.a / r.a);
                        st.addEntry(rname, new shared SymEntry(a));                        
                    }
                    when "<" {
                        var a = l.a < r.a;
                        st.addEntry(rname, new shared SymEntry(a));                        
                    }
                    when ">" {
                        var a = l.a > r.a;
                        st.addEntry(rname, new shared SymEntry(a));                        
                    }
                    when "<=" {
                        var a = l.a <= r.a;
                        st.addEntry(rname, new shared SymEntry(a));                        
                    }
                    when ">=" {
                        var a = l.a >= r.a;
                        st.addEntry(rname, new shared SymEntry(a));                        
                    }
                    when "==" {
                        var a = l.a == r.a;
                        st.addEntry(rname, new shared SymEntry(a));                        
                    }
                    when "!=" {
                        var a = l.a != r.a;
                        st.addEntry(rname, new shared SymEntry(a));                        
                    }
                    otherwise {return notImplementedError("binopvv",left.dtype,op,right.dtype);}
                }
            }
            when (DType.Float64, DType.Float64) {
                var l = toSymEntry(left,real);
                var r = toSymEntry(right,real);
                select op
                {
                    when "+" {
                        var a = l.a + r.a;
                        st.addEntry(rname, new shared SymEntry(a));
                    }
                    when "-" {
                        var a = l.a - r.a;
                        st.addEntry(rname, new shared SymEntry(a));
                    }
                    when "*" {
                        var a = l.a * r.a;
                        st.addEntry(rname, new shared SymEntry(a));
                    }
                    when "/" { // truediv
                        var a = l.a / r.a;
                        st.addEntry(rname, new shared SymEntry(a));
                    } 
                    when "//" { // floordiv
                        var a = floor(l.a / r.a);
                        st.addEntry(rname, new shared SymEntry(a));                        
                    }
                    when "<" {
                        var a = l.a < r.a;
                        st.addEntry(rname, new shared SymEntry(a));                        
                    }
                    when ">" {
                        var a = l.a > r.a;
                        st.addEntry(rname, new shared SymEntry(a));                        
                    }
                    when "<=" {
                        var a = l.a <= r.a;
                        st.addEntry(rname, new shared SymEntry(a));                        
                    }
                    when ">=" {
                        var a = l.a >= r.a;
                        st.addEntry(rname, new shared SymEntry(a));                        
                    }
                    when "==" {
                        var a = l.a == r.a;
                        st.addEntry(rname, new shared SymEntry(a));                        
                    }
                    when "!=" {
                        var a = l.a != r.a;
                        st.addEntry(rname, new shared SymEntry(a));                        
                    }
                    otherwise {return notImplementedError("binopvv",left.dtype,op,right.dtype);}
                }
            }
            otherwise {return unrecognizedTypeError("binopvv",
                                                    "("+dtype2str(left.dtype)+","+dtype2str(right.dtype)+")");}
        }
        return try! "created " + st.attrib(rname);
    }

    // parse and respond to binopvs message
    // vs == vector op scalar
    proc binopvsMsg(req_msg: string, st: borrowed SymTab): string {
        var rep_msg: string = ""; // response message
        var fields = req_msg.split(); // split request into fields
        var cmd = fields[1];
        var op = fields[2];
        var aname = fields[3];
        var dtype = str2dtype(fields[4]);
        var value = fields[5];
        var rname = st.next_name();
        if v {try! writeln("%s %s %s %s %s : %s".format(cmd,op,aname,dtype2str(dtype),value,rname));try! stdout.flush();}

        var left: borrowed GenSymEntry = st.lookup(aname);
        if (left == nil) {return try! "Error: binopvs: unkown symbol %s".format(aname);}
        select (left.dtype, dtype) {
            when (DType.Int64, DType.Int64) {
                var l = toSymEntry(left,int);
                var val = try! value:int;
                select op
                {
                    when "+" {
                        var a = l.a + val;
                        st.addEntry(rname, new shared SymEntry(a));
                    }
                    when "-" {
                        var a = l.a - val;
                        st.addEntry(rname, new shared SymEntry(a));
                    }
                    when "*" {
                        var a = l.a * val;
                        st.addEntry(rname, new shared SymEntry(a));
                    }
                    when "/" { // truediv
                        var a = l.a:real / val:real;
                        st.addEntry(rname, new shared SymEntry(a));
                    } 
                    when "//" { // floordiv
                        var a = l.a / val;
                        st.addEntry(rname, new shared SymEntry(a));
                    }
                    when "<" {
                        var a = l.a < val;
                        st.addEntry(rname, new shared SymEntry(a));
                    }
                    when ">" {
                        var a = l.a > val;
                        st.addEntry(rname, new shared SymEntry(a));
                    }
                    when "<=" {
                        var a = l.a <= val;
                        st.addEntry(rname, new shared SymEntry(a));
                    }
                    when ">=" {
                        var a = l.a >= val;
                        st.addEntry(rname, new shared SymEntry(a));
                    }
                    when "==" {
                        var a = l.a == val;
                        st.addEntry(rname, new shared SymEntry(a));
                    }
                    when "!=" {
                        var a = l.a != val;
                        st.addEntry(rname, new shared SymEntry(a));
                    }
                    when "<<" {
                        var a = l.a << val;
                        st.addEntry(rname, new shared SymEntry(a));
                    }
                    when ">>" {
                        var a = l.a >> val;
                        st.addEntry(rname, new shared SymEntry(a));
                    }
                    when "&" {
                        var a = l.a & val;
                        st.addEntry(rname, new shared SymEntry(a));
                    }
                    when "|" {
                        var a = l.a | val;
                        st.addEntry(rname, new shared SymEntry(a));
                    }
                    when "^" {
                        var a = l.a ^ val;
                        st.addEntry(rname, new shared SymEntry(a));
                    }
                    otherwise {return notImplementedError("binopvs",left.dtype,op,dtype);}
                }
            }
            when (DType.Int64, DType.Float64) {
                var l = toSymEntry(left,int);
                var val = try! value:real;
                select op
                {
                    when "+" {
                        var a = l.a + val;
                        st.addEntry(rname, new shared SymEntry(a));
                    }
                    when "-" {
                        var a = l.a - val;
                        st.addEntry(rname, new shared SymEntry(a));
                    }
                    when "*" {
                        var a = l.a * val;
                        st.addEntry(rname, new shared SymEntry(a));
                    }
                    when "/" { // truediv
                        var a = l.a:real / val;
                        st.addEntry(rname, new shared SymEntry(a));
                    } 
                    when "//" { // floordiv
                        var a = floor(l.a:real / val);
                        st.addEntry(rname, new shared SymEntry(a));
                    }
                    when "<" {
                        var a = l.a < val;
                        st.addEntry(rname, new shared SymEntry(a));
                    }
                    when ">" {
                        var a = l.a > val;
                        st.addEntry(rname, new shared SymEntry(a));
                    }
                    when "<=" {
                        var a = l.a <= val;
                        st.addEntry(rname, new shared SymEntry(a));
                    }
                    when ">=" {
                        var a = l.a >= val;
                        st.addEntry(rname, new shared SymEntry(a));
                    }
                    when "==" {
                        var a = l.a == val;
                        st.addEntry(rname, new shared SymEntry(a));
                    }
                    when "!=" {
                        var a = l.a != val;
                        st.addEntry(rname, new shared SymEntry(a));
                    }
                    otherwise {return notImplementedError("binopvs",left.dtype,op,dtype);}
                }
            }
            when (DType.Float64, DType.Int64) {
                var l = toSymEntry(left,real);
                var val = try! value:int;
                select op
                {
                    when "+" {
                        var a = l.a + val;
                        st.addEntry(rname, new shared SymEntry(a));
                    }
                    when "-" {
                        var a = l.a - val;
                        st.addEntry(rname, new shared SymEntry(a));
                    }
                    when "*" {
                        var a = l.a * val;
                        st.addEntry(rname, new shared SymEntry(a));
                    }
                    when "/" { // truediv
                        var a = l.a / val:real;
                        st.addEntry(rname, new shared SymEntry(a));
                    } 
                    when "//" { // floordiv
                        var a = floor(l.a / val:real);
                        st.addEntry(rname, new shared SymEntry(a));
                    }
                    when "<" {
                        var a = l.a < val;
                        st.addEntry(rname, new shared SymEntry(a));
                    }
                    when ">" {
                        var a = l.a > val;
                        st.addEntry(rname, new shared SymEntry(a));
                    }
                    when "<=" {
                        var a = l.a <= val;
                        st.addEntry(rname, new shared SymEntry(a));
                    }
                    when ">=" {
                        var a = l.a >= val;
                        st.addEntry(rname, new shared SymEntry(a));
                    }
                    when "==" {
                        var a = l.a == val;
                        st.addEntry(rname, new shared SymEntry(a));
                    }
                    when "!=" {
                        var a = l.a != val;
                        st.addEntry(rname, new shared SymEntry(a));
                    }
                    otherwise {return notImplementedError("binopvs",left.dtype,op,dtype);}
                }
            }
            when (DType.Float64, DType.Float64) {
                var l = toSymEntry(left,real);
                var val = try! value:real;
                select op
                {
                    when "+" {
                        var a = l.a + val;
                        st.addEntry(rname, new shared SymEntry(a));
                    }
                    when "-" {
                        var a = l.a - val;
                        st.addEntry(rname, new shared SymEntry(a));
                    }
                    when "*" {
                        var a = l.a * val;
                        st.addEntry(rname, new shared SymEntry(a));
                    }
                    when "/" { // truediv
                        var a = l.a / val;
                        st.addEntry(rname, new shared SymEntry(a));
                    } 
                    when "//" { // floordiv
                        var a = floor(l.a / val);
                        st.addEntry(rname, new shared SymEntry(a));
                    }
                    when "<" {
                        var a = l.a < val;
                        st.addEntry(rname, new shared SymEntry(a));
                    }
                    when ">" {
                        var a = l.a > val;
                        st.addEntry(rname, new shared SymEntry(a));
                    }
                    when "<=" {
                        var a = l.a <= val;
                        st.addEntry(rname, new shared SymEntry(a));
                    }
                    when ">=" {
                        var a = l.a >= val;
                        st.addEntry(rname, new shared SymEntry(a));
                    }
                    when "==" {
                        var a = l.a == val;
                        st.addEntry(rname, new shared SymEntry(a));
                    }
                    when "!=" {
                        var a = l.a != val;
                        st.addEntry(rname, new shared SymEntry(a));
                    }
                    otherwise {return notImplementedError("binopvs",left.dtype,op,dtype);}
                }
            }
            otherwise {return unrecognizedTypeError("binopvs",
                                                    "("+dtype2str(left.dtype)+","+dtype2str(dtype)+")");}
        }
        return try! "created " + st.attrib(rname);
    }

    // parse and respond to binopsv message
    // sv == scalar op vector
    proc binopsvMsg(req_msg: string, st: borrowed SymTab): string {
        var rep_msg: string = ""; // response message
        var fields = req_msg.split(); // split request into fields
        var cmd = fields[1];
        var op = fields[2];
        var dtype = str2dtype(fields[3]);
        var value = fields[4];
        var aname = fields[5];
        var rname = st.next_name();
        if v {try! writeln("%s %s %s %s %s : %s".format(cmd,op,dtype2str(dtype),value,aname,rname));try! stdout.flush();}

        var right: borrowed GenSymEntry = st.lookup(aname);
        if (right == nil) {return try! "Error: binopsv: unkown symbol %s".format(aname);}
        select (dtype, right.dtype) {
            when (DType.Int64, DType.Int64) {
                var val = try! value:int;
                var r = toSymEntry(right,int);
                select op
                {
                    when "+" {
                        var a = val + r.a;
                        st.addEntry(rname, new shared SymEntry(a));
                    }
                    when "-" {
                        var a = val - r.a;
                        st.addEntry(rname, new shared SymEntry(a));
                    }
                    when "*" {
                        var a = val * r.a;
                        st.addEntry(rname, new shared SymEntry(a));
                    }
                    when "/" { // truediv
                        var a =  val:real / r.a:real;
                        st.addEntry(rname, new shared SymEntry(a));
                    } 
                    when "//" { // floordiv
                        var a = val / r.a;
                        st.addEntry(rname, new shared SymEntry(a));
                    }
                    when "<" {
                        var a = val < r.a;
                        st.addEntry(rname, new shared SymEntry(a));
                    }
                    when ">" {
                        var a = val > r.a;
                        st.addEntry(rname, new shared SymEntry(a));
                    }
                    when "<=" {
                        var a = val <= r.a;
                        st.addEntry(rname, new shared SymEntry(a));
                    }
                    when ">=" {
                        var a = val >= r.a;
                        st.addEntry(rname, new shared SymEntry(a));
                    }
                    when "==" {
                        var a = val == r.a;
                        st.addEntry(rname, new shared SymEntry(a));
                    }
                    when "!=" {
                        var a = val != r.a;
                        st.addEntry(rname, new shared SymEntry(a));
                    }
                    when "<<" {
                        var a = val << r.a;
                        st.addEntry(rname, new shared SymEntry(a));
                    }
                    when ">>" {
                        var a = val >> r.a;
                        st.addEntry(rname, new shared SymEntry(a));
                    }
                    when "&" {
                        var a = val & r.a;
                        st.addEntry(rname, new shared SymEntry(a));
                    }
                    when "|" {
                        var a = val | r.a;
                        st.addEntry(rname, new shared SymEntry(a));
                    }
                    when "^" {
                        var a = val ^ r.a;
                        st.addEntry(rname, new shared SymEntry(a));
                    }
                    otherwise {return notImplementedError("binopsv",dtype,op,right.dtype);}
                }
            }
            when (DType.Int64, DType.Float64) {
                var val = try! value:int;
                var r = toSymEntry(right,real);
                select op
                {
                    when "+" {
                        var a = val + r.a;
                        st.addEntry(rname, new shared SymEntry(a));
                    }
                    when "-" {
                        var a = val - r.a - val;
                        st.addEntry(rname, new shared SymEntry(a));
                    }
                    when "*" {
                        var a = val * r.a * val;
                        st.addEntry(rname, new shared SymEntry(a));
                    }
                    when "/" { // truediv
                        var a = val:real / r.a;
                        st.addEntry(rname, new shared SymEntry(a));
                    }
                    when "//" { // floordiv
                        var a = floor(val:real / r.a);
                        st.addEntry(rname, new shared SymEntry(a));
                    }
                    when "<" {
                        var a = val < r.a;
                        st.addEntry(rname, new shared SymEntry(a));
                    }
                    when ">" {
                        var a = val > r.a;
                        st.addEntry(rname, new shared SymEntry(a));
                    }
                    when "<=" {
                        var a = val <= r.a;
                        st.addEntry(rname, new shared SymEntry(a));
                    }
                    when ">=" {
                        var a = val >= r.a;
                        st.addEntry(rname, new shared SymEntry(a));
                    }
                    when "==" {
                        var a = val == r.a;
                        st.addEntry(rname, new shared SymEntry(a));
                    }
                    when "!=" {
                        var a = val != r.a;
                        st.addEntry(rname, new shared SymEntry(a));
                    }
                    otherwise {return notImplementedError("binopsv",dtype,op,right.dtype);}
                }
            }
            when (DType.Float64, DType.Int64) {
                var val = try! value:real;
                var r = toSymEntry(right,int);
                select op
                {
                    when "+" {
                        var a = val + r.a;
                        st.addEntry(rname, new shared SymEntry(a));
                    }
                    when "-" {
                        var a = val - r.a;
                        st.addEntry(rname, new shared SymEntry(a));
                    }
                    when "*" {
                        var a = val * r.a;
                        st.addEntry(rname, new shared SymEntry(a));
                    }
                    when "/" { // truediv
                        var a = val / r.a:real;
                        st.addEntry(rname, new shared SymEntry(a));
                    } 
                    when "//" { // floordiv
                        var a = floor(val / r.a:real);
                        st.addEntry(rname, new shared SymEntry(a));
                    }
                    when "<" {
                        var a = val < r.a;
                        st.addEntry(rname, new shared SymEntry(a));
                    }
                    when ">" {
                        var a = val > r.a;
                        st.addEntry(rname, new shared SymEntry(a));
                    }
                    when "<=" {
                        var a = val <= r.a;
                        st.addEntry(rname, new shared SymEntry(a));
                    }
                    when ">=" {
                        var a = val >= r.a;
                        st.addEntry(rname, new shared SymEntry(a));
                    }
                    when "==" {
                        var a = val == r.a;
                        st.addEntry(rname, new shared SymEntry(a));
                    }
                    when "!=" {
                        var a = val != r.a;
                        st.addEntry(rname, new shared SymEntry(a));
                    }
                    otherwise {return notImplementedError("binopsv",dtype,op,right.dtype);}
                }
            }
            when (DType.Float64, DType.Float64) {
                var val = try! value:real;
                var r = toSymEntry(right,real);
                select op
                {
                    when "+" {
                        var a = val + r.a;
                        st.addEntry(rname, new shared SymEntry(a));
                    }
                    when "-" {
                        var a = val - r.a;
                        st.addEntry(rname, new shared SymEntry(a));
                    }
                    when "*" {
                        var a = val * r.a;
                        st.addEntry(rname, new shared SymEntry(a));
                    }
                    when "/" { // truediv
                        var a = val / r.a;
                        st.addEntry(rname, new shared SymEntry(a));
                    } 
                    when "//" { // floordiv
                        var a = floor(val / r.a);
                        st.addEntry(rname, new shared SymEntry(a));
                    }
                    when "<" {
                        var a = val < r.a;
                        st.addEntry(rname, new shared SymEntry(a));
                    }
                    when ">" {
                        var a = val > r.a;
                        st.addEntry(rname, new shared SymEntry(a));
                    }
                    when "<=" {
                        var a = val <= r.a;
                        st.addEntry(rname, new shared SymEntry(a));
                    }
                    when ">=" {
                        var a = val >= r.a;
                        st.addEntry(rname, new shared SymEntry(a));
                    }
                    when "==" {
                        var a = val == r.a;
                        st.addEntry(rname, new shared SymEntry(a));
                    }
                    when "!=" {
                        var a = val != r.a;
                        st.addEntry(rname, new shared SymEntry(a));
                    }
                    otherwise {return notImplementedError("binopsv",dtype,op,right.dtype);}
                }
            }
            otherwise {return unrecognizedTypeError("binopsv",
                                                    "("+dtype2str(dtype)+","+dtype2str(right.dtype)+")");}
        }
        return try! "created " + st.attrib(rname);
    }

    // parse and respond to opeqvv message
    // vector op= vector
    proc opeqvvMsg(req_msg: string, st: borrowed SymTab): string {
        var rep_msg: string; // response message
        var fields = req_msg.split(); // split request into fields
        var cmd = fields[1];
        var op = fields[2];
        var aname = fields[3];
        var bname = fields[4];
        if v {try! writeln("%s %s %s %s".format(cmd,op,aname,bname));try! stdout.flush();}
        
        var left: borrowed GenSymEntry = st.lookup(aname);
        if (left == nil) {return unknownSymbolError("opeqvv",aname);}
        var right: borrowed GenSymEntry = st.lookup(bname);
        if (right == nil) {return unknownSymbolError("opeqvv",bname);}
        select (left.dtype, right.dtype) {
            when (DType.Int64, DType.Int64) {
                var l = toSymEntry(left,int);
                var r = toSymEntry(right,int);
                select op
                {
                    when "+=" { l.a += r.a; }
                    when "-=" { l.a -= r.a; }
                    when "*=" { l.a *= r.a; }
                    when "//=" { l.a /= r.a; }//floordiv
                    otherwise {return notImplementedError("opeqvv",left.dtype,op,right.dtype);}
                }
            }
            when (DType.Int64, DType.Float64) {
                var l = toSymEntry(left,int);
                var r = toSymEntry(right,real);
                return notImplementedError("opeqvv",left.dtype,op,right.dtype);
            }
            when (DType.Float64, DType.Int64) {
                var l = toSymEntry(left,real);
                var r = toSymEntry(right,int);
                select op
                {
                    when "+=" {l.a += r.a;}
                    when "-=" {l.a -= r.a;}
                    when "*=" {l.a *= r.a;}
                    when "/=" {l.a /= r.a:real;} //truediv
                    when "//=" {l.a = floor(l.a / r.a);} //floordiv
                    otherwise {return notImplementedError("opeqvv",left.dtype,op,right.dtype);}
                }
            }
            when (DType.Float64, DType.Float64) {
                var l = toSymEntry(left,real);
                var r = toSymEntry(right,real);
                select op
                {
                    when "+=" {l.a += r.a;}
                    when "-=" {l.a -= r.a;}
                    when "*=" {l.a *= r.a;}
                    when "/=" {l.a /= r.a;}//truediv
                    when "//=" {l.a = floor(l.a / r.a);}//floordiv
                    otherwise {return notImplementedError("opeqvv",left.dtype,op,right.dtype);}
                }
            }
            otherwise {return unrecognizedTypeError("opeqvv",
                                                    "("+dtype2str(left.dtype)+","+dtype2str(right.dtype)+")");}
        }
        return "opeqvv success";
    }

    // parse and respond to opeqvs message
    // vector op= scalar
    proc opeqvsMsg(req_msg: string, st: borrowed SymTab): string {
        var rep_msg: string; // response message
        var fields = req_msg.split(); // split request into fields
        var cmd = fields[1];
        var op = fields[2];
        var aname = fields[3];
        var dtype = str2dtype(fields[4]);
        var value = fields[5];
        if v {try! writeln("%s %s %s %s %s".format(cmd,op,aname,dtype2str(dtype),value));try! stdout.flush();}

        var left: borrowed GenSymEntry = st.lookup(aname);
        if (left == nil) {return unknownSymbolError("opeqvs",aname);}
       
        select (left.dtype, dtype) {
            when (DType.Int64, DType.Int64) {
                var l = toSymEntry(left,int);
                var val = try! value:int;
                select op
                {
                    when "+=" { l.a += val; }
                    when "-=" { l.a -= val; }
                    when "*=" { l.a *= val; }
                    when "//=" { l.a /= val; }//floordiv
                    otherwise {return notImplementedError("opeqvs",left.dtype,op,dtype);}
                }
            }
            when (DType.Int64, DType.Float64) {
                var l = toSymEntry(left,int);
                var val = try! value:real;
                return notImplementedError("opeqvs",left.dtype,op,dtype);
            }
            when (DType.Float64, DType.Int64) {
                var l = toSymEntry(left,real);
                var val = try! value:int;
                select op
                {
                    when "+=" {l.a += val;}
                    when "-=" {l.a -= val;}
                    when "*=" {l.a *= val;}
                    when "/=" {l.a /= val:real;} //truediv
                    when "//=" {l.a = floor(l.a / val);} //floordiv
                    otherwise {return notImplementedError("opeqvs",left.dtype,op,dtype);}
                }
            }
            when (DType.Float64, DType.Float64) {
                var l = toSymEntry(left,real);
                var val = try! value:real;
                select op
                {
                    when "+=" {l.a += val;}
                    when "-=" {l.a -= val;}
                    when "*=" {l.a *= val;}
                    when "/=" {l.a /= val;}//truediv
                    when "//=" {l.a = floor(l.a / val);}//floordiv
                    otherwise {return notImplementedError("opeqvs",left.dtype,op,dtype);}
                }
            }
            otherwise {return unrecognizedTypeError("opeqvv",
                                                    "("+dtype2str(left.dtype)+","+dtype2str(dtype)+")");}
        }
        return "opeqvs success";
    }

}