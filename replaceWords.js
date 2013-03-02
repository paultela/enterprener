;(function() {

var buildRegex = function () {
	var spellings = ['(E|e)nt', ['rep', 'ep', 'erp'], ['ren', 'en', 'ern'], ['eur', 'er']];
	//var endings = ['', 'ship', 'ial'];
	var parts = [];

	for (var i = 0; i < spellings.length; i++) {
		if (spellings[i] instanceof Array) {
			parts.push('(?:');
				for (var j = 0; j < spellings[i].length; j++) {
					parts.push(spellings[i][j]);
					parts.push('|');
				}
				parts.pop();
				parts.push(')');
		} else { // String
			parts.push(spellings[i]);
		}
	}

	return new RegExp(parts.join(''), 'g');
}

var spellcheck = function (e) {
	var target;
	if (!e) var e = window.event;
	if (e.target) target = e.target;
	else if (e.srcElement) targ = e.srcElement;
	if (target.nodeType == 3) // defeat Safari bug, in a Chrome extension.
		target = target.parentNode;

	target.value = target.value.replace(regex, "$1ntrepreneur");
}

var setup = function () {
	regex = buildRegex();
	document.addEventListener('input', spellcheck);
}

var regex;
setup();

})();
