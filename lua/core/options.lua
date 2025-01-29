vim.wo.number = true
vim.o.relativenumber = true
vim.o.clipboard = ""
vim.o.wrap = false
vim.o.linebreak = true
vim.o.mouse = ""
vim.o.autoindent = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.expandtab = true
vim.o.scrolloff = 10
vim.o.sidescrolloff = 10
vim.o.cursorline = false
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.hlsearch = false
vim.o.showmode = false
vim.opt.termguicolors = true
vim.o.whichwrap = "bs<>[]hl"
vim.o.numberwidth = 2
vim.o.swapfile = false
vim.o.smartindent = true
vim.o.showtabline = 2
vim.o.backspace = "indent,eol,start"
vim.o.pumheight = 10
vim.o.conceallevel = 0
vim.wo.signcolumn = "yes"
vim.o.fileencoding = "utf-8"
vim.o.cmdheight = 1
vim.o.breakindent = true
vim.o.updatetime = 100
vim.o.timeoutlen = 250
vim.o.ttimeoutlen = 0
vim.opt.redrawtime = 10000
vim.o.backup = false
vim.o.writebackup = false
vim.o.undofile = true
vim.o.undodir = vim.fn.stdpath("data") .. "/undo"
vim.o.completeopt = "menuone,noselect"
vim.opt.shortmess:append("c")
vim.opt.iskeyword:append("-")
vim.opt.formatoptions:remove({ "c", "r", "o" })
vim.opt.foldmethod = "marker"
vim.opt.foldmarker = "{{{,}}}"
vim.opt.lazyredraw = false
vim.opt.hidden = true
vim.opt.history = 10000
vim.opt.synmaxcol = 300
vim.opt.re = 0
vim.opt.guifont = "JetBrainsMono Nerd Font:h14"
vim.lsp.set_log_level("off")
vim.opt.fillchars = { eob = " " } -- Remove end-of-buffer tildes for speed
vim.cmd([[set nofixendofline]])
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.preselectSupport = false
capabilities.textDocument.completion.completionItem.insertReplaceSupport = false
