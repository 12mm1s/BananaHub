local player = game.Players.LocalPlayer

local preset
for _, child in ipairs(workspace:GetChildren()) do
	if child.Name:match("^Preset%d+$") then
		preset = child
		break
	end
end

if not preset then
	return
end

local items = {
	"meat", "melon", "padlock key", "playhouse Key", "remote control", "rusty padlock key", "safekey", "spark plug", "special key", "weapon key", "wheel crank", "winch handle", "wrench", "battery", "bird seed", "book", "car battery", "car key", "chain cutter", "cogwheel (Orange)", "cogwheel (Red)", "gasoline can", "hammer", "padlock code", "wooden stick", "screwdriver", "master Key", "crossbow", "shotgun", "cutting pliers", "engine part" 
}

for _, itemName in ipairs(items) do
	local item = preset:FindFirstChild(itemName, true)
	if item then
		local remote = item:FindFirstChild("InteractRemote", true)
		if remote and remote:IsA("RemoteEvent") then
			remote:FireServer()
			task.wait(0.05)
		end
	end
end
