---
title: "Search Results"
sitemap:
  priority : 0.1

slug: "search"
disable_comments: true
---

<section>
  <div>
    <form action="{{ "search" | absURL }}">
      <input id="search-query" name="s"/>
    </form>
    <div id="search-results">
     <h3>Matching pages</h3>
    </div>
  </div>
</section>
<script id="search-result-template" type="text/x-js-template">
  <div id="summary-${key}">
    <h4><a href="${link}">${title}</a></h4>
    <p>${snippet}</p>
    ${ isset tags }<p>Tags: ${tags}</p>${ end }
    ${ isset categories }<p>Categories: ${categories}</p>${ end }
  </div>
</script>
<script src="https://code.jquery.com/jquery-3.3.1.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/fuse.js/3.2.0/fuse.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/mark.js/8.11.1/jquery.mark.min.js"></script>
<script src="{{ "js/search.js" | absURL }}"></script>