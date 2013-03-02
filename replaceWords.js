(function($) {

	function buildRegex() {
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

var regex = buildRegex();

function changeStuff(e) {
	$(this).val($(this).val().replace(regex, "$1ntrepreneur"));
}

$('input').on('change', changeStuff);
$('textarea').on('change', changeStuff);

})(jQuery);