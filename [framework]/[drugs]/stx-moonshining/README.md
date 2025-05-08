# JC-Moonshining
The JC-Moonshining is a new and innovative moonshining script for RedM RSCore! It adds the availability and capability of being able to create any moonshine and mash you wish! Including adding several items that's not part of any ingredients, add a maximum and minimum of any ingredient. But don't take my word for it, watch the videos that has been made, both for the config and script itself for better explaination!

# Features
- Add as many ingredients for mash and moonshine you want
- Add as many items to be addable into the mash bucket, even if it don't match ingredients
- Make a max and a min amount for ingredients to match mash!
- Maintain the Moonshine still so it don't explode from overheating!
- Synchronize between all players
- Saved through database

## Items ##
If you don't wanna create your own items, you can use the items below, and put them in items.lua!

--## Moonshine Stuff ##--
-- Tools
['moonshinekit']     = {['name'] = 'moonshinekit',     ['label'] = 'Moonshine Kit',     ['weight'] = 5,  ['type'] = 'item', ['image'] = 'moonshine_kit.png',     ['unique'] = true, ['useable'] = true, ['shouldClose'] = true, ['combinable'] = nil, ['level'] = 0, ['description'] = 'Moonshine Kit'},
['moonshinebucket']  = {['name'] = 'moonshinebucket',  ['label'] = 'Moonshine Bucket',  ['weight'] = 3,  ['type'] = 'item', ['image'] = 'moonshine_bucket.png',  ['unique'] = false, ['useable'] = true, ['shouldClose'] = true, ['combinable'] = nil, ['level'] = 0, ['description'] = 'Moonshine Bucket'},
-- Fruits
['apple']            = {['name'] = 'apple',            ['label'] = 'Apple',            ['weight'] = 1,  ['type'] = 'item', ['image'] = 'apple.png',            ['unique'] = false, ['useable'] = true, ['shouldClose'] = true, ['combinable'] = nil, ['level'] = 0, ['description'] = 'Apple'},
['orange']           = {['name'] = 'orange',           ['label'] = 'Orange',           ['weight'] = 1,  ['type'] = 'item', ['image'] = 'orange.png',           ['unique'] = false, ['useable'] = true, ['shouldClose'] = true, ['combinable'] = nil, ['level'] = 0, ['description'] = 'Orange'},
['peach']            = {['name'] = 'peach',            ['label'] = 'Peach',            ['weight'] = 1,  ['type'] = 'item', ['image'] = 'peach.png',            ['unique'] = false, ['useable'] = true, ['shouldClose'] = true, ['combinable'] = nil, ['level'] = 0, ['description'] = 'Peach'},
['blackberry']       = {['name'] = 'blackberry',       ['label'] = 'Blackberry',       ['weight'] = 1,  ['type'] = 'item', ['image'] = 'blackberry.png',       ['unique'] = false, ['useable'] = true, ['shouldClose'] = true, ['combinable'] = nil, ['level'] = 0, ['description'] = 'Blackberry'},
-- Mash
['applemash']        = {['name'] = 'applemash',        ['label'] = 'Apple Mash',        ['weight'] = 2,  ['type'] = 'item', ['image'] = 'apple_mash.png',        ['unique'] = true, ['useable'] = true, ['shouldClose'] = true, ['combinable'] = nil, ['level'] = 0, ['description'] = 'Apple Mash'},
['blackberrymash']   = {['name'] = 'blackberrymash',   ['label'] = 'Blackberry Mash',   ['weight'] = 2,  ['type'] = 'item', ['image'] = 'blackberry_mash.png',   ['unique'] = true, ['useable'] = true, ['shouldClose'] = true, ['combinable'] = nil, ['level'] = 0, ['description'] = 'Blackberry Mash'},
['fruitpunchmash']   = {['name'] = 'fruitpunchmash',   ['label'] = 'Fruit Punch Mash',  ['weight'] = 2,  ['type'] = 'item', ['image'] = 'fruitpunch_mash.png',   ['unique'] = true, ['useable'] = true, ['shouldClose'] = true, ['combinable'] = nil, ['level'] = 0, ['description'] = 'Fruit Punch Mash'},
['cornmash']         = {['name'] = 'cornmash',         ['label'] = 'Corn Mash',         ['weight'] = 2,  ['type'] = 'item', ['image'] = 'corn_mash.png',         ['unique'] = true, ['useable'] = true, ['shouldClose'] = true, ['combinable'] = nil, ['level'] = 0, ['description'] = 'Corn Mash'},
['peachmash']        = {['name'] = 'peachmash',        ['label'] = 'Peach Mash',        ['weight'] = 2,  ['type'] = 'item', ['image'] = 'peach_mash.png',        ['unique'] = true, ['useable'] = true, ['shouldClose'] = true, ['combinable'] = nil, ['level'] = 0, ['description'] = 'Peach Mash'},
['potatomash']       = {['name'] = 'potatomash',       ['label'] = 'Potato Mash',       ['weight'] = 2,  ['type'] = 'item', ['image'] = 'potato_mash.png',       ['unique'] = true, ['useable'] = true, ['shouldClose'] = true, ['combinable'] = nil, ['level'] = 0, ['description'] = 'Potato Mash'},
['specialmash']       = {['name'] = 'specialmash',       ['label'] = 'Special Mash',       ['weight'] = 2,  ['type'] = 'item', ['image'] = 'specialmash.png',       ['unique'] = true, ['useable'] = true, ['shouldClose'] = true, ['combinable'] = nil, ['level'] = 0, ['description'] = 'Special Mash'},
['unknownmash']       = {['name'] = 'unknownmash',       ['label'] = 'Unknown Mash',       ['weight'] = 2,  ['type'] = 'item', ['image'] = 'unknownmash.png',       ['unique'] = true, ['useable'] = true, ['shouldClose'] = true, ['combinable'] = nil, ['level'] = 0, ['description'] = 'Unknown Mash'},
-- Moonshine
['potato_moonshine'] = {['name'] = 'potato_moonshine', ['label'] = 'Potato Moonshine',  ['weight'] = 3,  ['type'] = 'item', ['image'] = 'potato_moonshine.png',  ['unique'] = true, ['useable'] = true, ['shouldClose'] = true, ['combinable'] = nil, ['level'] = 0, ['description'] = 'Potato Moonshine'},
['apple_moonshine']  = {['name'] = 'apple_moonshine',  ['label'] = 'Apple Moonshine',   ['weight'] = 3,  ['type'] = 'item', ['image'] = 'apple_moonshine.png',   ['unique'] = true, ['useable'] = true, ['shouldClose'] = true, ['combinable'] = nil, ['level'] = 0, ['description'] = 'Apple Moonshine'},
['peach_moonshine']  = {['name'] = 'peach_moonshine',  ['label'] = 'Peach Moonshine',   ['weight'] = 3,  ['type'] = 'item', ['image'] = 'peach_moonshine.png',   ['unique'] = true, ['useable'] = true, ['shouldClose'] = true, ['combinable'] = nil, ['level'] = 0, ['description'] = 'Apple Moonshine'},
['blackberry_moonshine'] = {['name'] = 'blackberry_moonshine', ['label'] = 'Blackberry Moonshine', ['weight'] = 3, ['type'] = 'item', ['image'] = 'blackberry_moonshine.png', ['unique'] = true, ['useable'] = true, ['shouldClose'] = true, ['combinable'] = nil, ['level'] = 0, ['description'] = 'Blackberry Moonshine'},
['fruitpunch_moonshine'] = {['name'] = 'fruitpunch_moonshine', ['label'] = 'Fruit Punch Moonshine', ['weight'] = 3, ['type'] = 'item', ['image'] = 'fruitpunch_moonshine.png', ['unique'] = true, ['useable'] = true, ['shouldClose'] = true, ['combinable'] = nil, ['level'] = 0, ['description'] = 'Fruit Punch Moonshine'},
['cornmoonshine']          = {['name'] = 'cornmoonshine',          ['label'] = 'Corn Moonshine',           ['weight'] = 100, ['type'] = 'item', ['image'] = 'moonshine.png',        ['unique'] = false, ['useable'] = true, ['shouldClose'] = true, ['combinable'] = nil, ['level'] = 0, ['description'] = 'best moonshine in town'},
['specialmoonshine']          = {['name'] = 'specialmoonshine',          ['label'] = 'Special Moonshine',           ['weight'] = 100, ['type'] = 'item', ['image'] = 'specialmoonshine.png',        ['unique'] = false, ['useable'] = true, ['shouldClose'] = true, ['combinable'] = nil, ['level'] = 0, ['description'] = 'best moonshine in town'},
['unknownmoonshine']          = {['name'] = 'unknownmoonshine',          ['label'] = 'Unknown Moonshine',           ['weight'] = 100, ['type'] = 'item', ['image'] = 'unknownmoonshine.png',        ['unique'] = false, ['useable'] = true, ['shouldClose'] = true, ['combinable'] = nil, ['level'] = 0, ['description'] = 'best moonshine in town'},