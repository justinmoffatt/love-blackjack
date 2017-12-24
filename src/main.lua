-- blackjack game

function love.load()
	-- the types of cards in a deck
	VALUES = {11,2,3,4,5,6,7,8,9,10,10,10,10}
	FACES = {'a','2','3','4','5','6','7','8','9','10','j','q','k'}
	SUITS = {'spades','clubs','hearts','diamonds'}

	-- the screen size
	RESOLUTION_MULTIPLIER = 1
	RESOLUTION_HEIGHT = love.graphics.getHeight()
	RESOLUTION_WIDTH = love.graphics.getWidth()

	IMAGE_SCALE = RESOLUTION_WIDTH/1080

	-- game managers
	game_state = 0
	

	-- vars
	bet = 0
	bank = 50
	input = {1,1}
	input_enabled = true
	player_total=0
	dealer_total=0

	used_cards = {}
	for i = 1, 52 do
		used_cards[i] = false
	end
	-- creates a deck of 52 cards
	deck = {}
	local i = 1
	for suit = 1, 4, 1 do
		for value = 1, 13, 1 do
			deck[i] = {suit=SUITS[suit], face=FACES[value], value=VALUES[value], img=love.graphics.newImage('img/cards/'..SUITS[suit]..'_'..FACES[value]..'.jpg')}
			--Card:new(SUITS[suit], FACES[value], VALUES[value])
			i = i + 1
		end
	end

	font = love.graphics.newFont(percent_height(1/16)) 
	f_width_play = font:getWidth("Play Hand")
	f_width_clear = font:getWidth("Clear Table")
	font_small = love.graphics.newFont()

	-- print outs
	line1=percent_height(.01)
	text_x = 0
	text_hand = ''

	-- images for the coin/chips that are used for user input
	chip_1 	= love.graphics.newImage('img/chip_1.png')
	chip_5 	= love.graphics.newImage('img/chip_5.png')
	chip_10 = love.graphics.newImage('img/chip_10.png')
	chip_50 = love.graphics.newImage('img/chip_50.png')
	chips = {chip_1, chip_5, chip_10, chip_50}
	-- setup the card images

	card_empty = love.graphics.newImage('img/cards/card_empty.png')
	card_back = love.graphics.newImage('img/cards/card_back.jpg')
	card_boarder = love.graphics.newImage('img/cards/card_boarder.png')
	card_p = {card_empty,card_empty,card_empty,card_empty,card_empty,card_empty}
	card_d = {card_empty,card_empty,card_empty,card_empty,card_empty,card_empty}
	card_b = {}
	for i = 1,12 do
		card_b[i] = card_empty
	end
end

