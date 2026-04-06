-- ====================================================
-- Mini.hipatterns Contrast & Syntax Test Suite
-- ====================================================

-- 1. Keywords (Testing word boundaries)
-- ----------------------------------------------------
-- Here is a TODO item.
-- We need to FIXME this before shipping.
-- HACK: This is a temporary workaround.
-- NOTE: Just a friendly reminder.
--
-- FALSE POSITIVES (These should NOT highlight):
-- myTODOlist, FIXME_now, HACKING, ANOTE

-- 2. Standard Hex Colors (#RRGGBB)
-- ----------------------------------------------------
local solid_red = "#ff0000"
local solid_green = "#00ff00"
local solid_blue = "#0000ff"

-- 3. W3C Contrast Check (The tricky mid-tones)
-- Look closely at the text color (foreground) on these to see the W3C formula shine:
-- ----------------------------------------------------
local pure_white = "#ffffff" -- Text should be black
local pure_black = "#000000" -- Text should be white
local dark_gray = "#333333" -- Text should be white
local light_gray = "#cccccc" -- Text should be black
local mid_gray = "#777777" -- Text should clearly contrast
local mid_teal = "#4aa0a0" -- Tricky mid-tone

-- 4. Short Hex (#RGB)
-- ----------------------------------------------------
local short_red = "#f00"
local short_green = "#0f0"
local short_blue = "#00f"
local short_white = "#fff"

-- 5. Hex with Alpha (#RRGGBBAA)
-- ----------------------------------------------------
local semi_red = "#ff000080"
local semi_green = "#00ff00cc"

-- 6. RGB & RGBA
-- ----------------------------------------------------
local rgb_red = "rgb(255, 0, 0)"
local rgba_green = "rgba(0, 255, 0, 0.5)"
local rgb_blue_spaced = "rgb(   0  ,   0  ,  255  )"

-- 7. HSL & HSLA
-- ----------------------------------------------------
local hsl_red = "hsl(0, 100%, 50%)"
local hsla_green = "hsla(120, 100%, 50%, 0.8)"
local hsl_blue = "hsl(240, 100%, 50%)"
local hsl_custom = "hsl(200, 50%, 50%)"

-- 8. Boundary & Out-of-Bounds Checks (Should NOT highlight)
-- ----------------------------------------------------
local bad_hex_start = "url#ffffff"
local bad_hex_end = "#ff0000Z"
local bad_rgb_range = "rgb(300, 0, 0)" -- 300 is > 255
local bad_hsl_range = "hsl(400, 100%, 50%)" -- 400 is > 360
