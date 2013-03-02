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
	if (target.nodeType == 3) // defeat Safari bug
		target = target.parentNode;

	target.value = target.value.replace(regex, "$1ntrepreneur");
}

var enable = function (els) {
	for(el in els) {
		try {
			els[el].addEventListener('change', spellcheck);
		} catch (err) {}
	}
}

var setup = function () {
	regex = buildRegex();
	enable(document.getElementsByTagName('input'));
	enable(document.getElementsByTagName('textarea'));
}

var regex;
setup();

})();
