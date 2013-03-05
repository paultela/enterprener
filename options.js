// Generated by CoffeeScript 1.6.1
(function() {

  chrome.storage.sync.get('dictionary', function(items) {
    var reducer, table, tableBody;
    console.log(items);
    tableBody = document.getElementById('wordList');
    reducer = function(html, e) {
      html += "<tr>";
      html += "<td>" + e.search + "</td>";
      html += "<td>" + (e.correct || e.search) + "</td>";
      return html += "</tr>";
    };
    table = items.dictionary.reduce(reducer, "");
    tableBody.innerHTML = table;
    return console.log(table);
  });

}).call(this);
