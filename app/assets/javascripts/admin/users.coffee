$(document).ready ->

  $(document).on 'change', "#user_avatar", (event) ->
    files = event.target.files
    image = files[0]
    reader = new FileReader()
    reader.onload = (file) ->
      img = new Image()
      img.src = file.target.result
      $('#previewAvatar').html(img).show()
      $('#originalAvatar').hide()
    reader.readAsDataURL(image)

  $(document).on 'click', ".clickable-avatar", (event) ->
    $('#user_avatar').click()
