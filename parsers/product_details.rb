data = JSON.parse(content)

promotion = data['potentialPromotions'][0]['cartLabel'] rescue ""

availability = data['outOfStock'] == true ? '' : '1'
item_size_info = data['displayVolume']

price = data['priceValue']

category = data['breadCrumbs'][3]['name']

description = data['description'].gsub(/[\n\s]+/, ' ').gsub(/,/, '.') rescue ''


regexps = [
    /(\d*[\.,]?\d+)\s?([Ff][Ll]\.?\s?[Oo][Zz])/,
    /(\d*[\.,]?\d+)\s?([Oo][Zz])/,
    /(\d*[\.,]?\d+)\s?([Ff][Oo])/,
    /(\d*[\.,]?\d+)\s?([Ee][Aa])/,
    /(\d*[\.,]?\d+)\s?([Ff][Zz])/,
    /(\d*[\.,]?\d+)\s?(Fluid Ounces?)/,
    /(\d*[\.,]?\d+)\s?([Oo]unce)/,
    /(\d*[\.,]?\d+)\s?([Mm][Ll])/,
    /(\d*[\.,]?\d+)\s?([Cc][Ll])/,
    /(\d*[\.,]?\d+)\s?([Ll])/,
    /(\d*[\.,]?\d+)\s?([Gg])/,
    /(\d*[\.,]?\d+)\s?([Ll]itre)/,
    /(\d*[\.,]?\d+)\s?([Ss]ervings)/,
    /(\d*[\.,]?\d+)\s?([Pp]acket\(?s?\)?)/,
    /(\d*[\.,]?\d+)\s?([Cc]apsules)/,
    /(\d*[\.,]?\d+)\s?([Tt]ablets)/,
    /(\d*[\.,]?\d+)\s?([Tt]ubes)/,
    /(\d*[\.,]?\d+)\s?([Cc]hews)/,
    /(\d*[\.,]?\d+)\s?([Mm]illiliter)/i,
]
regexps.find {|regexp| item_size_info =~ regexp}
item_size = $1
uom = $2


regexps = [
    /(\d+)\s?[xX]/,
    /Pack of (\d+)/,
    /Box of (\d+)/,
    /Case of (\d+)/,
    /(\d+)\s?[Cc]ount/,
    /(\d+)\s?[Cc][Tt]/,
    /(\d+)\s?[Pp]/,
    /(\d+)[\s-]?Pack($|[^e])/,
    /(\d+)[\s-]pack($|[^e])/,
    /(\d+)[\s-]?[Pp]ak($|[^e])/,
    /(\d+)[\s-]?Tray/,
    /(\d+)\s?[Pp][Kk]/,
    /(\d+)\s?([Ss]tuks)/i,
    /(\d+)\s?([Pp]ak)/i,
    /(\d+)\s?([Pp]ack)/i,
]
regexps.find {|regexp| item_size_info =~ regexp}
in_pack = $1
in_pack ||= '1'


product_details = {
    # - - - - - - - - - - -
    RETAILER_ID: '101',
    RETAILER_NAME: 'hemkop',
    GEOGRAPHY_NAME: 'SE',
    # - - - - - - - - - - -
    SCRAPE_INPUT_TYPE: page['vars']['input_type'],
    SCRAPE_INPUT_SEARCH_TERM: page['vars']['search_term'],
    SCRAPE_INPUT_CATEGORY: page['vars']['input_type'] == 'taxonomy' ? category : '-',
    SCRAPE_URL_NBR_PRODUCTS: page['vars']['scrape_url_nbr_products'],
    # - - - - - - - - - - -
    SCRAPE_URL_NBR_PROD_PG1: page['vars']['nbr_products_pg1'],
    # - - - - - - - - - - -
    PRODUCT_BRAND: data['manufacturer'],
    PRODUCT_RANK: page['vars']['product_rank'],
    PRODUCT_PAGE: page['vars']['page'],
    PRODUCT_ID: data['code'],
    PRODUCT_NAME: data['name'],
    EAN: data['ean'],
    PRODUCT_DESCRIPTION: description,
    PRODUCT_MAIN_IMAGE_URL: data['image']['url'],
    PRODUCT_ITEM_SIZE: item_size,
    PRODUCT_ITEM_SIZE_UOM: uom,
    PRODUCT_ITEM_QTY_IN_PACK: in_pack,
    SALES_PRICE: price,
    IS_AVAILABLE: availability,
    PROMOTION_TEXT: promotion,
    EXTRACTED_ON:Time.now.to_s
}

product_details['_collection'] = 'products'

outputs<<product_details

