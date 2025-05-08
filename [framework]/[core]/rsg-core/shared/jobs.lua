RSGShared = RSGShared or {}
RSGShared.ForceJobDefaultDutyAtLogin = true -- true: Force duty state to jobdefaultDuty | false: set duty state from database last saved
RSGShared.Jobs = {

    unemployed = {
        label = 'Civilian',
        defaultDuty = true,
        offDutyPay = false,
        grades = {
            ['0'] = { name = 'Freelancer', payment = 3 },
        },
    },
    vallaw = {
        label = 'Valentine Law Enforcement',
        type = 'leo',
        defaultDuty = false,
        offDutyPay = false,
        grades = {
            ['0'] = { name = 'Recruit', payment = 10 },
            ['1'] = { name = 'Deputy', payment = 25 },
            ['2'] = { name = 'Sheriff', isboss = true, payment = 50 },
        },
    },
    rholaw = {
        label = 'Rhodes Law Enforcement',
        type = 'leo',
        defaultDuty = false,
        offDutyPay = false,
        grades = {
            ['0'] = { name = 'Recruit', payment = 10 },
            ['1'] = { name = 'Deputy', payment = 25 },
            ['2'] = { name = 'Sheriff', isboss = true, payment = 50 },
        },
    },
    blklaw = {
        label = 'Blackwater Law Enforcement',
        type = 'leo',
        defaultDuty = false,
        offDutyPay = false,
        grades = {
            ['0'] = { name = 'Recruit', payment = 10 },
            ['1'] = { name = 'Deputy', payment = 25 },
            ['2'] = { name = 'Sheriff', isboss = true, payment = 50 },
        },
    },
    strlaw = {
        label = 'Strawberry Law Enforcement',
        type = 'leo',
        defaultDuty = false,
        offDutyPay = false,
        grades = {
            ['0'] = { name = 'Recruit', payment = 10 },
            ['1'] = { name = 'Deputy', payment = 25 },
            ['2'] = { name = 'Sheriff', isboss = true, payment = 50 },
        },
    },
    stdenlaw = {
        label = 'Saint Denis Law Enforcement',
        type = 'leo',
        defaultDuty = false,
        offDutyPay = false,
        grades = {
            ['0'] = { name = 'Recruit', payment = 10 },
            ['1'] = { name = 'Deputy', payment = 25 },
            ['2'] = { name = 'Sheriff', isboss = true, payment = 50 },
        },
    },
    medic = {
        label = 'Medic',
        type = 'medic',
        defaultDuty = false,
        offDutyPay = false,
        grades = {
            ['0'] = { name = 'Recruit', payment = 5 },
            ['1'] = { name = 'Trainee', payment = 25 },
            ['2'] = { name = 'Doctor',  payment = 50 },
            ['3'] = { name = 'Surgeon', payment = 75 },
            ['4'] = { name = 'Manager', isboss = true, payment = 100 },
        },
    },

    ['govenor1'] = {
        label = 'Govenor New Hanover',
        defaultDuty = true,
        offDutyPay = false,
        grades = {
            ['0'] = {
                name = 'Govenor',
                payment = 100
            },
        },
    },
    ['govenor2'] = {
        label = 'Govenor West Elizabeth',
        defaultDuty = true,
        offDutyPay = false,
        grades = {
            ['0'] = {
                name = 'Govenor',
                payment = 100
            },
        },
    },
    ['govenor3'] = {
        label = 'Govenor New Austin',
        defaultDuty = true,
        offDutyPay = false,
        grades = {
            ['0'] = {
                name = 'Govenor',
                payment = 100
            },
        },
    },
    ['govenor4'] = {
        label = 'Govenor Ambarino',
        defaultDuty = true,
        offDutyPay = false,
        grades = {
            ['0'] = {
                name = 'Govenor',
                payment = 100
            },
        },
    },
    ['govenor5'] = {
        label = 'Govenor Lemoyne',
        defaultDuty = true,
        offDutyPay = false,
        grades = {
            ['0'] = {
                name = 'Govenor',
                payment = 100
            },
        },
    },

    ['valsaloon'] = {
        label = 'Valentine Saloon',
        type = 'saloon',
        defaultDuty = false,
        offDutyPay = false,
        grades = {
            ['0'] = { name = 'Recruit', payment = 10 },
            ['1'] = { name = 'Tender', payment = 15 },
            ['2'] = { name = 'Manager', isboss = true, payment = 25 },
        },
    },
    ['blasaloon'] = {
        label = 'Blackwater Saloon',
        type = 'saloon',
        defaultDuty = false,
        offDutyPay = false,
        grades = {
            ['0'] = { name = 'Recruit', payment = 10 },
            ['1'] = { name = 'Tender', payment = 15 },
            ['2'] = { name = 'Manager', isboss = true, payment = 25 },
        },
    },
    ['rhosaloon'] = {
        label = 'Rhodes Saloon',
        type = 'saloon',
        defaultDuty = false,
        offDutyPay = false,
        grades = {
            ['0'] = { name = 'Recruit', payment = 10 },
            ['1'] = { name = 'Tender', payment = 15 },
            ['2'] = { name = 'Manager', isboss = true, payment = 25 },
        },
    },
    ['doysaloon'] = {
        label = 'Doyles Taven',
        type = 'saloon',
        defaultDuty = false,
        offDutyPay = false,
        grades = {
            ['0'] = { name = 'Recruit', payment = 10 },
            ['1'] = { name = 'Tender', payment = 15 },
            ['2'] = { name = 'Manager', isboss = true, payment = 25 },
        },
    },
    ['bassaloon'] = {
        label = 'Bastille Saloon',
        type = 'saloon',
        defaultDuty = false,
        offDutyPay = false,
        grades = {
            ['0'] = { name = 'Recruit', payment = 10 },
            ['1'] = { name = 'Tender', payment = 15 },
            ['2'] = { name = 'Manager', isboss = true, payment = 25 },
        },
    },
    ['oldsaloon'] = {
        label = 'Old Light Saloon',
        type = 'saloon',
        defaultDuty = false,
        offDutyPay = false,
        grades = {
            ['0'] = { name = 'Recruit', payment = 10 },
            ['1'] = { name = 'Tender', payment = 15 },
            ['2'] = { name = 'Manager', isboss = true, payment = 25 },
        },
    },
    ['armsaloon'] = {
        label = 'Armadillo Saloon',
        type = 'saloon',
        defaultDuty = false,
        offDutyPay = false,
        grades = {
            ['0'] = { name = 'Recruit', payment = 10 },
            ['1'] = { name = 'Tender', payment = 15 },
            ['2'] = { name = 'Manager', isboss = true, payment = 25 },
        },
    },
    ['tumsaloon'] = {
        label = 'Tumbleweed Saloon',
        type = 'saloon',
        defaultDuty = false,
        offDutyPay = false,
        grades = {
            ['0'] = { name = 'Recruit', payment = 10 },
            ['1'] = { name = 'Tender', payment = 15 },
            ['2'] = { name = 'Manager', isboss = true, payment = 25 },
        },
    },


        --- Trainers
        ['valentinehorsetrainer'] = {
            label = 'Valentine Horse Trainer',
            defaultDuty = true,
            offDutyPay = false,
            grades = {
                ['0'] = {
                    name = 'Trainee',
                    payment = 25
                },
                ['1'] = {
                    name = 'Master',
                    isboss = true,
                    payment = 75
                },
            },
        },
        ['blackwaterhorsetrainer'] = {
            label = 'Blackwater Horse Trainer',
            defaultDuty = true,
            offDutyPay = false,
            grades = {
                ['0'] = {
                    name = 'Trainee',
                    payment = 25
                },
                ['1'] = {
                    name = 'Master',
                    isboss = true,
                    payment = 75
                },
            },
        },
        ['strawberryhorsetrainer'] = {
            label = 'Strawberry Horse Trainer',
            defaultDuty = true,
            offDutyPay = false,
            grades = {
                ['0'] = {
                    name = 'Trainee',
                    payment = 25
                },
                ['1'] = {
                    name = 'Master',
                    isboss = true,
                    payment = 75
                },
            },
        },
        ['saintdenishorsetrainer'] = {
            label = 'SaintDenis Horse Trainer',
            defaultDuty = true,
            offDutyPay = false,
            grades = {
                ['0'] = {
                    name = 'Trainee',
                    payment = 25
                },
                ['1'] = {
                    name = 'Master',
                    isboss = true,
                    payment = 75
                },
            },
        },
        ['rhodeshorsetrainer'] = {
            label = 'Rhodes Horse Trainer',
            defaultDuty = true,
            offDutyPay = false,
            grades = {
                ['0'] = {
                    name = 'Trainee',
                    payment = 25
                },
                ['1'] = {
                    name = 'Master',
                    isboss = true,
                    payment = 75
                },
            },
        },
        ['tumbleweedhorsetrainer'] = {
            label = 'TumbleWeed Horse Trainer',
            defaultDuty = true,
            offDutyPay = false,
            grades = {
                ['0'] = {
                    name = 'Trainee',
                    payment = 25
                },
                ['1'] = {
                    name = 'Master',
                    isboss = true,
                    payment = 75
                },
            },
        },

        --- breeders
        ['valentinehorsebreeder'] = {
            label = 'Valentine Horse Breeder',
            defaultDuty = true,
            offDutyPay = false,
            grades = {
                ['0'] = {
                    name = 'Trainee',
                    payment = 25
                },
                ['1'] = {
                    name = 'Master',
                    isboss = true,
                    payment = 75
                },
            },
        },
        ['blackwaterhorsebreeder'] = {
            label = 'Blackwater Horse Breeder',
            defaultDuty = true,
            offDutyPay = false,
            grades = {
                ['0'] = {
                    name = 'Trainee',
                    payment = 25
                },
                ['1'] = {
                    name = 'Master',
                    isboss = true,
                    payment = 75
                },
            },
        },
        ['strawberryhorsebreeder'] = {
            label = 'Strawberry Horse Breeder',
            defaultDuty = true,
            offDutyPay = false,
            grades = {
                ['0'] = {
                    name = 'Trainee',
                    payment = 25
                },
                ['1'] = {
                    name = 'Master',
                    isboss = true,
                    payment = 75
                },
            },
        },
        ['saintdenishorsebreeder'] = {
            label = 'SaintDenis Horse Breeder',
            defaultDuty = true,
            offDutyPay = false,
            grades = {
                ['0'] = {
                    name = 'Trainee',
                    payment = 25
                },
                ['1'] = {
                    name = 'Master',
                    isboss = true,
                    payment = 75
                },
            },
        },
        ['rhodeshorsebreeder'] = {
            label = 'Rhodes Horse Breeder',
            defaultDuty = true,
            offDutyPay = false,
            grades = {
                ['0'] = {
                    name = 'Trainee',
                    payment = 25
                },
                ['1'] = {
                    name = 'Master',
                    isboss = true,
                    payment = 75
                },
            },
        },
        ['tumbleweedhorsebreeder'] = {
            label = 'TumbleWeed Horse Breeder',
            defaultDuty = true,
            offDutyPay = false,
            grades = {
                ['0'] = {
                    name = 'Trainee',
                    payment = 25
                },
                ['1'] = {
                    name = 'Master',
                    isboss = true,
                    payment = 75
                },
            },
        },
    
    
        --- Weapon smiths
        ['valweaponsmith'] = { --valentine
            label = 'Valentine Weaponsmith',
            defaultDuty = true,
            offDutyPay = false,
            grades = {
                ['0'] = { name = 'Trainee', payment = 25 },
                ['1'] = { name = 'Master', isboss = true, payment = 75 },
            },
        },
        ['rhoweaponsmith'] = { -- rhodes
            label = 'Rhodes Weaponsmith',
            defaultDuty = true,
            offDutyPay = false,
            grades = {
                ['0'] = { name = 'Trainee', payment = 25 },
                ['1'] = { name = 'Master', isboss = true, payment = 75 },
            },
        },
        ['stdweaponsmith'] = { -- Saint Denis
            label = 'Saint Weaponsmith',
            defaultDuty = true,
            offDutyPay = false,
            grades = {
                ['0'] = { name = 'Trainee', payment = 25 },
                ['1'] = { name = 'Master', isboss = true, payment = 75 },
            },
        },
        ['tumweaponsmith'] = { -- rhodes
            label = 'TumbleWeed Weaponsmith',
            defaultDuty = true,
            offDutyPay = false,
            grades = {
                ['0'] = { name = 'Trainee', payment = 25 },
                ['1'] = { name = 'Master', isboss = true, payment = 75 },
            },
        },
        ['annweaponshop'] = { -- rhodes
            label = 'Annesburg Weaponsmith',
            defaultDuty = true,
            offDutyPay = false,
            grades = {
                ['0'] = { name = 'Trainee', payment = 25 },
                ['1'] = { name = 'Master', isboss = true, payment = 75 },
            },
        },
    
    
        ---- Blacksmiths
        ['valblacksmith'] = { --valentine
            label = 'Valentine Blacksmith',
            defaultDuty = true,
            offDutyPay = false,
            grades = {
                ['0'] = { name = 'Trainee', payment = 25 },
                ['1'] = { name = 'Master', isboss = true, payment = 75 },
            },
        },
    
        ['blablacksmith'] = { --valentine
            label = 'Blackwater Blacksmith',
            defaultDuty = true,
            offDutyPay = false,
            grades = {
                ['0'] = { name = 'Trainee', payment = 25 },
                ['1'] = { name = 'Master', isboss = true, payment = 75 },
            },
        },
    
        ['stblacksmith'] = { --valentine
            label = 'SaintDenis Blacksmith',
            defaultDuty = true,
            offDutyPay = false,
            grades = {
                ['0'] = { name = 'Trainee', payment = 25 },
                ['1'] = { name = 'Master', isboss = true, payment = 75 },
            },
        },
    
        ['tumblacksmith'] = { --valentine
            label = 'Tummble Blacksmith',
            defaultDuty = true,
            offDutyPay = false,
            grades = {
                ['0'] = { name = 'Trainee', payment = 25 },
                ['1'] = { name = 'Master', isboss = true, payment = 75 },
            },
        },


}
