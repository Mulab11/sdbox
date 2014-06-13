# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

items = []
user = []
current_id = -1
timer = null
buff = {}
link_id = -1
chinese =
  test: "SD-BOX"
  renren: "人人"
  weibo: "微博"
  weixin: "微信"

printMessage = (id, name, time, text) ->
  div = $("#tab-#{id}")
  div.append """<p>#{name}(#{time.toLocaleString()})<br>#{text}</p>"""

badgeFresh = (id) ->
  cnt = items[id].cnt
  if cnt > 0
    if $("#badge-#{id}").length == 0
      $(".tree-node##{id}").append """<span class="badge" id="badge-#{id}">0</span>"""
      if $("#title-#{id}").length != 0
        $("#title-#{id}").prepend """<span class="badge" id="badge-title-#{id}">0</span>"""
    $("#badge-#{id}").html items[id].cnt
    $("#badge-title-#{id}").html items[id].cnt
  else
    $("#badge-#{id}").remove()
    $("#badge-title-#{id}").remove()

printCurrent = ->
  if current_id == -1
    return
  keys = []
  items[current_id].cnt = 0
  badgeFresh(current_id)
  current = buff[current_id]
  #console.log(current)
  if current == undefined
    return
  current.sort (a,b) ->
    #console.log(a)
    #console.log(b)
    if a.receive_time < b.receive_time
      return -1
    if a.receive_time > b.receive_time
      return 1
    return 0
  for cnt of current
    id = current[cnt].contact_item_id
    #console.log(id)
    #console.log(items[current_id])
    printMessage(current_id, user.contacts[items[current_id].contact_id].name, Date(current[cnt].receive_time), current[cnt].full_text)
  delete buff[current_id]

timerFunc = ->
  #console.log("tick")
  $.get "/receive", (data, status)->
    hasNew = false
    for message_id of data
      hasNew = true
      message = data[message_id]
      #console.log message
      id = message.contact_item_id
      #console.log(id)
      if buff[id] == undefined
        buff[id] = []
      buff[id].push message
      #console.log(buff[id])
      items[id].cnt += 1
      #console.log(items[id].cnt)
      badgeFresh(id)
      #console.log(buff)
    printCurrent()
    #if hasNew
    #  $('embed').remove()
    #  $('body').append('<embed src="/assets/notify.wav" autostart="true" hidden="true" loop="false" />')
  timer = setTimeout(timerFunc, 5000)

messageResize = ->
  $(".tab-content").height($(".col-md-8").height() - $(".input-group").height() - $(".nav-tabs").height() - 20)

treeInit = ->
  $(".tree li:has(ul)").addClass("parent_li").find(" > .tree-node").attr "title", "Collapse this branch"
  $(".tree li.parent_li > .tree-node").unbind()
  $(".tree li.parent_li > .tree-node").on "click", (e) ->
    children = $(this).parent("li.parent_li").find(" > ul > li")
    if children.is(":visible")
      children.hide "fast"
      $(this).attr("title", "Expand this branch").find(" > .glyphicon").addClass("glyphicon-plus").removeClass "glyphicon-minus"
    else
      children.show "fast"
      $(this).attr("title", "Collapse this branch").find(" > .glyphicon").addClass("glyphicon-minus").removeClass "glyphicon-plus"
    e.stopPropagation()

sendInit = ->
  $("#message-input").keydown (e)->
    if e.keyCode == 13
      $("#send").click()
  $("#send").click ->
    if current_id == -1 or $("#message-input").val() == ""
      return
    message = $("#message-input").val()
    printMessage(current_id, "我", new Date(), message)
    div = $("#tab-#{current_id}")
    div.scrollTop(div[0].scrollHeight)
    #console.log(div)
    $("#message-input").val("")
    $.post "/send/#{current_id}.json",
      message: message
    ,(data, status)->
      #console.log(data)
      if status != "success" or data.result != "success"
        alert "“#{message}”发送失败"

treeNode = 0

aloneInit = (id) ->
  #console.log "aloneInit"
  $("#item-#{id}").children(".glyphicon-open").click ->
    #console.log "click"
    $.get "/contact_items/alone/#{id}.json", (data, status)->
      #console.log "get"
      if status != "success"
        return
      #console.log "succ"
      contact_id = items[id].contact_id
      contact = user.contacts[contact_id]
      delete contact.items[id]
      $("#contact-#{contact_id}").remove()
      data.items = {}
      data.items[id] = items[id]
      items[id].contact_id = data.id
      console.log data
      user.contacts[data.id] = data
      treeNode contact_id, contact
      if contact_id == link_id
        linkCheck $("#contact-#{contact_id}").children(".link-icon"), true
      treeNode data.id, data
      treeInit()

