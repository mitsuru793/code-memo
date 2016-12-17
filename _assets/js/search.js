require("simple-jekyll-search/src/index.js");

SimpleJekyllSearch({
  searchInput: document.getElementById('search-input'),
  resultsContainer: document.getElementById('results-container'),
  json: './search.json',
  searchResultTemplate: '<li><a href="{url}" title="{desc}">{title}</a></li>',
  noResultsText: 'No results found',
  limit: 100,
  fuzzy: false
});