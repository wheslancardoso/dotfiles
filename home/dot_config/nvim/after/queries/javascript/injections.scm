; extends

; Auto-injeta sintaxe HTML em qualquer template literal JS que comece com tag HTML
((template_string) @injection.content
  (#match? @injection.content "^`\\s*<")
  (#offset! @injection.content 0 1 0 -1)
  (#set! injection.include-children)
  (#set! injection.language "html"))
