local ADDON_NAME, NAMESPACE = ...
local ThreatPlates = NAMESPACE.ThreatPlates

-- Lua APIs

-- WoW APIs
local GetNamePlateForUnit = C_NamePlate.GetNamePlateForUnit

-- ThreatPlates APIs
local TidyPlatesThreat = TidyPlatesThreat

local function SetCastbarColor(unit)
	local db = TidyPlatesThreat.db.profile
	local c = {r = 1,g = 1,b = 0,a = 1}
	if db.castbarColor.toggle then
		if unit.spellIsShielded and db.castbarColorShield.toggle then
			c = db.castbarColorShield
		else
			c = db.castbarColor
		end
	end

	-- set background color for castbar

	-- There are LUA errors when calling GetNamePlateForUnit with a nil unitid
	-- Don't know why this could happen here, but the nameplate should be invalid / not visible anyway
	if unit.unitid then
		local plate = GetNamePlateForUnit(unit.unitid)
		if plate and plate.extended then

			db = db.settings.castbar
			if db.BackgroundUseForegroundColor then
				plate.extended.visual.castbar.Backdrop:SetVertexColor(c.r, c.g, c.b, db.BackgroundOpacity)
			else
				local color = db.BackgroundColor
				plate.extended.visual.castbar.Backdrop:SetVertexColor(color.r, color.g, color.b, db.BackgroundOpacity)
			end
		end
	end

	return c.r, c.g, c.b, c.a
end

TidyPlatesThreat.SetCastbarColor = SetCastbarColor