function love.draw()
	love.graphics.setBackgroundColor(0, 50, 0)
	--[[love.graphics.setFont(font_small)
	love.graphics.print('Player Score: '..player_total..' Dealer Score: '.. dealer_total,10,0) ]]
	love.graphics.setFont(font)
	love.graphics.print('Bank: '.. bank .. ' Bet: '.. bet, 10,percent_height(0.075))
	love.graphics.print(line1, 10, percent_height(.01))
	love.graphics.print(text_hand, text_x, percent_height(.9))
	love.graphics.draw(chips[1], 0, percent_height(0.75), 0, IMAGE_SCALE)
	love.graphics.draw(chips[2], percent_width(0.25), percent_height(0.75), 0, IMAGE_SCALE)
	love.graphics.draw(chips[3], percent_width(0.5), percent_height(0.75), 0, IMAGE_SCALE)
	love.graphics.draw(chips[4], percent_width(0.75), percent_height(0.75), 0, IMAGE_SCALE)
	-- cards
	love.graphics.draw(card_p[1], percent_width(1/12), percent_height(1/2), 0, IMAGE_SCALE)
	love.graphics.draw(card_b[1], percent_width(1/12), percent_height(1/2), 0, IMAGE_SCALE)
	love.graphics.draw(card_p[2], percent_width(3/12), percent_height(1/2), 0, IMAGE_SCALE)
	love.graphics.draw(card_b[2], percent_width(3/12), percent_height(1/2), 0, IMAGE_SCALE)
	love.graphics.draw(card_p[3], percent_width(5/12), percent_height(1/2), 0, IMAGE_SCALE)
	love.graphics.draw(card_b[3], percent_width(5/12), percent_height(1/2), 0, IMAGE_SCALE)
	love.graphics.draw(card_p[4], percent_width(7/12), percent_height(1/2), 0, IMAGE_SCALE)
	love.graphics.draw(card_b[4], percent_width(7/12), percent_height(1/2), 0, IMAGE_SCALE)
	love.graphics.draw(card_p[5], percent_width(9/12), percent_height(1/2), 0, IMAGE_SCALE)
	love.graphics.draw(card_b[5], percent_width(9/12), percent_height(1/2), 0, IMAGE_SCALE)
	love.graphics.draw(card_p[6], percent_width(11/12), percent_height(1/2), 0, IMAGE_SCALE)
	love.graphics.draw(card_b[6], percent_width(11/12), percent_height(1/2), 0, IMAGE_SCALE)
	
	love.graphics.draw(card_d[1], percent_width(1/12), percent_height(1/6), 0, IMAGE_SCALE)
	love.graphics.draw(card_b[7], percent_width(1/12), percent_height(1/6), 0, IMAGE_SCALE)
	love.graphics.draw(card_d[2], percent_width(3/12), percent_height(1/6), 0, IMAGE_SCALE)
	love.graphics.draw(card_b[8], percent_width(3/12), percent_height(1/6), 0, IMAGE_SCALE)
	love.graphics.draw(card_d[3], percent_width(5/12), percent_height(1/6), 0, IMAGE_SCALE)
	love.graphics.draw(card_b[9], percent_width(5/12), percent_height(1/6), 0, IMAGE_SCALE)
	love.graphics.draw(card_d[4], percent_width(7/12), percent_height(1/6), 0, IMAGE_SCALE)
	love.graphics.draw(card_b[10], percent_width(7/12), percent_height(1/6), 0, IMAGE_SCALE)
	love.graphics.draw(card_d[5], percent_width(9/12), percent_height(1/6), 0, IMAGE_SCALE)
	love.graphics.draw(card_b[11], percent_width(9/12), percent_height(1/6), 0, IMAGE_SCALE)
	love.graphics.draw(card_d[6], percent_width(12/12), percent_height(1/6), 0, IMAGE_SCALE)
	love.graphics.draw(card_b[12], percent_width(12/12), percent_height(1/6), 0, IMAGE_SCALE)
	-- draw the button boxes for debugging
	--love.graphics.rectangle("line",0, percent_height(0.85), percent_width(1), percent_height(1))
end

-- INPUTS
function love.touchpressed(id, x, y, dx, dy, pressure)
	input = {tonumber(x), tonumber(y)}
	input_enabled = true
end	

