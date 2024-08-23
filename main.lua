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
    local stack = {}

    for y = 1, rows do
        maze[y] = {}
        for x = 1, cols do
            maze[y][x] = 1 -- Wall
        end
    end

    local currentCell = {x = 1, y = 1}
    maze[currentCell.y][currentCell.x] = 0
    table.insert(stack, currentCell)


    while #stack > 0 do
        local cell = stack[#stack]
        local neighbors = {}


        local directions = {
            {dx = 0, dy = -2}, 
            {dx = 0, dy = 2},  
            {dx = -2, dy = 0}, 
            {dx = 2, dy = 0}  
        }

        for _, dir in ipairs(directions) do
            local nx, ny = cell.x + dir.dx, cell.y + dir.dy
            if nx > 0 and nx <= cols and ny > 0 and ny <= rows and maze[ny][nx] == 1 then
                table.insert(neighbors, {x = nx, y = ny, dir = dir})
            end
        end

        if #neighbors > 0 then
            local nextCell = neighbors[love.math.random(1, #neighbors)]
            local wallX = cell.x + nextCell.dir.dx / 2
            local wallY = cell.y + nextCell.dir.dy / 2


            maze[wallY][wallX] = 0
            maze[nextCell.y][nextCell.x] = 0

            table.insert(stack, {x = nextCell.x, y = nextCell.y})
        else
            table.remove(stack)
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
