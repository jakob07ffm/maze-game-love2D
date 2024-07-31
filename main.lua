function love.load()
    love.window.setTitle("Maze Game")
    love.window.setMode(800, 600)

    cellSize = 40
    cols = 20
    rows = 15
    player = {x = 1, y = 1}
    goal = {x = cols, y = rows}

    maze = generateMaze(cols, rows)
end

function love.update(dt)
    if love.keyboard.isDown("up") then
        movePlayer(0, -1)
    elseif love.keyboard.isDown("down") then
        movePlayer(0, 1)
    elseif love.keyboard.isDown("left") then
        movePlayer(-1, 0)
    elseif love.keyboard.isDown("right") then
        movePlayer(1, 0)
    end
end

function love.draw()
    drawMaze(maze)
    drawPlayer()
    drawGoal()
    if player.x == goal.x and player.y == goal.y then
        love.graphics.setColor(0, 1, 0)
        love.graphics.print("You Win!", 350, 280, 0, 2, 2)
    end
end

function generateMaze(cols, rows)
    local maze = {}
    for y = 1, rows do
        maze[y] = {}
        for x = 1, cols do
            if x == 1 or y == 1 or x == cols or y == rows then
                maze[y][x] = 1
            else
                maze[y][x] = math.random() > 0.7 and 1 or 0
            end
        end
    end
    maze[1][1] = 0
    maze[rows][cols] = 0
    return maze
end

function drawMaze(maze)
    for y = 1, rows do
        for x = 1, cols do
            if maze[y][x] == 1 then
                love.graphics.setColor(0.3, 0.3, 0.3)
                love.graphics.rectangle("fill", (x-1) * cellSize, (y-1) * cellSize, cellSize, cellSize)
            end
        end
    end
end

function drawPlayer()
    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle("fill", (player.x-1) * cellSize, (player.y-1) * cellSize, cellSize, cellSize)
end

function drawGoal()
    love.graphics.setColor(0, 0, 1)
    love.graphics.rectangle("fill", (goal.x-1) * cellSize, (goal.y-1) * cellSize, cellSize, cellSize)
end

function movePlayer(dx, dy)
    local newX = player.x + dx
    local newY = player.y + dy

    if newX > 0 and newX <= cols and newY > 0 and newY <= rows and maze[newY][newX] == 0 then
        player.x = newX
        player.y = newY
    end
end
