$(document).ready ->

  $(document).on 'change', "#pickup_image", (event) ->
    files = event.target.files
    image = files[0]
    reader = new FileReader()
    reader.onload = (file) ->
      img = new Image()
      img.src = file.target.result
      $('#previewImage').html(img).show()
      $('#originalImage').hide()
    reader.readAsDataURL(image)

  $(document).on 'click', ".clickable-preview", (event) ->
    $('#pickup_image').click()
