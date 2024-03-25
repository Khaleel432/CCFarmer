local detector = peripheral.wrap("Bottom")
local players = detector.getPlayersInRange(3);
local closestPlayer = players[1];

print("Welcome " .. closestPlayer)