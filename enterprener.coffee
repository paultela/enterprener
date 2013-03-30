dict = []


spellcheck = (event) ->
	target = event.target

	words = target.value.split /\b/
	fuse = new Fuse words,
		threshold: 0.3

	for term in dict
		matches = fuse.search term.search
		words[match] = (term.correct || term.search) for match in matches

	target.value = words.join ''

load = ->
	chrome.storage.sync.get (res) ->
		dict = res.dictionary

# Listen for sync storage change and reload
chrome.storage.onChanged.addListener load

load()
document.addEventListener 'change', spellcheck
###
Eventually we'd like to bind to the input event, but as of right now that
jumps the cursor to the end of the line every time. Maybe this helps:
http://stackoverflow.com/questions/512528/set-cursor-position-in-html-textbox
###
