using Toybox.System;

module BWFace {
	function decimals(n,scale){
		var t0=(n.toFloat()-0.5)/1000.0;
		var t1=(n.toFloat()+0.5)/1000.0;
		var fract = ((((t1 - n.toLong()/1000)*1000).toFloat())/scale.toFloat()).toLong();
		return [(t0 - 0.5/1000.0).toLong(),fract]; 
	}
	
	function decFields(value,delim,scale,prec){
		if (value==null) {
			return ["--",""];
		} 
		if (value instanceof Toybox.Lang.String){
			var index = value.find(":");
			if (index==null){
				return [value,""];
			}
			var v0 = value.substring(0, index);
			var v1 = value.substring(index, value.length());
			return [v0,v1];
		}				
		var dec  = decimals(value.toNumber(),scale);	
		return [dec[0].toString(),delim+dec[1].format("%0"+prec+"d")];
	}
}