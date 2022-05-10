let g:okbcard_altnoimage = "hogeno.png"

function! okblogcard#bcard_html(url, title, desc, img) abort

  let host = substitute(a:url, '\(^.*://.\{-}/\).*','\1',"")


  let cardtext = printf("
    \<div class='okblogcard-text'>
    \<p class='okblogcard-title'>%s</p>
    \<p class='okblogcard-description'>\n
    \%s\n
    \</p>
    \</div>" ,a:title ,a:desc)

  let cardfooter = printf("
    \<div class='okblogcard-footer'>
    \<img src='https://www.google.com/s2/favicons?domain=%s'
    \ alt='' width='16' height='16'>
    \%s
    \</div>
    \",a:url ,host)

  let cardimg = printf("
    \<div class='okblogcard-image'><div class='okblogcard-image-wrapper'>\n
    \  <img src='%s' alt='%s' width='100' height='56' loading='lazy'>\n
    \</div></div>
    \", a:img, a:title)

  let card = printf("
    \<figure class='okblogcard'>\n
    \  <a href='%s' target='_blank'>\n
    \    <div class='okblogcard-content'>\n
    \      %s\n
    \      %s\n
    \    </div>\n
    \    %s\n
    \  </a>\n
    \</figure>\n
    \</ br></ br>\n
    \", a:url, cardimg, cardtext, cardfooter)

  return card

endfunction


""""""""""""""""""""""""""""""""""""""""""""""
" github title
""""""""""""""""""""""""""""""""""""""""""""""
function! s:gh_title(dom) abort

  try
    let title = 
          \a:dom.childNode('head').
          \childNode('meta', {"property":"og:title"}).
          \attr.content
  catch
    let title = "unknown title"
  endtry

  let title = substitute(title, '\(^GitHub - .*\):.*','\1',"")

  return title

endfunction


""""""""""""""""""""""""""""""""""""""""""""""
" github description
""""""""""""""""""""""""""""""""""""""""""""""
function! s:gh_desc(dom) abort

  try
    let description = 
          \a:dom.childNode('head').
          \childNode('meta', {"property":"og:description"}).
          \attr.content
  catch
    let description = "no description"
  endtry

  let description = substitute(description, '\(^.*\) Contribute to .\{-} development by creating an account on GitHub.$','\1',"")

  return description

endfunction



""""""""""""""""""""""""""""""""""""""""""""""
" extract elements which we need
""""""""""""""""""""""""""""""""""""""""""""""
function! okblogcard#getelem(url) abort
  if a:url =~ "^https://github.com"
    let githubf = 1
  else
    let githubf = 0
  endif

  let dom = webapi#html#parseURL(a:url)

  """"""""""""""""""""""""""""""""""""""""""""""
  " title
  """"""""""""""""""""""""""""""""""""""""""""""
  if githubf

    let title = s:gh_title(dom)

  else
    try
      let title = 
            \dom.childNode('head').
            \childNode('meta', {"property":"og:title"}).
            \attr.content
    catch
      let title = "unknown title"
    endtry

  endif

  """"""""""""""""""""""""""""""""""""""""""""""
  " image
  """"""""""""""""""""""""""""""""""""""""""""""
  try
    let img = 
          \dom.childNode('head').
          \childNode('meta', {"property":"og:image"}).
          \attr.content
  catch
    let img = g:okbcard_altnoimage
  endtry

  """"""""""""""""""""""""""""""""""""""""""""""
  " description
  """"""""""""""""""""""""""""""""""""""""""""""
  if githubf
    let description = s:gh_desc(dom)
  else
    try
      let description = 
            \dom.childNode('head').
            \childNode('meta', {"property":"og:description"}).
            \attr.content
    catch
      let description = "no description"
    endtry
  endif

  return {'url'   : a:url,
        \ 'title' : title,
        \ 'img'   : img,
        \ 'desc'  : description}

endfunction

function! okblogcard#creatbcard(url) abort

  let elm = okblogcard#getelem(a:url)
  let res = okblogcard#bcard_html(elm.url, elm.title, elm.desc, elm.img)
  return(res)

endfunction

function! okblogcard#drawbcard() abort
  let url = trim(getline("."))
  let ans = split(okblogcard#creatbcard(url),"\n")
  call append(".", ans)
  execute ".delete"
endfunction

