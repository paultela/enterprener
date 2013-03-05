chrome.storage.sync.get 'dictionary', (items) ->
	console.log items
	tableBody = document.getElementById 'wordList'

	reducer = (html, e) ->
		html += "<tr>"
		html += "<td>" + e.search + "</td>"
		html += "<td>" + (e.correct || e.search) + "</td>"
		html += "</tr>"


	table = items.dictionary.reduce reducer, ""
	
	tableBody.innerHTML = table

	console.log table
	
