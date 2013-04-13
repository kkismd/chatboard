# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
config = {lifetime: '6s'}
window.color_table = [
   'white'
   'red'
   'cyan'
   'pink'
   'yellor'
   'lime'
]
chat_screen = -> $('#chat-screen')

color_name = (name) ->
  if name in color_table
    name
  else
    ''

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

go = (element, lifetime) ->
  move(element)
    .x(0 - (chat_screen().width() + $(element).width()))
    .duration(lifetime)
    .ease('linear')
    .end(-> $(element).remove())

window.new_comment = (text, color_code) ->
  color = color_name(color_code)
  comment = $('#template span.comment').clone()
  comment
    .text(text)
    .css(initial_position())
    .css({color: color})
  chat_screen().append(comment)
  go(comment.get(0), config.lifetime)

