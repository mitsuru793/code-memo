log = (str) ->
  console.log(str)

ul1 = document.getElementById('ul1')
for li in ul1.querySelectorAll('li')
  li.addEventListener('click', (e) ->
    log(li.innerText)
  )

ul2 = document.getElementById('ul2')
for li in ul2.querySelectorAll('li')
  li.addEventListener('click', do (li) ->
    (e) ->
      log(li.innerText)
  )

outer = ->
  x = 1
  ->
    log("outer: " + x)
    x = x + 1
myFunc = outer()
myFunc()
myFunc()
myFunc()

for i in [1..3]
  setTimeout(->
    log("setTimeout1: " + i)
  , 100)

for i in [1..3]
  setTimeout(do (i) ->
    ->
      log("setTimeout1: " + i)
  , 200)
