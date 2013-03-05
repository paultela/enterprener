;(function() {

var dictionary = [{
	id: 1,
	word: "entrepreneur",
	correctTo: "entrepreneur"
}, {
	id: 2,
	word: "cloud",
	correctTo: "Internet"
}
];

var spellcheck = function (e) {
	var target;
	if (!e) e = window.event;
	if (e.target) target = e.target;
	else if (e.srcElement) targ = e.srcElement;
	if (target.nodeType == 3) // defeat Safari bug, in a Chrome extension.
		target = target.parentNode;

	// Split into words
	var foundWords = target.value.split(/\b/);

	var f = new Fuse(foundWords, {threshold: 0.3});

	for (var i = 0; i < dictionary.length; i++) {
		var exists = f.search(dictionary[i].word);

		if (exists.length > 0) {
			for (var j = 0; j < exists.length; j++) {
				foundWords[exists[j]] = dictionary[i].correctTo;
			}
		}
	}

	target.value = foundWords.join("");
};

var setup = function () {
	document.addEventListener('change', spellcheck);
	/*
	 * Eventually we'd like to bind to the input event, but as of right now that
	 * jumps the cursor to the end of the line every time. Maybe this helps:
	 * http://stackoverflow.com/questions/512528/set-cursor-position-in-html-textbox
	 */
};

setup();

})();
