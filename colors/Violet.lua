local M = {}

local colors = {
	none = "NONE",

	bg = "#030208",
	bg_alt = "#070510",
	bg_float = "#070510",
	bg_highlight = "#0A0812",

	border = "#231B38",
	border_active = "#9D6BFF",

	selection = "#2B1E52",
	cursor = "#B26BFF",
	url = "#D7C1FF",

	fg = "#F2EEFF",
	fg_dark = "#E9E5F7",
	fg_muted = "#B6B0CC",
	fg_inactive = "#8A81A6",

	comment = "#6E6688",
	line_nr = "#4C4368",
	whitespace = "#241B3A",
	indent = "#170F2E",

	red = "#FF6B8D",
	lred = "#FF8FAE",

	orange = "#B26BFF",

	yellow = "#FFC966",
	lyellow = "#FFDA8A",

	green = "#4FD39B",
	lgreen = "#82EFC0",

	cyan = "#71D2E8",
	lcyan = "#98E3F4",

	blue = "#83A7FF",
	lblue = "#A7C0FF",

	purple = "#B26BFF",
	lpurple = "#D0A4FF",

	magenta = "#B26BFF",
	lmagenta = "#D0A4FF",

	accent = "#B26BFF",
	accent_dark = "#7C3AED",

	gray0 = "#070510",
	gray1 = "#0A0812",
	gray2 = "#120C20",
	gray3 = "#1A1230",
	gray4 = "#231B38",
	gray5 = "#2B1E52",
	gray6 = "#372E4D",
	gray7 = "#8A81A6",
	gray8 = "#B6B0CC",
	gray9 = "#E9E5F7",
	gray10 = "#FFFFFF",

	error_bg = "#170710",
	warn_bg = "#1A1206",
	info_bg = "#04131A",
	hint_bg = "#0B101F",

	diff_add = "#0A1A12",
	diff_delete = "#190711",
	diff_change = "#120C24",
	diff_text = "#2B1E52",
}

