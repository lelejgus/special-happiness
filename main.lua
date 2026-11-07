-- City game: interface test (no gameplay yet)
local W, H = 360, 640          -- virtual portrait resolution
local scale, ox, oy = 1, 0, 0

local COLS, ROWS, TILE = 8, 8, 40
local GX, GY = 20, 110         -- grid position
local grid, sel = {}, nil
local msg = "Tap a tile"
local buttons = {}
local fontBig, fontSmall

local function updateScale()
  local w, h = love.graphics.getDimensions()
  scale = math.min(w / W, h / H)
  ox, oy = (w - W * scale) / 2, (h - H * scale) / 2
end

function love.load()
  love.graphics.setDefaultFilter("nearest", "nearest")
  fontBig = love.graphics.newFont(20)
  fontSmall = love.graphics.newFont(14)
  for y = 1, ROWS do
    grid[y] = {}
    for x = 1, COLS do grid[y][x] = 0 end
  end
  buttons = {
    {label = "Build",   x = 20,  y = 450, w = 150, h = 50},
    {label = "Upgrade", x = 190, y = 450, w = 150, h = 50},
    {label = "Shop",    x = 20,  y = 515, w = 150, h = 50},
    {label = "Menu",    x = 190, y = 515, w = 150, h = 50},
  }
  updateScale()
end

function love.resize() updateScale() end

local function inside(px, py, r)
  return px >= r.x and px <= r.x + r.w and py >= r.y and py <= r.y + r.h
end

-- works for both mouse and touch (LÖVE emulates mouse on Android)
function love.mousepressed(sx, sy)
  local px, py = (sx - ox) / scale, (sy - oy) / scale
  local tx = math.floor((px - GX) / TILE) + 1
  local ty = math.floor((py - GY) / TILE) + 1
  if tx >= 1 and tx <= COLS and ty >= 1 and ty <= ROWS then
    sel = {x = tx, y = ty}
    msg = "Tile " .. tx .. ", " .. ty
    return
  end
  for _, b in ipairs(buttons) do
    if inside(px, py, b) then msg = "Pressed: " .. b.label end
  end
end

local function topItem(x, label, value)
  love.graphics.setColor(1, 1, 1)
  love.graphics.setFont(fontSmall)
  love.graphics.print(label, x, 12)
  love.graphics.setFont(fontBig)
  love.graphics.print(value, x, 32)
end

function love.draw()
  love.graphics.clear(0.12, 0.14, 0.18)
  love.graphics.push()
  love.graphics.translate(ox, oy)
  love.graphics.scale(scale)

  -- top bar
  love.graphics.setColor(0.2, 0.24, 0.32)
  love.graphics.rectangle("fill", 0, 0, W, 90)
  topItem(15, "Coins", "100")
  topItem(130, "People", "0")
  topItem(245, "Level", "1")

  -- city grid (top-down)
  for y = 1, ROWS do
    for x = 1, COLS do
      love.graphics.setColor(0.3, 0.6 + ((x + y) % 2) * 0.05, 0.3)
      love.graphics.rectangle("fill", GX + (x - 1) * TILE, GY + (y - 1) * TILE, TILE - 1, TILE - 1)
    end
  end
  if sel then
    love.graphics.setColor(1, 1, 0)
    love.graphics.setLineWidth(3)
    love.graphics.rectangle("line", GX + (sel.x - 1) * TILE, GY + (sel.y - 1) * TILE, TILE - 1, TILE - 1)
  end

  -- message line
  love.graphics.setColor(1, 1, 1)
  love.graphics.setFont(fontSmall)
  love.graphics.printf(msg, 0, 425, W, "center")

  -- buttons
  for _, b in ipairs(buttons) do
    love.graphics.setColor(0.25, 0.45, 0.8)
    love.graphics.rectangle("fill", b.x, b.y, b.w, b.h, 8, 8)
    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(fontBig)
    love.graphics.printf(b.label, b.x, b.y + 13, b.w, "center")
  end

  love.graphics.pop()
end
