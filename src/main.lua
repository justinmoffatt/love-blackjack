-- blackjack game


function love.load()
	Card = require 'card'
	-- the types of cards in a deck
	VALUES = {11,2,3,4,5,6,7,8,9,10,10,10,10}
	FACES = {'a','2','3','4','5','6','7','8','9','10','j','q','k'}
	SUITS = {'spades','clubs','hearts','diamonds'}

	-- the screen size
	RESOLUTION_MULTIPLIER = 120
	RESOLUTION_HEIGHT = 16
	RESOLUTION_WIDTH = 9

	-- game managers
	game_state = 0

	-- vars
	bet = 0
	bank = 0
	input_x = 0
	input_y = 0

	-- creates a deck of 52 cards
	deck = {}
	local i = 0
	for suit = 0, 3, 1 do
		for value = 0, 12, 1 do
			deck[i] = Card:new(SUITS[suit], FACES[value], VALUES[value])
			local i = i + 1
		end
	end

	bank = 50

	-- images for the coin/chips that are used for user input
	chip_1 	= love.graphics.newImage('img/chip_1.png')
	chip_5 	= love.graphics.newImage('img/chip_5.png')
	chip_10 = love.graphics.newImage('img/chip_10.png')
	chip_50 = love.graphics.newImage('img/chip_50.png')

	-- setup the card images 
	--[[
	card_image = {}
	card_image[0] = love.graphics.newImage('img/card_empty.png')
	for i = 1, 52, 1 do  		-- this is just a lazy way to add all 52 card images
		card_image[i] = love.graphics.newImage('img/card_' + tostring(i) + '.png')
	end
	]]
end

function love.draw()
	love.graphics.setBackgroundColor(0, 155, 30)
end

function love.touchpressed(x,y)
	-- get input
	if x == nil or y == nil then
		input_x = 0
		input_y = 0
	else
		input_x = x
		input_y = y
	end
end	


function love.update(dt)

	-- game logic
	if game_state == 0 then				-- pause state
		change_game_state(1)


	elseif game_state == 1 then 		-- betting state
		-- add to bet
		if input_enable then
			if in_box(input_x, input_y, 0, 0, percent_width(0.25), percent_width(0.25)) and bank > 0 then
				bet = bet + 1
			elseif in_box(input_x, input_y, percent_width(0.25), 0, percent_width(0.25), percent_width(0.25)) and bank > 4 then
				bet = bet + 5
			elseif in_box(input_x, input_y, percent_width(0.50), 0, percent_width(0.25), percent_width(0.25)) and bank > 9 then
				bet = bet + 10
			elseif in_box(input_x, input_y, percent_width(0.75), 0, percent_width(0.25), percent_width(0.25)) and bank > 49 then
				bet = bet + 50
			elseif in_box(input_x, input_y, 0, percent_width(0.25), percent_width(1), percent_height(0.5)) then
				change_game_state(2)
			end
			bank = bank - bet
			input_enable = false
		-- reset the input tracker
		else
			if input == nil then
				input_enable = true
			end
		end

	elseif game_state == 2 then 		-- card getting state
		-- logic for the deaing
		if player_total == 0 then	-- this is the init state
			player_cards = {}
			player_cards[0] = draw_card()
			player_cards[1] = draw_card()
			local player_total = player_cards[0].value + player_cards[1].value

			-- work the dealer
			dealer_cards = {}
			dealer_cards[0] = draw_card()
			dealer_cards[1] = draw_card()
			local dealer_total = dealer_cards[0].value + dealer_cards[1].value
			while dealer_count < 17 do
				dealer_cards[#dealer_cards] = draw_card()
				dealer_total = dealer_total + dealer_cards[#dealer_cards-1].value
			end

		elseif player_total == 21 then 								-- Player wins with natural 21
			bank = bank + (bet * 2)
			love.graphics.print("Player wins", 10, 10)
			hang(1000)
			change_game_state(1)
			player_total = 0
		
		elseif player_total < 21 and in_box(input_x, input_y, 0, percent_width(0.25), percent_width(1), percent_height(0.5)) and input_enabled then -- hit player
			input_enabled = false
			-- work the player
			player_cards[#player_cards] = draw_card()
			player_total = 0
			local cards_string = "Hand: "
			for c in player_cards do
				cards_string = cards_string + "; " + c.face 
				player_total = player_total + c.value
			end
			love.graphics.print(cards_string,10,10)
			love.graphics.print('Dealer: ' .. dealer_cards[0].face,10,20)

		elseif player_total > 21 and dealer_total > 21 then 		-- both went over 21
			love.graphics.print("Both over 21", 10, 10)
			hang(1000)
			change_game_state(1)

		elseif player_total > 21 and dealer_total < 22 then 		-- player over
			love.graphics.print("Over 21",10,10)
			hang(1000)
			change_game_state(1)

		elseif in_box(input_x, input_y, 0, percent_width(0.25), percent_width(1), percent_height(0.5)) and input_enabled then	-- hit done 
			if player_total > dealer_total and dealer_total < 22 then
				bank = bank + (bet * 2)
				love.graphics.print("Player wins", 10, 10)
				hang(1000)
				change_game_state(1)
			else 
				love.graphics.print("Dealer wins", 10, 10)
				hang(1000)
				change_game_state(1)
			end

		elseif input_enabled == false then 							-- reset input checker
			if input == nil then
				input_enable = true
			end
		end
		
	elseif game_state == 3 then
		-- round clean up state		
	end
end

function hang(i)
	for i = 0, i, 1 do
		i = i + 1
	end
end

-- change the game state and draw the new state
function change_game_state(new_state)
	if new_state == 1 then
		love.graphics.print("Current bet: ", 10, 10)
	elseif new_state == 2 then
		player_total = 0
	end

	game_state = new_state
end

-- returns true if inx and iny is in a box
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

function draw_card()
	local index = love.math.random(0,51)
	local cycle = 0
	while deck[index] == not nil and cycle < 52 do
		index = love.math.random(0,51)
		cycle = cycle + 1
	end
	local card = deck[index]
	deck[index] = nil
	
	return card
end