function M.colorscheme()
	vim.cmd("highlight clear")
	vim.cmd("syntax reset")

	vim.o.background = "dark"
	vim.g.colors_name = "Violet"

	local set = vim.api.nvim_set_hl

	-- Base UI
	set(0, "Normal", { fg = colors.fg, bg = colors.bg })
	set(0, "NormalFloat", { fg = colors.fg_dark, bg = colors.bg_float })
	set(0, "FloatBorder", { fg = colors.gray6, bg = colors.bg_float })
	set(0, "FloatTitle", { fg = colors.fg_muted, bg = colors.bg_float, bold = true })

	set(0, "Cursor", { fg = colors.bg, bg = colors.cursor })
	set(0, "lCursor", { link = "Cursor" })
	set(0, "TermCursor", { link = "Cursor" })

	set(0, "CursorLine", { bg = colors.gray1 })
	set(0, "CursorColumn", { bg = colors.gray1 })
	set(0, "CursorLineNr", { fg = colors.accent, bold = true })

	set(0, "LineNr", { fg = colors.line_nr })
	set(0, "SignColumn", { bg = colors.bg })
	set(0, "ColorColumn", { bg = colors.gray1 })

	set(0, "Visual", { bg = colors.selection })
	set(0, "VisualNOS", { link = "Visual" })

	set(0, "Search", { fg = colors.bg, bg = colors.accent, bold = true })
	set(0, "IncSearch", { link = "Search" })
	set(0, "CurSearch", { link = "Search" })
	set(0, "WildMenu", { fg = colors.bg, bg = colors.accent })

	set(0, "StatusLine", { fg = colors.fg_dark, bg = colors.gray1 })
	set(0, "StatusLineNC", { fg = colors.fg_inactive, bg = colors.gray0 })

	set(0, "VertSplit", { fg = colors.gray4 })
	set(0, "WinSeparator", { fg = colors.gray4 })

	set(0, "TabLine", { fg = colors.fg_inactive, bg = colors.gray0 })
	set(0, "TabLineSel", { fg = colors.fg, bg = colors.gray2, bold = true })
	set(0, "TabLineFill", { bg = colors.bg })

	set(0, "Folded", { fg = colors.fg_muted, bg = colors.gray1, italic = true })
	set(0, "FoldColumn", { fg = colors.line_nr, bg = colors.bg })

	set(0, "Whitespace", { fg = colors.whitespace })
	set(0, "NonText", { fg = colors.gray6 })
	set(0, "EndOfBuffer", { fg = colors.gray4 })
	set(0, "Conceal", { fg = colors.gray6 })

	set(0, "MatchParen", { fg = colors.accent, bold = true, underline = true })

	set(0, "Title", { fg = colors.fg, bold = true })
	set(0, "Bold", { bold = true })
	set(0, "Italic", { italic = true })
	set(0, "Underlined", { underline = true })

	set(0, "Error", { fg = colors.red, bg = colors.error_bg })
	set(0, "ErrorMsg", { fg = colors.red, bold = true })
	set(0, "WarningMsg", { fg = colors.yellow, bold = true })
	set(0, "ModeMsg", { fg = colors.fg_muted })
	set(0, "MoreMsg", { fg = colors.green })
	set(0, "Question", { fg = colors.cyan })

	-- Syntax
	set(0, "Comment", { fg = colors.comment, italic = true })
	set(0, "SpecialComment", { fg = colors.comment, italic = true, bold = true })

	set(0, "Constant", { fg = colors.lpurple })
	set(0, "String", { fg = colors.green })
	set(0, "Character", { fg = colors.lgreen })
	set(0, "Number", { fg = colors.yellow })
	set(0, "Boolean", { fg = colors.yellow })
	set(0, "Float", { fg = colors.lyellow })

	set(0, "Identifier", { fg = colors.blue })
	set(0, "Function", { fg = colors.blue })

	set(0, "Statement", { fg = colors.purple })
	set(0, "Conditional", { fg = colors.purple })
	set(0, "Repeat", { fg = colors.purple })
	set(0, "Label", { fg = colors.purple })
	set(0, "Operator", { fg = colors.fg_muted })
	set(0, "Keyword", { fg = colors.purple })
	set(0, "Exception", { fg = colors.red })

	set(0, "Type", { fg = colors.cyan })
	set(0, "StorageClass", { fg = colors.purple })
	set(0, "Structure", { fg = colors.cyan })
	set(0, "Typedef", { fg = colors.cyan })

	set(0, "Special", { fg = colors.lpurple })
	set(0, "SpecialChar", { fg = colors.purple })
	set(0, "Tag", { fg = colors.red })
	set(0, "Delimiter", { fg = colors.fg_muted })

	set(0, "PreProc", { fg = colors.lpurple })
	set(0, "Include", { fg = colors.purple })
	set(0, "Define", { fg = colors.purple })
	set(0, "Macro", { fg = colors.purple })
	set(0, "PreCondit", { fg = colors.purple })

	set(0, "Debug", { fg = colors.yellow })
	set(0, "Ignore", { fg = colors.gray5 })
	set(0, "Todo", { fg = colors.yellow, bold = true, italic = true })

	-- Treesitter
	local ts = {
		["@comment"] = { link = "Comment" },
		["@comment.note"] = { fg = colors.blue, italic = true },
		["@comment.warning"] = { fg = colors.yellow, italic = true },
		["@comment.error"] = { fg = colors.red, italic = true },
		["@comment.todo"] = { fg = colors.purple, italic = true },

		["@error"] = { link = "Error" },
		["@none"] = { fg = colors.fg },

		["@text"] = { fg = colors.fg },
		["@text.reference"] = { fg = colors.lblue, underline = true },
		["@text.todo"] = { fg = colors.yellow, bold = true },
		["@text.note"] = { fg = colors.blue, italic = true },
		["@text.warning"] = { fg = colors.yellow, italic = true },
		["@text.danger"] = { fg = colors.red, italic = true },
		["@text.uri"] = { fg = colors.url, underline = true },
		["@text.literal"] = { fg = colors.green },
		["@text.strong"] = { bold = true },
		["@text.emphasis"] = { italic = true },
		["@text.underline"] = { underline = true },
		["@text.title"] = { fg = colors.blue, bold = true },

		["@variable"] = { fg = colors.fg },
		["@variable.builtin"] = { fg = colors.lblue, italic = true },
		["@variable.parameter"] = { fg = colors.fg_dark },
		["@variable.parameter.builtin"] = { fg = colors.lblue, italic = true },
		["@variable.member"] = { fg = colors.cyan },

		["@constant"] = { fg = colors.lpurple },
		["@constant.builtin"] = { fg = colors.lpurple },
		["@constant.macro"] = { fg = colors.purple },

		["@module"] = { fg = colors.lblue },
		["@module.builtin"] = { fg = colors.lblue },
		["@label"] = { fg = colors.purple },

		["@string"] = { fg = colors.green },
		["@string.documentation"] = { fg = colors.lgreen, italic = true },
		["@string.regexp"] = { fg = colors.lcyan },
		["@string.escape"] = { fg = colors.lcyan },
		["@string.special"] = { fg = colors.lcyan },
		["@string.special.symbol"] = { fg = colors.lpurple },
		["@string.special.url"] = { fg = colors.url, underline = true },

		["@character"] = { fg = colors.lgreen },
		["@character.special"] = { fg = colors.lcyan },

		["@boolean"] = { fg = colors.yellow },
		["@number"] = { fg = colors.yellow },
		["@number.float"] = { fg = colors.lyellow },
		["@float"] = { fg = colors.lyellow },

		["@function"] = { fg = colors.blue },
		["@function.builtin"] = { fg = colors.lblue },
		["@function.call"] = { fg = colors.blue },
		["@function.macro"] = { fg = colors.purple },
		["@function.method"] = { fg = colors.blue },
		["@function.method.call"] = { fg = colors.blue },

		["@constructor"] = { fg = colors.purple },
		["@operator"] = { fg = colors.fg_muted },

		["@keyword"] = { fg = colors.purple },
		["@keyword.function"] = { fg = colors.purple },
		["@keyword.operator"] = { fg = colors.purple },
		["@keyword.import"] = { fg = colors.purple },
		["@keyword.type"] = { fg = colors.purple },
		["@keyword.modifier"] = { fg = colors.purple },
		["@keyword.return"] = { fg = colors.purple },
		["@keyword.debug"] = { fg = colors.purple },
		["@keyword.exception"] = { fg = colors.red },
		["@keyword.conditional"] = { fg = colors.purple },
		["@keyword.repeat"] = { fg = colors.purple },
		["@keyword.include"] = { fg = colors.purple },
		["@keyword.directive"] = { fg = colors.purple },
		["@keyword.directive.define"] = { fg = colors.purple },
		["@keyword.storage"] = { fg = colors.purple },
		["@keyword.struct"] = { fg = colors.cyan },
		["@keyword.enum"] = { fg = colors.cyan },
		["@keyword.await"] = { fg = colors.purple },
		["@keyword.async"] = { fg = colors.purple },
		["@keyword.ternary"] = { fg = colors.purple },

		["@type"] = { fg = colors.cyan },
		["@type.builtin"] = { fg = colors.cyan },
		["@type.definition"] = { fg = colors.cyan },
		["@type.qualifier"] = { fg = colors.purple },

		["@attribute"] = { fg = colors.purple },
		["@property"] = { fg = colors.cyan },
		["@field"] = { fg = colors.cyan },

		["@punctuation.bracket"] = { fg = colors.fg_muted },
		["@punctuation.delimiter"] = { fg = colors.fg_muted },
		["@punctuation.special"] = { fg = colors.purple },

		["@markup.heading"] = { fg = colors.blue, bold = true },
		["@markup.heading.1"] = { fg = colors.blue, bold = true },
		["@markup.heading.2"] = { fg = colors.lblue, bold = true },
		["@markup.heading.3"] = { fg = colors.purple, bold = true },
		["@markup.heading.4"] = { fg = colors.lpurple, bold = true },
		["@markup.raw"] = { fg = colors.green },
		["@markup.raw.block"] = { fg = colors.fg_dark },
		["@markup.link"] = { fg = colors.lblue, underline = true },
		["@markup.link.label"] = { fg = colors.purple },
		["@markup.link.url"] = { fg = colors.url, underline = true },
		["@markup.strong"] = { bold = true },
		["@markup.italic"] = { italic = true },
		["@markup.underline"] = { underline = true },
		["@markup.list"] = { fg = colors.purple },
		["@markup.quote"] = { fg = colors.comment, italic = true },
		["@markup.math"] = { fg = colors.lpurple },

		["@diff.plus"] = { fg = colors.green },
		["@diff.minus"] = { fg = colors.red },
		["@diff.delta"] = { fg = colors.yellow },

		["@tag"] = { fg = colors.red },
		["@tag.attribute"] = { fg = colors.purple },
		["@tag.delimiter"] = { fg = colors.fg_muted },
	}

	for group, opts in pairs(ts) do
		set(0, group, opts)
	end

	-- LSP / Diagnostics
	set(0, "DiagnosticError", { fg = colors.red })
	set(0, "DiagnosticWarn", { fg = colors.yellow })
	set(0, "DiagnosticInfo", { fg = colors.cyan })
	set(0, "DiagnosticHint", { fg = colors.blue })
	set(0, "DiagnosticOk", { fg = colors.green })

	set(0, "DiagnosticVirtualTextError", { fg = colors.red, bg = colors.error_bg })
	set(0, "DiagnosticVirtualTextWarn", { fg = colors.yellow, bg = colors.warn_bg })
	set(0, "DiagnosticVirtualTextInfo", { fg = colors.cyan, bg = colors.info_bg })
	set(0, "DiagnosticVirtualTextHint", { fg = colors.blue, bg = colors.hint_bg })

	set(0, "DiagnosticUnderlineError", { sp = colors.red, undercurl = true })
	set(0, "DiagnosticUnderlineWarn", { sp = colors.yellow, undercurl = true })
	set(0, "DiagnosticUnderlineInfo", { sp = colors.cyan, undercurl = true })
	set(0, "DiagnosticUnderlineHint", { sp = colors.blue, undercurl = true })

	set(0, "DiagnosticFloatingError", { fg = colors.red, bg = colors.bg_float })
	set(0, "DiagnosticFloatingWarn", { fg = colors.yellow, bg = colors.bg_float })
	set(0, "DiagnosticFloatingInfo", { fg = colors.cyan, bg = colors.bg_float })
	set(0, "DiagnosticFloatingHint", { fg = colors.blue, bg = colors.bg_float })

	set(0, "DiagnosticSignError", { fg = colors.red, bg = colors.bg })
	set(0, "DiagnosticSignWarn", { fg = colors.yellow, bg = colors.bg })
	set(0, "DiagnosticSignInfo", { fg = colors.cyan, bg = colors.bg })
	set(0, "DiagnosticSignHint", { fg = colors.blue, bg = colors.bg })

	set(0, "LspReferenceText", { bg = colors.gray2 })
	set(0, "LspReferenceRead", { bg = colors.gray2 })
	set(0, "LspReferenceWrite", { bg = colors.gray2 })

	set(0, "LspCodeLens", { fg = colors.comment })
	set(0, "LspInlayHint", { fg = colors.comment, bg = colors.gray0 })
	set(0, "LspInfoBorder", { fg = colors.gray6, bg = colors.bg_float })
	set(0, "LspSignatureActiveParameter", { fg = colors.accent, bold = true })

	-- Git
	set(0, "GitSignsAdd", { fg = colors.green, bg = colors.bg })
	set(0, "GitSignsChange", { fg = colors.blue, bg = colors.bg })
	set(0, "GitSignsDelete", { fg = colors.red, bg = colors.bg })

	set(0, "GitSignsAddNr", { fg = colors.green, bg = colors.bg })
	set(0, "GitSignsChangeNr", { fg = colors.blue, bg = colors.bg })
	set(0, "GitSignsDeleteNr", { fg = colors.red, bg = colors.bg })

	set(0, "diffAdded", { fg = colors.green })
	set(0, "diffRemoved", { fg = colors.red })
	set(0, "diffChanged", { fg = colors.blue })

	set(0, "DiffAdd", { bg = colors.diff_add })
	set(0, "DiffDelete", { bg = colors.diff_delete })
	set(0, "DiffChange", { bg = colors.diff_change })
	set(0, "DiffText", { bg = colors.diff_text })

	-- Popup menu
	set(0, "Pmenu", { fg = colors.fg_dark, bg = colors.gray1 })
	set(0, "PmenuSel", { fg = colors.bg, bg = colors.accent, bold = true })
	set(0, "PmenuSbar", { bg = colors.gray1 })
	set(0, "PmenuThumb", { bg = colors.gray5 })

	set(0, "PmenuKind", { fg = colors.cyan, bg = colors.gray1 })
	set(0, "PmenuKindSel", { fg = colors.bg, bg = colors.accent })

	set(0, "PmenuExtra", { fg = colors.fg_muted, bg = colors.gray1 })
	set(0, "PmenuExtraSel", { fg = colors.bg, bg = colors.accent })

	set(0, "PmenuMatch", { fg = colors.accent, bg = colors.gray1, bold = true })
	set(0, "PmenuMatchSel", { fg = colors.bg, bg = colors.accent, bold = true })

	-- nvim-cmp
	set(0, "CmpItemAbbr", { fg = colors.fg_dark })
	set(0, "CmpItemAbbrMatch", { fg = colors.accent, bold = true })
	set(0, "CmpItemAbbrMatchFuzzy", { fg = colors.lblue, bold = true })

	set(0, "CmpItemKind", { fg = colors.cyan })
	set(0, "CmpItemKindText", { fg = colors.fg_muted })
	set(0, "CmpItemKindMethod", { fg = colors.blue })
	set(0, "CmpItemKindFunction", { fg = colors.blue })
	set(0, "CmpItemKindConstructor", { fg = colors.purple })
	set(0, "CmpItemKindField", { fg = colors.cyan })
	set(0, "CmpItemKindVariable", { fg = colors.fg })
	set(0, "CmpItemKindClass", { fg = colors.cyan })
	set(0, "CmpItemKindInterface", { fg = colors.cyan })
	set(0, "CmpItemKindModule", { fg = colors.lblue })
	set(0, "CmpItemKindProperty", { fg = colors.cyan })
	set(0, "CmpItemKindUnit", { fg = colors.yellow })
	set(0, "CmpItemKindValue", { fg = colors.lpurple })
	set(0, "CmpItemKindEnum", { fg = colors.cyan })
	set(0, "CmpItemKindKeyword", { fg = colors.purple })
	set(0, "CmpItemKindSnippet", { fg = colors.yellow })
	set(0, "CmpItemKindColor", { fg = colors.lcyan })
	set(0, "CmpItemKindFile", { fg = colors.fg_dark })
	set(0, "CmpItemKindReference", { fg = colors.lblue })
	set(0, "CmpItemKindFolder", { fg = colors.lblue })
	set(0, "CmpItemKindEnumMember", { fg = colors.cyan })
	set(0, "CmpItemKindConstant", { fg = colors.lpurple })
	set(0, "CmpItemKindStruct", { fg = colors.cyan })
	set(0, "CmpItemKindEvent", { fg = colors.yellow })
	set(0, "CmpItemKindOperator", { fg = colors.fg_muted })
	set(0, "CmpItemKindTypeParameter", { fg = colors.cyan })

	-- blink.cmp
	set(0, "BlinkCmpMenu", { fg = colors.fg_dark, bg = colors.bg_float })
	set(0, "BlinkCmpMenuBorder", { fg = colors.gray6, bg = colors.bg_float })
	set(0, "BlinkCmpMenuSelection", { fg = colors.bg, bg = colors.accent, bold = true })

	set(0, "BlinkCmpLabel", { fg = colors.fg_dark })
	set(0, "BlinkCmpLabelDetail", { fg = colors.fg_inactive })
	set(0, "BlinkCmpLabelDescription", { fg = colors.fg_muted })
	set(0, "BlinkCmpLabelMatch", { fg = colors.accent, bold = true })

	set(0, "BlinkCmpKind", { fg = colors.cyan })

	set(0, "BlinkCmpDoc", { fg = colors.fg_dark, bg = colors.bg_float })
	set(0, "BlinkCmpDocBorder", { fg = colors.gray6, bg = colors.bg_float })

	set(0, "BlinkCmpGhostText", { fg = colors.comment, italic = true })

	-- Telescope
	set(0, "TelescopeNormal", { fg = colors.fg_dark, bg = colors.bg_float })
	set(0, "TelescopeBorder", { fg = colors.gray6, bg = colors.bg_float })
	set(0, "TelescopePromptBorder", { fg = colors.border_active, bg = colors.bg_float })
	set(0, "TelescopePromptPrefix", { fg = colors.accent })
	set(0, "TelescopePromptTitle", { fg = colors.fg, bold = true })

	set(0, "TelescopeSelection", { fg = colors.fg, bg = colors.selection })
	set(0, "TelescopeSelectionCaret", { fg = colors.accent })
	set(0, "TelescopeMatching", { fg = colors.yellow, bold = true })
	set(0, "TelescopeMultiSelection", { fg = colors.lblue })

	set(0, "TelescopeResultsDiffAdd", { fg = colors.green })
	set(0, "TelescopeResultsDiffDelete", { fg = colors.red })
	set(0, "TelescopeResultsDiffChange", { fg = colors.blue })

	-- WhichKey
	set(0, "WhichKey", { fg = colors.accent })
	set(0, "WhichKeyGroup", { fg = colors.blue })
	set(0, "WhichKeyDesc", { fg = colors.fg_dark })
	set(0, "WhichKeyBorder", { fg = colors.gray6, bg = colors.bg_float })
	set(0, "WhichKeyFloat", { bg = colors.bg_float })
	set(0, "WhichKeySeparator", { fg = colors.gray4 })

	-- Indent lines
	set(0, "IndentBlanklineChar", { fg = colors.indent })
	set(0, "IndentBlanklineContextChar", { fg = colors.gray6 })

	set(0, "IblIndent", { fg = colors.indent })
	set(0, "IblWhitespace", { fg = colors.whitespace })
	set(0, "IblScope", { fg = colors.accent })

	-- NvimTree
	set(0, "NvimTreeNormal", { fg = colors.fg_dark, bg = colors.bg_alt })
	set(0, "NvimTreeNormalNC", { fg = colors.fg_dark, bg = colors.bg_alt })
	set(0, "NvimTreeWinSeparator", { fg = colors.bg_alt, bg = colors.bg_alt })

	set(0, "NvimTreeFolderName", { fg = colors.blue })
	set(0, "NvimTreeFolderIcon", { fg = colors.accent })
	set(0, "NvimTreeOpenedFolderName", { fg = colors.lblue })
	set(0, "NvimTreeEmptyFolderName", { fg = colors.fg_inactive })

	set(0, "NvimTreeFileDeleted", { fg = colors.red })
	set(0, "NvimTreeFileModified", { fg = colors.yellow })

	set(0, "NvimTreeGitDirty", { fg = colors.red })
	set(0, "NvimTreeGitNew", { fg = colors.green })
	set(0, "NvimTreeGitStaged", { fg = colors.green })
	set(0, "NvimTreeGitDeleted", { fg = colors.red })

	-- Neo-tree
	set(0, "NeoTreeNormal", { fg = colors.fg_dark, bg = colors.bg_alt })
	set(0, "NeoTreeNormalNC", { fg = colors.fg_dark, bg = colors.bg_alt })
	set(0, "NeoTreeWinSeparator", { fg = colors.bg_alt, bg = colors.bg_alt })

	set(0, "NeoTreeDirectoryName", { fg = colors.blue })
	set(0, "NeoTreeDirectoryIcon", { fg = colors.accent })
	set(0, "NeoTreeOpenedFolderName", { fg = colors.lblue })

	set(0, "NeoTreeFileModified", { fg = colors.yellow })
	set(0, "NeoTreeGitModified", { fg = colors.yellow })
	set(0, "NeoTreeGitUntracked", { fg = colors.blue })
	set(0, "NeoTreeGitAdded", { fg = colors.green })
	set(0, "NeoTreeGitDeleted", { fg = colors.red })

	-- Visibility improvements
	set(0, "CursorLine", { bg = "#1A1230" })
	set(0, "CursorColumn", { bg = "#1A1230" })
	set(0, "ColorColumn", { bg = "#1A1230" })

	set(0, "Visual", { bg = "#332263" })

	set(0, "LineNr", { fg = "#5D5478" })
	set(0, "CursorLineNr", { fg = "#D0A4FF", bold = true })

	set(0, "Comment", { fg = "#7A7194", italic = true })
	set(0, "Whitespace", { fg = "#2E2448" })
	set(0, "NonText", { fg = "#42385E" })
	set(0, "EndOfBuffer", { fg = "#372E4D" })

	set(0, "StatusLine", { fg = colors.fg_dark, bg = "#0F0A1C" })
	set(0, "StatusLineNC", { fg = colors.fg_inactive, bg = "#0A0812" })

	set(0, "Pmenu", { fg = colors.fg_dark, bg = "#0D0A18" })
	set(0, "PmenuSel", { fg = colors.bg, bg = colors.accent, bold = true })

	-- Terminal colors
	vim.g.terminal_color_0 = "#05040A"
	vim.g.terminal_color_1 = colors.red
	vim.g.terminal_color_2 = colors.green
	vim.g.terminal_color_3 = colors.yellow
	vim.g.terminal_color_4 = colors.blue
	vim.g.terminal_color_5 = colors.purple
	vim.g.terminal_color_6 = colors.cyan
	vim.g.terminal_color_7 = colors.fg_dark

	vim.g.terminal_color_8 = colors.gray6
	vim.g.terminal_color_9 = colors.lred
	vim.g.terminal_color_10 = colors.lgreen
	vim.g.terminal_color_11 = colors.lyellow
	vim.g.terminal_color_12 = colors.lblue
	vim.g.terminal_color_13 = colors.lpurple
	vim.g.terminal_color_14 = colors.lcyan
	vim.g.terminal_color_15 = colors.gray10
end

M.colorscheme()

return M
