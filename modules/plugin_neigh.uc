import * as rtnl from 'rtnl';
let global;

function get_arp_cache() {
	let ret = {};

	let cache = rtnl.request(rtnl.const.RTM_GETNEIGH, rtnl.const.NLM_F_DUMP, {});
	for (let data in cache)
		if (data.lladdr && data.dst)
			ret[data.dst] = data.lladdr;

	return ret;
}

function refresh() {
	let cache = get_arp_cache();
	for (let entry in cache) {
		let mac = cache[entry];
		if (!match(mac, /00:00:00.*/) &&
		    !match(mac, /^33:33.*/) &&
		    !match(mac, /^01:00:5e.*/) &&
		    !match(mac, /^ff:ff:ff.*/)) {
			global.device_add_data(mac, "");
			global.device_refresh(mac);
		}
	}
}

function init(gl) {
	global = gl;
}

return { init, refresh };
