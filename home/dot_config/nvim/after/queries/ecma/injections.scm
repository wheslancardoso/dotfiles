; extends

; Auto-injeta sintaxe HTML em qualquer template literal JS/TS que contenha tags HTML
((template_string) @injection.content
  (#lua-match? @injection.content "^`%s*<")
  (#offset! @injection.content 0 1 0 -1)
  (#set! injection.include-children)
  (#set! injection.language "html"))
