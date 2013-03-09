# Options.coffee
# Code-behind for the extension's settings page
# Compile to options.js



# Dictionary management

words = []

# Construct an object representing the most basic word - just a search string
Word = ->
	return { search: '' }

# Add all words in an array to the words array
# Usually used at startup to load the saved dictionary
load = (dict) ->
	for word in dict
		add word

# Get the 0-based index of a word in the words array
# Checks for match between term and word.search
find = (term) ->
	for i in [0...words.length]
		if words[i].search == term
			return i
	return -1

# Adds a word to the words array if it is not already included
# Throws exception if word already defined
add = (word) ->
	if find(word.search) >= 0
		return throw "'#{word.search}' is already in the dictionary"
	words.push word
	$('#dictionary').append events makeRow Word()



# DOM manipulation

# Generate the DOM object for a word's table row
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

# Is a row empty?
# An empty row is one with no value in the search input
empty = (row) ->
	if $(row).find('.word-search input').val().length
		return false
	return true

# Empty and reload the table of words from the words array
refresh = ->
	tbody = $ '#dictionary'
	tbody.empty()
	for word in words
		tbody.append makeRow word
	tbody.append makeRow Word()

	$.each $('.word'), (i, word) ->
		events word



# CRUD operations

# Apply all necessary event watchers to a row
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

# Serialize the words array to Chrome's sync storage
save = ->
	chrome.storage.sync.set { dictionary: words }

# Remove a word from the dictionary
undefine = (row) ->
	console.log 'Deleting "%s"', $(row).data('word')
	$(row).remove()
	words.splice(find($(row).data('word')), 1)
	save()
	row

# Begin edit mode on a row
edit = (row) ->
	console.log 'Editing "%s"', $(row).data('word')
	$(row).addClass 'editing'
	row

# Done editing a row
finish = (row) ->
	console.log 'Finishing "%s"', $(row).data('word')
	$(row).removeClass 'editing'
	row

# Modify a word in the dictionary
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

	row



# Startup

# Load words from Chrome's sync storage
# Refresh the displayed table
chrome.storage.sync.get (res) ->
	load res.dictionary

	refresh()

