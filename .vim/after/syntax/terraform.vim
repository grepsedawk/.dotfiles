unlet b:current_syntax
syn include @BASH syntax/sh.vim
syn region scriptHeredoc start=/\v\<\<SCRIPT/ end=/SCRIPT/ keepend contains=@BASH
let b:current_syntax = "terraform"
