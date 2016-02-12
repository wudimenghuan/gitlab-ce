# Quick Submit behavior
#
# When a child field of a form with a `js-quick-submit` class receives a
# "Meta+Enter" (Mac) or "Ctrl+Enter" (Linux/Windows) key combination, the form
# is submitted.
#
#= require extensions/jquery
#
# ### Example Markup
#
#   <form action="/foo" class="js-quick-submit">
#     <input type="text" />
#     <textarea></textarea>
#     <input type="submit" value="Submit" />
#   </form>
#
isMac = ->
  navigator.userAgent.match(/Macintosh/)

keyCodeIs = (e, keyCode) ->
  return false if (e.originalEvent && e.originalEvent.repeat) || e.repeat
  return e.keyCode == keyCode

$(document).on 'keydown.quick_submit', '.js-quick-submit', (e) ->
  return unless keyCodeIs(e, 13) # Enter

  if isMac()
    return unless (e.metaKey && !e.altKey && !e.ctrlKey && !e.shiftKey)
  else
    return unless (e.ctrlKey && !e.altKey && !e.metaKey && !e.shiftKey)

  e.preventDefault()

  $form = $(e.target).closest('form')
  $form.find('input[type=submit], button[type=submit]').disable()
  $form.submit()
