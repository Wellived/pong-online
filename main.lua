function criaObjeto(x,y)
    local obj = {
        x = x,
        y = y,
        width = 25,
        height = 250,
        cor = {255, 0, 0} ,-- Cor inicial: vermelho
        pontuacao = 0
    }
    return obj
end
contador = 0
fimJogo = false
ganhador = "11111"

function criarBola()
    local obj = {
    x = love.graphics.getWidth()/2 -25,
    y = love.graphics.getHeight()/2 -25,
    width = 25,
    height = 25,
    cor = {255,0,0},
    velocidadex = movimentoInicial(),
    velocidadey = movimentoInicial(),
    multiplicador = 1,
    gameinicio = false

    }
    return obj
end
function movimentoInicial()
    local mov = math.random(0,1)
    if mov == 0 then
        mov= -10
    else
        mov = 10    
    end    

    return mov
end

function love.load()
    player1 = criaObjeto(0,love.graphics.getHeight() /2-125)
    player2 = criaObjeto(love.graphics.getWidth()-25,love.graphics.getHeight() /2 - 125)
    bola = criarBola() 
end
function love.draw ()
    love.graphics.rectangle('fill', player1.x, player1.y, player1.width, player1.height)
    love.graphics.rectangle('fill', player2.x, player2.y, player2.width, player2.height)
    love.graphics.rectangle('fill',bola.x,bola.y,bola.width,bola.height)

    love.graphics.print("player1 :" .. player1.pontuacao, 2 , 10,0,2,2)
    love.graphics.print("player2 :" .. player2.pontuacao, love.graphics.getWidth() - 200 , 10,0,2,2)

    if fimJogo then
        love.graphics.print("Fim de jogo \nganhador : "  .. ganhador, love.graphics.getWidth() /2 - 250, love.graphics.getHeight() /2,0,5,5)

    end

end

function trocarVelocidade(d)
    if d == 0 then 
        bola.velocidadex = 10
    else
        bola.velocidadex = -10
    end
    aux = math.random(0,1)
    if aux == 0 then
        bola.velocidadey =  math.random(0,10) 
    else
        bola.velocidadey =  math.random(0,10)  

    end
    
end


function colisao(obj1,obj2)
   

if obj1.x + obj1.width < obj2.x or obj1.x > obj2.x + obj2.width then
    return false
end
if obj1.y + obj1.height < obj2.y or obj1.y > obj2.y + obj2.height then
    return false
end

return true

end

function detectarColisao()

    if colisao(bola,player1) then
        trocarVelocidade(0)
    
    elseif colisao(bola,player2) then
        trocarVelocidade(1)

    end
    
end

function love.update(dt)
    souavelocidade()
    movimentarbola()
    detectarColisao()
    detectarpontuacao()
   detectarFimJogo()
end

function detectarFimJogo()
    if player1.pontuacao == 3  then
        fimJogo = true
        ganhador = "player 1 "
    end

    if player2.pontuacao == 3 then
        fimJogo = true
        ganhador = "player 2"
    end
    
end

function reiniciarJogo()
    player1.pontuacao = 0
    player2.pontuacao = 0
    fimJogo = false
end

function fimDeJogo()
    fimJogo = true

    
end


function souavelocidade()
    contador = contador + 1
    if contador == 120 then
        bola.multiplicador = bola.multiplicador + 0.1
        contador = 0
    end
    
end
function detectarpontuacao()
    if bola.x <= 0 then
        player2.pontuacao =player2.pontuacao + 1
        contador = 0
        bola = criarBola()
    elseif bola.x >= love.graphics.getWidth() - bola.width then
        player1.pontuacao = player1.pontuacao +1
        contador = 0
        bola = criarBola()

    end
    
end

function movimentarbola()
    if bola.gameinicio then
        bola.x = bola.x + bola.velocidadex * bola.multiplicador
        bola.y = bola.y + bola.velocidadey * bola.multiplicador
        if bola.x <= 0 then
            bola.velocidadex = 10
        elseif bola.x >= love.graphics.getWidth() - bola.width then
            bola.velocidadex = -10
        end

        if bola.y <= 0  then
            bola.velocidadey= 10
        elseif bola.y >= love.graphics.getHeight() - bola.height then
            bola.velocidadey = -10
        end
    end
    
end


function love.keypressed(key, scancode, isrepeat)
    local distMovimentacao = 100
    if key == "escape" then
       love.event.quit()
    end
    if key == "return" then
        bola.gameinicio = true
    end

    if key =="0" then
        reiniciarJogo();
    end
    if key == "w" then
        
        if player1.y > 0 then
            player1.y = player1.y -distMovimentacao

        else 
            player1.y = 0
        end
    end

     if key == "s"then
        player1.y = player1.y + distMovimentacao

        if player1.y + player1.height > love.graphics.getHeight()  then
            player1.y = love.graphics.getHeight() - player1.height
            
        end
    end
    
    if key == "up" then

        if player2.y > 0 then
            player2.y = player2.y -distMovimentacao

        else 
            player2.y = 0
        end
    end

    if key == "down"  then
        player2.y = player2.y + distMovimentacao

        if player2.y + player2.height > love.graphics.getHeight()  then
            player2.y = love.graphics.getHeight() - player2.height
            
        end
        
    end
    
 end