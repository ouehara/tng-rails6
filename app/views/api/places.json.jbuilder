json.array! @establishment do |place|
  json.id place.id
  json.area_id  place.area_id
  json.position  place.position
  json.category  place.category
  json.name  place.name
  json.description  place.description
  json.summary  place.summary
  json.url  place.url
  json.address  place.address
  json.official_text  place.official_text
  json.recommend_text  place.recommend_text
  json.published  place.published
  json.img_src  place.img_src
  json.maps  place.maps
  json.images do
    json.array! place.hotel_images do |img|
      json.id img.id
      json.image_file_name img.image_file_name
      json.url img.image.url(:medium)
    end
  end
  json.areaname place.area

end