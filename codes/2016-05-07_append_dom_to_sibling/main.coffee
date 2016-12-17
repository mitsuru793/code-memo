log = (string) ->
  console.log(string)

appendBefore = (element, insertElement) ->
  element.parentNode.insertBefore(insertElement, element)

appendAfter = (element, insertElement) ->
  element.parentNode.insertBefore(insertElement, element.nextSibling)

createLi = do ->
  liEl = document.createElement('li')
  (string) ->
    newLiEl = liEl.cloneNode(false)
    newLiEl.innerText = string
    newLiEl

lis = document.querySelectorAll('#ul1 > li')
appendBefore(lis[0], createLi('0'))
appendAfter(lis[0], createLi('1.5'))