linkInit = 0

treeNode = (id, contact) ->
  cnt = 0
  for i of contact.items
    cnt += 1
  console.log "id = #{id} cnt = #{cnt}"
  if cnt > 1
    $("#tree-base").append """
      <li id="contact-#{id}">
        <span class="tree-node">
          <span class="glyphicon glyphicon-minus" />
          #{contact.name}
        </span>
        <span class="glyphicon glyphicon-link link-icon" />
        <ul></ul>
      </li>
    """
    for i of contact.items
      item = contact.items[i]
      $("#contact-#{id}").children("ul").append """
        <li id="item-#{i}">
          <span class="tree-node leaf-node" id=#{i}>
            #{chinese[user.platforms[contact.items[i].platform_id].kind]}
          </span>
          <span class="glyphicon glyphicon-open"/>
          #{item.name}
        </li>
      """
      aloneInit(i)
  else if cnt == 1
    for i of contact.items
      console.log(i)
      $("#tree-base").append """
        <li id="contact-#{id}" id="item-#{i}">
          <span class="tree-node leaf-node" id="#{i}">
            #{contact.name}
          </span>
          <span class="glyphicon glyphicon-link link-icon" />
          #{chinese[user.platforms[contact.items[i].platform_id].kind]}
        </li>
      """
  linkInit id

linkCheck = (div, status)->
  if status
    div.removeClass("glyphicon-link")
    div.addClass("glyphicon-ok")
  else
    div.removeClass("glyphicon-ok")
    div.addClass("glyphicon-link")

linkInit = (contact_id)->
  $("#contact-#{contact_id}").children(".link-icon").click ->
    console.log "link_id = #{link_id} contact_id = #{contact_id}"
    if link_id == -1
      link_id = contact_id
      linkCheck $(this), true
      return
    if link_id == contact_id
      link_id = -1
      linkCheck $(this), false
      return
    $.get "contacts/join?fath=#{link_id}&son=#{contact_id}"
    , (data, status)->
        if status != "success"
          alert("合并失败")
          return
        $("#contact-#{contact_id}").remove()
        $("#contact-#{link_id}").remove()
        for item_id of user.contacts[contact_id].items
          user.contacts[link_id].items[item_id] = user.contacts[contact_id].items[item_id]
          items[item_id] = user.contacts[link_id].items[item_id]
          items[item_id].contact_id = link_id
        contact = user.contacts[link_id]
        treeNode link_id, contact
        linkCheck($("#contact-#{link_id}").children(".link-icon"), true)
        treeInit()

userInit = ->
  $.get "/users/get_all.json", (data, status)->
    #console.log(status)
    user = data
    console.log(data)
    for contact_id of user.contacts
      contact = data.contacts[contact_id]
      for item_id of contact.items
        items[item_id] = contact.items[item_id]
        items[item_id].contact_id = contact_id
        items[item_id].cnt = 0
      treeNode contact_id, contact
    $(".leaf-node").click ->
      id = $(this).attr("id")
      if $("#tab-#{id}").length == 0
        $("#message-tab").append """
          <li>
            <a data-toggle="tab" href="#tab-#{id}" id="title-#{id}">
              #{user.contacts[items[id].contact_id].name} 
              <span class="glyphicon glyphicon-remove" id="exit-#{id}">
              </span>
            </a>
          </li>
        """
        $("#message-pool").append """
          <div class="tab-pane fade scroll" id="tab-#{id}"></div>
        """
        $("#exit-#{id}").click ->
          if $("#tab-#{id}").hasClass("active")
            $("#title-home").click()
          $(this).parent().parent().remove()
          $("#tab-#{id}").remove()
        $("#title-#{id}").click ->
          current_id = id
          printCurrent()
      $("#title-#{id}").click()
      #console.log(user)
    treeInit()

homeInit = ->
  $("#title-home").click ->
    current_id = -1

$(document).ready ->
  timer = setTimeout(timerFunc, 5000)
  homeInit()
  messageResize()
  $(window).resize ->
    messageResize()
  sendInit()
  userInit()

