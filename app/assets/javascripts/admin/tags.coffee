$(document).on 'ready', ->
  $(document).on 'click', '#tagSearchButton', ->
    $('#ajax-modal .modal-title').html "Search tags"
    $('#ajax-modal .modal-body').html '
    <div class="input-group">
    <input type="text" name="query" class="form-control" id="modalSearchQuery" placeholder="Search for...">
    <span class="input-group-btn">
    <button type="button" class="btn btn-default" id="modalTagSearchButton">Go!</button>
    </span>
    </div>
    <div id="tagSearchResults"></div>
    '
    $('#ajax-modal').modal 'show'

  $(document).on 'click', '.result-tag-button', ->
    tagId = $(this).data "tag-id"
    tagName = $(this).data "tag-name"
    $('#tag_parent_id').val tagId
    $('.selected-parent-tag').remove()
    $('#tag_parent_id').after('<a class="btn selected-parent-tag" style="font-size: 14px;"><i class="icon-tag"></i> ' + tagName + '</a> ')
    $('#ajax-modal').modal 'hide'


  $(document).on 'click', '#modalTagSearchButton', ->
    query = $('#modalSearchQuery').val()
    return if query.length == 0

    $('#tagSearchResults').html '<center><i class="fa fa-spinner fa-spin fa-2x"></i></center>'

    $.ajax
      type: "GET"
      url: "/admin1500011/tags/search/" + $('#modalSearchQuery').val() + ".json"
      success: (data) ->
        resultHtml = ""
        if data.length > 0
          for tag in data
            resultHtml += '<button class="btn btn-default result-tag-button" data-tag-id=' + String(tag.id) + ' data-tag-name="' + tag.name + '">' + tag.name + '</button>'

        else
          resultHtml += 'Tag not found.'

        setTimeout ->
          $('#tagSearchResults').html resultHtml
        , 500
