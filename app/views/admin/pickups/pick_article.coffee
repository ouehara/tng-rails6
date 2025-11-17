
modal = $('#ajax-modal')

modal.find('.modal-title').text 'Pick an article!'
modal.find('.modal-body').html '<%= escape_javascript render "pick_article" %>'

modal.modal 'show'
