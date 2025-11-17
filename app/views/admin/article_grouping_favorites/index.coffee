
modal = $('#ajax-modal')

modal.find('.modal-title').text 'Create Favorite'
modal.find('.modal-body').html '<%= escape_javascript render "form" %>'

modal.modal 'show'