function love.update(dt)
	-- game logic
	if game_state == 0 then				-- pause state
		change_game_state(1)

	elseif game_state == 1 then 		-- betting state
		-- add to bet
		line1= 'Place Bet'
		text_hand = ''
		if input_enabled then
			
			if in_box(input[1], input[2], 0, percent_height(0.75), percent_width(0.25), percent_width(0.25)) and bank > 0 then
				bet = bet + 1
				bank = bank - 1
			elseif in_box(input[1], input[2], percent_width(0.25), percent_height(0.75), percent_width(0.25), percent_width(0.25)) and bank > 4 then
				bet = bet + 5
				bank = bank - 5
			elseif in_box(input[1], input[2], percent_width(0.50), percent_height(0.75), percent_width(0.25), percent_width(0.25)) and bank > 9 then
				bet = bet + 10
				bank = bank - 10
			elseif in_box(input[1], input[2], percent_width(0.75), percent_height(0.75), percent_width(0.25), percent_width(0.25)) and bank > 49 then
				bet = bet + 50
				bank = bank - 50
			elseif in_box(input[1], input[2], 0, percent_width(0.25), percent_width(1), percent_height(0.5)) then
				change_game_state(2)
			end
			input_enabled = false
		end

	elseif game_state == 2 then 		-- card getting state
		text_hand = 'Play Hand'
		text_x = percent_width(0.5) - (f_width_play/2)

		-- logic for the deaing
		if player_total == 0 then	-- this is the init state
			player_cards = {draw_card(), draw_card()}
			player_total = player_cards[1].value + player_cards[2].value
			-- work the dealer
			dealer_cards = {draw_card(), draw_card()}
			dealer_total = dealer_cards[1].value + dealer_cards[2].value
			-- players
			card_p[1] = player_cards[1].img
			card_p[2] = player_cards[2].img
			card_b[1] = card_boarder
			card_b[2] = card_boarder

			card_d[1] = dealer_cards[1].img 
			card_d[2] = card_back
			card_b[7] = card_boarder
			card_b[8] = card_boarder

		elseif dealer_total == 21 and player_total == 21 then
			line1 = "Both are 21"
			change_game_state(3)

		elseif dealer_total == 21 then
			line1 = 'Dealer win'
			change_game_state(3)

		elseif player_total == 21 then 								-- Player wins with natural 21
			bank = bank + (bet * 2)
			line1 = "Player wins"
			
			change_game_state(3)
			player_total = 0
		
		elseif player_total < 21 and in_box(input[1], input[2], 0, percent_width(0.25), percent_width(1), percent_height(0.5)) and input_enabled then -- hit player
			input_enabled = false
			-- work the player
			player_cards[#player_cards + 1] = draw_card()
			player_total = 0
			for i = 1, #player_cards do
				player_total = player_total + player_cards[i].value
				card_p[i] = player_cards[i].img
				card_b[i] = card_boarder
			end
			-- fix any ace cases
			if player_total > 21 then
				for i = 1, #player_cards do
					if player_cards[i].value == 11 then
						player_cards[i].value = '1'
						player_total = player_total - 10
						if player_total < 21 then
							break
						end
					end
				end
			 end 

		elseif player_total > 21 then 		-- player went over 21
			line1="Over 21"
			change_game_state(3)

		elseif in_box(input[1], input[2], 0, percent_width(0.86), percent_width(1), percent_height(1)) and input_enabled then	-- hit done 
			input_enabled = false

			-- work the dealer
			while dealer_total < 18 do
				dealer_cards[#dealer_cards+1] = draw_card()
				dealer_total = dealer_total + dealer_cards[#dealer_cards].value
				-- check for aces
				if dealer_total > 21 then
					for i = 1, #dealer_cards do
						if dealer_cards[i].value == 11 then
							dealer_cards[i].value = 1
							dealer_total = dealer_total - 10
							if dealer_total < 21 then
								break
							end
						end
					end
				end
			end

			if player_total > dealer_total and dealer_total < 22 then
				bank = bank + (bet * 2)
				line1 = "Player wins"
				change_game_state(3)
			elseif player_total < 22 and dealer_total > 21 then
				bank = bank + (bet * 2)
				line1 = "Player wins"
				change_game_state(3)
			elseif player_total == dealer_total and player_total < 22 then
				bank = bank + bet
				line1 = "Same amount"
				change_game_state(3)
			else 
				line1 ="Dealer wins"
				change_game_state(3)
			end
		end
		
	elseif game_state == 3 then
		-- round clean up state		
		text_hand = "Clear Table"
		text_x = percent_width(0.5) - (f_width_clear/2)
		if input_enabled then 
			input_enabled = false
			change_game_state(1)
		end
	end
end

-- change the game state and draw the new state
-- param; new_state as integer
function change_game_state(new_state)
	if new_state == 1 then
		bet = 0
		chips = {chip_1,chip_5,chip_10,chip_50}
		for i = 1, 6 do
			card_p[i] = card_empty
			card_d[i] = card_empty
		end
		for i = 1,12 do
			card_b[i] = card_empty
		end
		for i = 1, 52 do
			used_cards[i] = false
		end
	elseif new_state == 2 then
		player_total = 0
		chips = {card_empty,card_empty,card_empty,card_empty}

	elseif new_state == 3 then
		for i = 1, #dealer_cards do
			card_d[i] = dealer_cards[i].img
			card_b[i+6] = card_boarder
		end
	end
	game_state = new_state
end

-- returns true if inx and iny is in a box
-- params; all integer values
function in_box(inx, iny, x, y, dx, dy)
	if ( inx > x and inx < (x + dx) ) and ( iny > y and iny < (y + dy) ) then
		return true	
	else
		return false
	end
end

-- returns the location on the screen as a digit based on a given percentage
-- params; percent (number 0 to 1)
function percent_height(percent)
	return math.floor(RESOLUTION_HEIGHT * RESOLUTION_MULTIPLIER * percent)
end

function percent_width(percent)
	return math.floor(RESOLUTION_WIDTH * RESOLUTION_MULTIPLIER * percent)
end

-- take a card from the deck list and removes it from the list 
-- returns a card object
function draw_card()
	local index = love.math.random(1,52)
	local cycle = 0
	while used_cards[index] == true and cycle < 52 do
		index = love.math.random(1,52)
		cycle = cycle + 1
	end
	used_cards[index] = true
	
	local card = table.copy(deck[index])	
	return card
end

-- table copy method
function table.copy(t)
  local ret = {}
  for k, v in pairs(t) do ret[k] = v end
  return setmetatable(ret, getmetatable(t))
end

-- debug keys
function love.keypressed(key)
	--[[if key == 'escape' then
		love.window.close()
	end]]
end