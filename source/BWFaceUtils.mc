module BWFace {
	function decimals(n,scale){
		var t0=(n.toDouble()-0.5)/1000.0;
		var t1=(n.toDouble()+0.5)/1000.0;
		var fract = ((((t1 - n.toLong()/1000)*1000).toFloat())/scale.toFloat()).toLong();
		return [(t0 - 0.5/1000.0).toLong(),fract]; 
	}
	
	function decFields(n,f,scale,prec){
		if (n==null) {
			return ["--",""];
		} 
		var dec  = decimals(n,scale);	
		return [dec[0].toString(),f+dec[1].format("%0"+prec+"d")];
	}
}