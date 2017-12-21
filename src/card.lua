-- a card object; holds a suit and value

Card = {}
Card.__index = card

function Card:new(suit, face, value)
	local card = {}
	local suit = suit
	local value = value
	local face = face
	setmetatable(card,Card)
	return card
end

function Card:get_value()
	return self.value
end

function Card:get_suit()
	return self.suit
end

return Card