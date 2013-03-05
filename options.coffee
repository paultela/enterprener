words = {}

load = (dict) ->
	for word in dict
		add word

add = (word) ->
	if words.hasOwnProperty word.search
		return throw "'#{word.search}' is already in the dictionary"

	words[word.search] = {}
	words[word.search].correct = word.correct if word.correct?
	words[word.search].threshold = word.threshold if word.threshold?

list = ->
	for word of words
		console.log '%s: %o', word, words[word]

refresh = ->
	tbody = document.getElementById 'wordList'

	tbody.innerHTML = ("<tr data-word=\"#{word}\"><td><a href=\"\"><i class=\"icon-remove-sign\" /></a></td><td>#{word}</td><td>#{words[word].correct||word}</td></tr>" for word of words).join ''



chrome.storage.sync.get 'dictionary', (res) ->
	load res.dictionary

	add
		search: 'viral'
		correct: 'untenable'

	refresh()

