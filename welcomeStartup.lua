local detector = peripheral.wrap("Bottom")
local players = detector.getPlayersInRange(5);
local closestPlayer = players[1];

print("Welcome " .. closestPlayer)