# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

items = []
user = []

$(document).ready ->
  $(".tree li:has(ul)").addClass("parent_li").find(" > span").attr "title", "Collapse this branch"
  $(".tree li.parent_li > span").on "click", (e) ->
    children = $(this).parent("li.parent_li").find(" > ul > li")
    if children.is(":visible")
      children.hide "fast"
      $(this).attr("title", "Expand this branch").find(" > i").addClass("glyphicon-plus").removeClass "glyphicon-minus"
    else
      children.show "fast"
      $(this).attr("title", "Collapse this branch").find(" > i").addClass("glyphicon-minus").removeClass "glyphicon-plus"
    e.stopPropagation()
  $(".tab-content").height($(".col-md-8").height() - $(".input-group").height() - $(".nav-tabs").height() - 20)
  $.get "/users/get_all.json", (data, status)->
    console.log(data)
    user = data
    for contact_id of data.contacts
      contact = data.contacts[contact_id]
      for item_id of contact.items
        items[item_id] = contact.items[item_id]
        items[item_id]["contact_id"] = contact_id
    console.log(items)
    $(".leaf-node").click ->
      id = $(this).attr("id")
      $("#message-tab").append("""<li><a data-toggle="tab" href="#tab-#{id}" id="title-#{id}">#{user.contacts[items[id].contact_id].name}</a></li>""")
      $("#message-pool").append("""<div class="tab-pane fade scroll" id="tab-#{id}"></div>""")
      $("#title-#{id}").click()


