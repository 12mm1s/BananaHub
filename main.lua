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
	"Meat", "Melon", "Padlock key", "Playhouse Key", "Remote control", "Rusty padlock key", "Safekey", "Spark plug", "Special key", "Weapon key", "Wheel crank", "Winch handle", "Wrench", "Battery", "Bird seed", "Book", "Car Battery", "Car key", "Chain cutter", "Cogwheel (Orange)", "Cogwheel (Red)", "Gasoline can", "Hammer", "Padlock code", "Wooden stick", "Screwdriver", "Master Key", "Crossbow", "Shotgun", "Cutting pliers", "Engine part" 
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
