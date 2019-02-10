require 'cgi'
pages << {
    page_type: 'products_search',
    method: 'GET',

    url: 'https://www.willys.se/c/Dryck/Sport-och-energridryck/Energidryck?avoidCache=1549831339477&categoryPath=Dryck%2FSport-och-energridryck%2FEnergidryck&page=1&size=30',
    vars: {
        'input_type' => 'taxonomy',
        'search_term' => '-',
        'page' => 1
    }


}


search_terms = ['Red Bull', 'RedBull', 'Energidryck', 'Energidrycker']
search_terms.each do |search_term|

  pages << {
      page_type: 'products_search',
      method: 'GET',
      url: "https://www.willys.se/search?avoidCache=1549832350559&#{CGI.escape(search_term)}&size=30",
      vars: {
          'input_type' => 'search',
          'search_term' => search_term,
          'page' => 1
      }


  }

end