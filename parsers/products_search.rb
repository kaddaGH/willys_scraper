data = JSON.parse(content)
scrape_url_nbr_products = data['pagination']['totalNumberOfResults'].to_i
current_page = data['pagination']['currentPage'].to_i
page_size = data['pagination']['pageSize'].to_i
number_of_pages = data['pagination']['numberOfPages'].to_i
products = data['results']


# if ot's first page , generate pagination
if current_page == 0 and number_of_pages > 1
  nbr_products_pg1 = products.length
  step_page = 1
  while step_page < number_of_pages

    pages << {
        page_type: 'products_search',
        method: 'GET',
        url: page['url'].gsub(/page=0/, "page=#{step_page}"),
        vars: {
            'input_type' => page['vars']['input_type'],
            'search_term' => page['vars']['search_term'],
            'page' => step_page,
            'nbr_products_pg1' => nbr_products_pg1
        }
    }

    step_page = step_page + 1


  end
elsif current_page == 0 and number_of_pages == 1
  nbr_products_pg1 = products.length
else
  nbr_products_pg1 = page['vars']['nbr_products_pg1']
end


products.each_with_index do |product, i|

  pages << {
      page_type: 'product_details',
      method: 'GET',
      url: "https://www.willys.se/axfood/rest/p/#{product['code']}?search_term=#{page['vars']['search_term']}&page=#{current_page + 1}&rank=#{ i + 1}",
      vars: {
          'input_type' => page['vars']['input_type'],
          'search_term' => page['vars']['search_term'],
          'product_rank' => i + 1,
          'page' => current_page + 1,
          'nbr_products_pg1' => nbr_products_pg1,
          'scrape_url_nbr_products' => scrape_url_nbr_products

      }
  }


end

