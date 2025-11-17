
modal = $('#ajax-modal')

modal.find('.modal-title').text 'Chose a language'
modal.find('.modal-body').html '<%=  render "select_lang" %>'

modal.modal 'show'
