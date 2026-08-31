vim.cmd("highlight clear")

if vim.fn.exists("syntax_on") == 1 then
  vim.cmd("syntax reset")
end

vim.g.colors_name = "mothline"
vim.o.background = "dark"

local palette = {
  void       = "#080a0c",
  background = "#0b0e10",
  surface    = "#111619",
  raised     = "#171d20",
  selection  = "#173b3a",
  text       = "#d8e2e1",
  dim        = "#7c8989",
  muted      = "#566263",
  red        = "#a92338",
  red_bright = "#e04759",
  teal       = "#25c7b7",
  cyan       = "#55dfd2",
  amber      = "#d7a84c",
  green      = "#70c48f",
}

local set = vim.api.nvim_set_hl

set(0, "Normal", {
  fg = palette.text,
  bg = palette.background,
})

set(0, "NormalNC", {
  fg = palette.text,
  bg = palette.void,
})

set(0, "NormalFloat", {
  fg = palette.text,
  bg = palette.surface,
})

set(0, "FloatBorder", {
  fg = palette.teal,
  bg = palette.surface,
})

set(0, "FloatTitle", {
  fg = palette.red_bright,
  bg = palette.surface,
  bold = true,
})

set(0, "Cursor", {
  fg = palette.background,
  bg = palette.cyan,
})

set(0, "CursorLine", {
  bg = palette.surface,
})

set(0, "CursorColumn", {
  bg = palette.surface,
})

set(0, "CursorLineNr", {
  fg = palette.cyan,
  bg = palette.surface,
  bold = true,
})

set(0, "LineNr", {
  fg = palette.muted,
  bg = palette.background,
})

set(0, "SignColumn", {
  fg = palette.dim,
  bg = palette.background,
})

set(0, "ColorColumn", {
  bg = "#102022",
})

set(0, "Visual", {
  fg = palette.text,
  bg = palette.selection,
})

set(0, "Search", {
  fg = palette.text,
  bg = palette.red,
  bold = true,
})

set(0, "IncSearch", {
  fg = palette.background,
  bg = palette.cyan,
  bold = true,
})

set(0, "CurSearch", {
  fg = palette.background,
  bg = palette.cyan,
  bold = true,
})

set(0, "MatchParen", {
  fg = palette.cyan,
  bg = palette.raised,
  bold = true,
})

set(0, "StatusLine", {
  fg = palette.background,
  bg = palette.teal,
  bold = true,
})

set(0, "StatusLineNC", {
  fg = palette.dim,
  bg = palette.surface,
})

set(0, "WinSeparator", {
  fg = palette.red,
  bg = palette.background,
})

set(0, "Pmenu", {
  fg = palette.text,
  bg = palette.surface,
})

set(0, "PmenuSel", {
  fg = palette.background,
  bg = palette.teal,
  bold = true,
})

set(0, "PmenuSbar", {
  bg = palette.raised,
})

set(0, "PmenuThumb", {
  bg = palette.red,
})

set(0, "Directory", {
  fg = palette.teal,
  bold = true,
})

set(0, "Title", {
  fg = palette.red_bright,
  bold = true,
})

set(0, "Question", {
  fg = palette.cyan,
  bold = true,
})

set(0, "MoreMsg", {
  fg = palette.teal,
})

set(0, "WarningMsg", {
  fg = palette.amber,
  bold = true,
})

set(0, "ErrorMsg", {
  fg = palette.red_bright,
  bold = true,
})

set(0, "ModeMsg", {
  fg = palette.cyan,
  bold = true,
})

set(0, "NonText", {
  fg = palette.muted,
})

set(0, "Whitespace", {
  fg = palette.muted,
})

set(0, "EndOfBuffer", {
  fg = palette.background,
  bg = palette.background,
})

set(0, "Comment", {
  fg = palette.dim,
  italic = true,
})

set(0, "Constant", {
  fg = palette.cyan,
})

set(0, "String", {
  fg = palette.teal,
})

set(0, "Identifier", {
  fg = palette.text,
})

set(0, "Function", {
  fg = palette.cyan,
})

set(0, "Statement", {
  fg = palette.red_bright,
})

set(0, "Keyword", {
  fg = palette.red_bright,
})

set(0, "Type", {
  fg = palette.teal,
})

set(0, "Special", {
  fg = palette.amber,
})

set(0, "Underlined", {
  fg = palette.cyan,
  underline = true,
})

set(0, "Todo", {
  fg = palette.background,
  bg = palette.amber,
  bold = true,
})

set(0, "SpellBad", {
  undercurl = true,
  sp = palette.red_bright,
})

set(0, "SpellCap", {
  undercurl = true,
  sp = palette.amber,
})

set(0, "SpellRare", {
  undercurl = true,
  sp = palette.teal,
})

set(0, "SpellLocal", {
  undercurl = true,
  sp = palette.cyan,
})

set(0, "WhichKey", {
  fg = palette.cyan,
  bold = true,
})

set(0, "WhichKeyGroup", {
  fg = palette.red_bright,
  bold = true,
})

set(0, "WhichKeyDesc", {
  fg = palette.text,
})

set(0, "WhichKeySeparator", {
  fg = palette.muted,
})

set(0, "WhichKeyNormal", {
  fg = palette.text,
  bg = palette.surface,
})
