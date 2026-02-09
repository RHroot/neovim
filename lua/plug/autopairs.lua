require("nvim-autopairs").setup({
	disable_in_replace_mode = true,
	check_ts = true,
	fast_wrap = {
		map = "<M-e>",
		chars = { "(", "[", "{", "'", '"', "`" },
		pattern = [=[[%'%"%)%>%]%)%}%,]]=],
		end_key = "$",
		check_comma = true,
		highlight = "Search",
		highlight_grey = "Comment",
	},
	map_cr = true,
})

local npairs = require("nvim-autopairs")
local blink_cmp = require("blink.cmp")

if blink_cmp and blink_cmp.event and blink_cmp.event.on_confirm then
	blink_cmp.event:on_confirm(function()
		npairs.on_confirm_done()
	end)
end
