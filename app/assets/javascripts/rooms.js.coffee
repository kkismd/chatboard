# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
config = {lifetime: '6s'}

chat_screen = -> $('#chat-screen')

initial_position = ->
  comments = $('#chat-screen span.comment')
  if comments.length > 0
    top = Math.max.apply(null, comments.map((i,c)->
      $(c).position().top + $(c).height()))
  else
    top = 0

  if top > chat_screen().height()
    top = Math.floor(Math.random() * chat_screen().height())

  left = chat_screen().width()
  {left: left, top: top}

window.new_comment = (text) ->
  comment = $('#template span.comment').clone()
  comment.text(text)
  comment.css(initial_position())
  chat_screen().append(comment)
  go(comment.get(0), config.lifetime)

window.go = (element, lifetime) ->
  move(element)
    .x(0 - (chat_screen().width() + $(element).width()))
    .duration(lifetime)
    .ease('linear')
    .end(-> $(element).remove())

