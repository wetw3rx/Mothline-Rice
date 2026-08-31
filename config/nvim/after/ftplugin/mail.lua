vim.opt_local.spell = true
vim.opt_local.spelllang = "en_us"
vim.opt_local.textwidth = 72
vim.opt_local.colorcolumn = "73"
vim.opt_local.wrap = true
vim.opt_local.linebreak = true

local map = vim.keymap.set
local base_options = {
  buffer = true,
  silent = true,
}

map(
  "n",
  "<leader>w",
  "<cmd>write<cr>",
  vim.tbl_extend("force", base_options, {
    desc = "Save email",
  })
)

map(
  "n",
  "<leader>q",
  "<cmd>wq<cr>",
  vim.tbl_extend("force", base_options, {
    desc = "Save and return to NeoMutt",
  })
)

map(
  "n",
  "<leader>f",
  "gqap",
  vim.tbl_extend("force", base_options, {
    desc = "Format paragraph",
  })
)

map(
  "v",
  "<leader>f",
  "gq",
  vim.tbl_extend("force", base_options, {
    desc = "Format selection",
  })
)

-- MOTHLINE MAIL PRESENTATION
vim.opt_local.cursorline = true

local highlight = vim.api.nvim_set_hl

highlight(0, "mailHeaderKey", {
  fg = "#25c7b7",
  bold = true,
})

highlight(0, "mailHeader", {
  fg = "#55dfd2",
})

highlight(0, "mailSubject", {
  fg = "#e04759",
  bold = true,
})

highlight(0, "mailQuoted1", {
  fg = "#7c8989",
  italic = true,
})

highlight(0, "mailQuoted2", {
  fg = "#566263",
  italic = true,
})

highlight(0, "mailQuoted3", {
  fg = "#25c7b7",
  italic = true,
})

highlight(0, "mailQuoted4", {
  fg = "#7c8989",
  italic = true,
})

highlight(0, "mailQuoted5", {
  fg = "#566263",
  italic = true,
})

highlight(0, "mailQuoted6", {
  fg = "#25c7b7",
  italic = true,
})

highlight(0, "mailSignature", {
  fg = "#566263",
  italic = true,
})

highlight(0, "MothlineStatusTitle", {
  fg = "#0b0e10",
  bg = "#a92338",
  bold = true,
})

highlight(0, "MothlineStatusMode", {
  fg = "#0b0e10",
  bg = "#25c7b7",
  bold = true,
})

highlight(0, "MothlineStatusInfo", {
  fg = "#d8e2e1",
  bg = "#171d20",
})

highlight(0, "MothlineTrailingSpace", {
  bg = "#5a1825",
})

vim.opt_local.statusline =
  "%#MothlineStatusTitle# MOTHLINE // MAIL COMPOSER " ..
  "%#MothlineStatusMode# %{mode()} " ..
  "%#MothlineStatusInfo# %f %m " ..
  "%= SPELL:%{&spell?'ON':'OFF'}  %l:%c "

if not vim.b.mothline_trailing_space_match then
  vim.b.mothline_trailing_space_match =
    vim.fn.matchadd("MothlineTrailingSpace", [[\s\+$]])
end
