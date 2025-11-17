class PixtaAdapter
  include HTTParty  
  base_uri "https://sandbox-api.pixta.jp/"
  headers  "Authorization" => "Bearer #{ENV['TNG_PIXTA_TOKEN']}"
  
  # id, name, url, tags
  def category_list(type="photo OR illustration")
    self.class.get("/categories", :query => {item_type: type})
  end

  # category, keyword, excludeKeyword, itemType, numFound, page, rows
  def category_search(category_id)
    self.class.get("/categories/#{category_id}/images")
  end

  #header values: keyword, excludeKeyword, numFound, page, rows
  # items value: id, title, itemType, thumbnailImages[small[width, height, margin, url], medium[width, height, margin, url]]
  def search(keyword)
    self.class.get("/images", :query => {keyword: keyword})
  end

  # header id
  # item details: id, title, comment, itemType, madeAt, removedAt, modelReleaseAcquisition, propertyReleaseAcquisition, freeDownload, tags
  # contributer informations: urlName, nickname, profilImageUrl
  # thumbnail infos: width, height, margin, url
  # item size informations: name, pricegroup, fileSize, fileTypes, width, height, dpi 
  # item variations: id, title, itemType, top3Tags, thumbnailImage
  # similar Items: items, url
  # items of the same model: items, url 
  def image_details(id)
    self.class.get("/images", :query => {id: id})
  end

  # status codes: 302: redirect to download, 400: invalid parameter, 403: invalid subscription license, 404: download failed, 500: unexpected error
  # download url is set in the header under location
  def download(id, size = "m")
    self.class.get("/images/download/{#id}", :query => {size: size})
  end
end