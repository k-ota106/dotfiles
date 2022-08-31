"call GuiLinespace(1)
"call GuiTabline(1)
"call GuiPopmenu(1)
"call GuiTreeviewShow(1)
"call GuiScrollbar(1)

GuiLinespace    1
GuiTabline      1
GuiPopupmenu    1
"GuiTreeviewShow
GuiScrollBar    1




" Enable Mouse
set mouse=a

"" Set Editor Font
"if exists(':GuiFont')
"    " Use GuiFont! to ignore font errors
"    GuiFont {font_name}:h{size}
"endif

" Disable GUI Tabline
if exists(':GuiTabline')
    GuiTabline 0
endif

" Disable GUI Popupmenu
if exists(':GuiPopupmenu')
    GuiPopupmenu 0
endif

" Enable GUI ScrollBar
if exists(':GuiScrollBar')
    GuiScrollBar 1
endif

" Right Click Context Menu (Copy-Cut-Paste)
nnoremap <silent><RightMouse> :call GuiShowContextMenu()<CR>
inoremap <silent><RightMouse> <Esc>:call GuiShowContextMenu()<CR>
xnoremap <silent><RightMouse> :call GuiShowContextMenu()<CR>gv
snoremap <silent><RightMouse> <C-G>:call GuiShowContextMenu()<CR>gv

