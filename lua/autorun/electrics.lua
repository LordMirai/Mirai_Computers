MCom = MCom or {}

MCom.Power = MCom.Power or {}

MCom.Power.Sources = { -- valid energy source types
    ["generator"] = true, -- personal fuel generator
    ["grid"] = true, -- "city-wide" grid
    ["battery"] = true, -- temporary storage
    ["nuclear"] = true, -- industrial-grade personal generator
}

MCom.Power.BaseCosts = { -- cost per power tick
    ["computer"] = 0.5,
    ["display"] = 0.3,
    ["server"] = 0.7,
}