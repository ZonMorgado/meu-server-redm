local Translations = {

    lang_0 = 'Open Blacksmith Menu',
    lang_1 = 'Blacksmith Menu',
    lang_2 = 'Crafting Menu',
    lang_3 = 'craft items to add to your stock',
    lang_4 = 'Blacksmith Storage',
    lang_5 = 'storage for blacksmith',
    lang_6 = 'Boss Menu',
    lang_7 = 'open boss menu',
    lang_8 = 'you are not authorised!',
    lang_9 = 'Craft Item',
    lang_10 = 'Explore the crafing options for ',
    lang_11 = 'Crafting : ',
    lang_12 = "You don\'t have the required items!",

	-- shop
    lang_s1 = 'Open Blacksmith Shop',
    lang_s2 = 'Blacksmith Shop Owner Menu',
    lang_s3 = 'View Shop Items',
    lang_s4 = 'view the blacksmith shop items',
    lang_s5 = 'Refill Blacksmith Shop',
    lang_s6 = 'refill your stock',
    lang_s7 = 'View Blacksmith Money',
    lang_s8 = 'check and withdraw blacksmith shop money',
    lang_s9 = 'Blacksmith Shop Customer Menu',
    lang_s10 = 'Blacksmith Shop',
    lang_s11 = 'view items for sale',
    lang_s12 = 'Unit price: $',
    lang_s13 = 'Shop Menu',
    lang_s14 = 'Blacksmith Stock',
    lang_s15 = 'How many?',
    lang_s16 = 'must have the amount in your inventory',
    lang_s17 = 'Sell Price',
    lang_s18 = 'example: 0.10',
    lang_s19 = 'Something went wrong, check you have the correct amount and price!',
    lang_s20 = 'Invalid Amount',
    lang_s21 = 'Balance : $',
    lang_s22 = 'Withdraw money',
    lang_s23 = 'The money will be given to you in cash!',
    lang_s24 = 'Max Withdraw: $',
    lang_s25 = '(case sensitive box)',
    lang_s26 = 'added to blacksmith shop',
    lang_s27 = 'added to blacksmith shop',
    lang_s28 = 'You lack money',
    lang_s29 = 'No Items',
    lang_s30 = 'no stock items to add',
    lang_s31 = 'stock replenishment',

}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})

-- Lang:t('lang_0')