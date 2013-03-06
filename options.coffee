words = []

Word = ->
	return { search: '' }

load = (dict) ->
	for word in dict
		add word

find = (term) ->
	for i in [0...words.length]
		if words[i].search == term
			return i
	return -1

add = (word) ->
	if find(word.search) >= 0
		return throw "'#{word.search}' is already in the dictionary"
	words.push word
	$('#dictionary').append events makeRow Word()

list = ->
	for word of words
		console.log '%s: %o', word, words[word]

makeRow = (word) ->
	# Word row
	tr = $ '<tr class="word">'
	tr.data 'word', word.search

	# Search input
	td = $ '<td class="word-search">'
	input = $ '<input type="text" placeholder="Correct this..." />'
	input.val word.search
	tr.append td.append input

	# Correct input
	td = $ '<td class="word-correct">'
	input = $ '<input type="text" placeholder="...to this" />'
	input.val word.correct
	tr.append td.append input

	# Remove button
	td = $ '<td>'
	a = $ '<a class="btn-remove" href="" tabindex="-1"></a>'
	i = $ '<i class="icon-remove"></i>'
	tr.append td.append a.append i

	tr

empty = (row) ->
	if $(row).find('.word-search input').val().length
		console.log 'Not empty'
		return false
	console.log 'Empty'
	return true

refresh = ->
	tbody = $ '#dictionary'
	tbody.empty()
	for word in words
		tbody.append makeRow word
	tbody.append makeRow Word()

	$.each $('.word'), (i, word) ->
		events word

events = (row) ->
	inputs = $(row).find('input')

	inputs.on 'click focus', ->
		edit row

	inputs.on 'blur', ->
		finish row
		if not empty row
			update row
		$(row).data 'word', $(row).find('.word-search input').val()

	$(row).find('.btn-remove').on 'click', (event) ->
		event.preventDefault()
		if not empty row
			undefine row

	row

save = ->
	chrome.storage.sync.set { dictionary: words }

undefine = (row) ->
	console.log 'Deleting "%s"', $(row).data('word')
	$(row).remove()
	words.splice(find($(row).data('word')), 1)
	save()
	row

edit = (row) ->
	console.log 'Editing "%s"', $(row).data('word')
	$(row).addClass 'editing'
	row

finish = (row) ->
	console.log 'Finishing "%s"', $(row).data('word')
	$(row).removeClass 'editing'
	row

update = (row) ->
	console.log 'Saving "%s"', $(row).data('word')

	word =
		search: $(row).find('.word-search input').val()
		correct: $(row).find('.word-correct input').val()

	if not word.search
		return row

	entry = find $(row).data('word')
	if entry >= 0
		words[entry] = word
	else
		add word

	save()

	#console.log $('#dictionary').children().length
	#if $('#dictionary').children().length == words.length
	row

chrome.storage.sync.get (res) ->
	load res.dictionary

	refresh()

