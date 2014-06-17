-- Ancho disponible en pantalla
local contentWidth = application:getContentWidth()

-- Alto de la pantalla
local contentHeight = application:getContentHeight()

local texturepack = TexturePack.new("texturepacks/pack.txt", "texturepacks/pack.png", true)
local heroe = Bitmap.new(texturepack:getTextureRegion("heroe_1.png"))
heroe:setPosition(contentWidth / 2, contentHeight - 40)
heroe:setAnchorPoint(0.5, 0.5)

function onMouseDown(event)
   heroe:setPosition(event.x, contentHeight - 40)
end

stage:addChild(heroe)
stage:addEventListener(Event.MOUSE_DOWN, onMouseDown)

local numVillanos = 5
local velocidadCaidaMax = 3
local alturaInicial = 10

local villanos = {}


for i = 0, numVillanos - 1 do
   villanos[i] = Bitmap.new(texturepack:getTextureRegion("villano_1.png"))
   local x = math.random(0, contentWidth)
   villanos[i]:setAnchorPoint(0.5, 0.5)
   villanos[i].velocidad = math.random(1, velocidadCaidaMax)
   
   villanos[i]:setPosition(x, alturaInicial)
   stage:addChild(villanos[i])
end

local puntaje = 0

function onEnterFrame(event)
	local villano
	for i=0, numVillanos - 1 do
		villano = villanos[i]
		local villanoY = villano:getY()
		local villanoX = villano:getX()	
		
		villanoY = villanoY + villanos[i].velocidad
		
		if((villanoY + (villano:getHeight()/2)) > contentHeight) then
			villanoX = math.random(0, contentWidth)
			villanoY = 0;
			
			-- Cada vez que esquivamos uno sumamos 1 punto
			puntaje = puntaje + 1
			print(puntaje)
		end
		
		villano:setPosition(villanoX, villanoY)	
		
		local heroeX, heroeY = heroe:getPosition()
		
		if((heroeX - heroe:getWidth()/2 < villanoX and villanoX < heroeX + heroe:getWidth()/2)
			and (heroeY - heroe:getHeight()/2 < villanoY and villanoY < heroeY + heroe:getHeight()/2)) then
			
			-- Cada vez que chocamos quitamos puntos
			puntaje = puntaje - 1
			print("CHOQUE "..puntaje)
		end
		
	end
end

stage:addEventListener(Event.ENTER_FRAME, onEnterFrame)