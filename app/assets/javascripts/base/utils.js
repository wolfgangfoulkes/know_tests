KNOW = 
{
};

//CALLBACKS = {};

// var initPageAttr()
// {

// }

//var callbacks

var parseBool = function(string) {
    switch(string.toLowerCase().trim()){
        case "true": case "yes": case "1": return true;
        case "false": case "no": case "0": case null: return false;
        default: return Boolean(string);
    }
}

var $firstOfSels = function(sels_)
{
	for (key in sels_)
	{
		var $sel = $(sels_[key]);
		if ($sel.length > 0)
		{ 
			return $sel; 
		}
	}
	return $();
}