--
-- Project: world.lua
-- Description: 
--
-- Version: 1.0
-- Managed with http://CoronaProjectManager.com
--
-- Copyright 2012 . All Rights Reserved.
-- 
module(..., package.seeall)

SpriteColection={}

function AddSprites(self)

	




-- food
SpriteColection[#SpriteColection + 1] = {type="body",  subtype="food", title="Cheese",image="cheese.png", 
    description="Cheese gives you +20% to energy.", 
    apxprice=10,
    shape = {   12, 7  ,  -12, 7  ,  -12, -4  ,  12, -7  },thumbnailYoffset=20,
    width=24, height=14,  energyvalue=200, density=5.0, friction=1, bounce=0.2, radius=-1,x=0,flysound=4,hitsound=5,volume=50,
    icon_width=32,icon_height=22
    }

SpriteColection[#SpriteColection + 1] = {type="body",  subtype="food", title="Watermelon",image="watermelon.png", description="Watermelon gives you +5% to energy.",               
    apxprice=6,thumbnailYoffset=5,
    energyvalue=50, width=32, height=33,density=0.5, friction=1, bounce=0.5, radius=16,x=0,flysound=2,hitsound=3,volume=40,
    icon_width=36,icon_height=36}

SpriteColection[#SpriteColection + 1] = {type="body",  subtype="food", title="Tomato",image="tomato.png",description="Tomato gives you +7% to energy.", 
    apxprice=4,thumbnailYoffset=5,
    energyvalue=70, width=24, height=24,density=0.5, friction=1, bounce=0.5, radius=12,x=0,flysound=2,hitsound=3,volume=40,
    icon_width=34,icon_height=34
    }	

SpriteColection[#SpriteColection + 1] = {type="body",  subtype="food", title="Apple",image="apple.png",description="Apple gives you +11% to energy.",                         
    apxprice=5,thumbnailYoffset=5,
    energyvalue=110, width=24, height=24,density=0.5, friction=1, bounce=0.5, radius=12,x=0,flysound=2,hitsound=3,volume=40,
    icon_width=30,icon_height=34}	--r=12

SpriteColection[#SpriteColection + 1] = {type="body",  subtype="food", title="Peach",image="peach.png",description="Peach gives you +10% to energy.",                         
    apxprice=3,thumbnailYoffset=5,
    energyvalue=100, width=26, height=28,density=0.5, friction=1, bounce=0.5, radius=13,x=0,flysound=2,hitsound=3,volume=40}	--r=12

SpriteColection[#SpriteColection + 1] = {type="body",  subtype="food", title="Pinapple",image="pinapple.png",
        description="Pinapple gives you +8% to energy.",                   energyvalue=80, 
        apxprice=3,
        shape = {   6, -7  ,  11, 6  ,  4, 18  ,  -3, 18  ,  -11, 6  ,  -7, -7  },thumbnailYoffset=5,
        width=22, height=36,density=0.5, friction=1, bounce=0.5, radius=0,x=0,flysound=2,hitsound=3,volume=40,
        icon_width=22,icon_height=36}	--r=12

SpriteColection[#SpriteColection + 1] = {type="body",  subtype="food", title="Strawberry",image="strawberry.png",     
    apxprice=7,
    description="Strawberry gives you +15% to energy.",          energyvalue=150,
    shape = {   -8, 3  ,  -7, -6  ,  0, -8  ,  7, -6  ,  8, 3  ,  0, 10  },thumbnailYoffset=5,
    width=18, height=20,density=0.5, friction=1, bounce=0.5, radius=0,x=0,flysound=2,hitsound=3,volume=40,
    icon_width=34,icon_height=36
    }	--r=12



--coins
SpriteColection[#SpriteColection + 1] = {type="body",  subtype="coin", title="CoinGold",image="coin.png", moneyvalue=100, fillcolor={255,200,10,255}, width=26, height=26,density=8,bounce=0.3, friction=10, bounce=0.5, radius=13,x=0,flysound=2,hitsound=7,volume=2}	
SpriteColection[#SpriteColection + 1] = {type="body",  subtype="coin", title="CoinSilver",image="coin.png", moneyvalue=20, width=26, height=26,  density=7,bounce=0.3,friction=10, radius=13,x=0,flysound=2,hitsound=7,volume=2}	
SpriteColection[#SpriteColection + 1] = {type="body",  subtype="coin", title="CoinBronze",image="coin.png", moneyvalue=5, fillcolor={240,110,50,255}, width=26, height=26,density=6, bounce=0.3,friction=10, bounce=0.5, radius=13,x=0,flysound=2,hitsound=7,volume=2}	


-- boxes
SpriteColection[#SpriteColection + 1] = {type="body",  subtype="box", title="WoodenBox",image="wooden_box.png",                width=32, height=32,density=0.3, friction=1, bounce=0.1, radius=0,x=0,flysound=2,hitsound=1,volume=40}	--r=12
SpriteColection[#SpriteColection + 1] = {type="body",  subtype="box", title="TNTBox",image="tnt_box.png",                width=32, height=32,density=2.5, friction=1, bounce=0.1, radius=0,x=0,flysound=2,hitsound=1,volume=40}	--r=12
SpriteColection[#SpriteColection + 1] = {type="body",  subtype="box", title="SteelBox",image="steel_box.png",                width=32, height=32,density=7.8, friction=1, bounce=0.1, radius=0,x=0,flysound=2,hitsound=2,volume=40}	--r=12
SpriteColection[#SpriteColection + 1] = {type="body",  subtype="box", title="ClayBox",image="clay_box.png",                width=32, height=32,density=2.9, friction=1, bounce=0.1, radius=0,x=0,flysound=2,hitsound=3,volume=40}	--r=12
SpriteColection[#SpriteColection + 1] = {type="body",  subtype="box", title="StoneBox",image="stone_box.png",                width=32, height=32,density=2.6, friction=1, bounce=0.1, radius=0,x=0,flysound=2,hitsound=3,volume=40}	--r=12
SpriteColection[#SpriteColection + 1] = {type="body",  subtype="box", title="GlassBox",image="glass_box.png",                width=32, height=32,density=2.2, friction=1, bounce=0.1, radius=0,x=0,flysound=2,hitsound=2,volume=40}	--r=12
SpriteColection[#SpriteColection + 1] = {type="body",  subtype="box", title="MetalBox",image="metal_box.png",                width=32, height=32,density=2.7, friction=1, bounce=0.1, radius=0,x=0,flysound=2,hitsound=2,volume=40}	--r=12


--long bars
SpriteColection[#SpriteColection + 1] = {type="body",  subtype="longbar", title="WoodenBar_1x5",image="wooden_bar.png",                width=30, height=156,density=0.7, friction=1, bounce=0.1, radius=0,x=0,flysound=2,hitsound=1,volume=40}
SpriteColection[#SpriteColection + 1] = {type="body",  subtype="longbar", title="WoodenBar_1x4",image="wooden_bar_1x4.png",                width=31, height=124,density=0.5, friction=1, bounce=0.1, radius=0,x=0,flysound=2,hitsound=1,volume=40}
SpriteColection[#SpriteColection + 1] = {type="body",  subtype="longbar", title="WoodenBar_1x3",image="wooden_bar_1x3.png",                width=31, height=94,density=0.5, friction=1, bounce=0.1, radius=0,x=0,flysound=2,hitsound=1,volume=40}
SpriteColection[#SpriteColection + 1] = {type="body",  subtype="longbar", title="WoodenBar_05x4",image="wooden_bar_05x4.png",                width=15, height=124,density=0.5, friction=1, bounce=0.1, radius=0,x=0,flysound=2,hitsound=1,volume=40}

SpriteColection[#SpriteColection + 1] = {type="body",  subtype="longbar", title="MetalBar_4x1",image="metalbar_4x1.png",
    shape={-63,-15,63,-15,63,15,-63,15},
                    width=128, height=32,density=3, friction=1, bounce=0.1, radius=0,x=0,flysound=2,hitsound=3,volume=40}

SpriteColection[#SpriteColection + 1] = {type="body",  subtype="longbar", title="MetalBar_3x1",image="metalbar_3x1.png",                
    shape={-47,-15,47,-15,47,15,-47,15},
    width=96, height=32,density=3, friction=1, bounce=0.1, radius=0,x=0,flysound=2,hitsound=2,volume=40}

SpriteColection[#SpriteColection + 1] = {type="body",  subtype="longbar", title="MetalBar_2x1",image="metalbar_2x1.png",                
    shape={-31,-15,31,-15,31,15,-31,15},
    width=64, height=32,density=3, friction=1, bounce=0.1, radius=0,x=0,flysound=2,hitsound=2,volume=40}


SpriteColection[#SpriteColection + 1] = {type="body",  subtype="longbar", title="Log_4x1",image="log_4x1.png",                width=124, height=31,density=0.5, friction=1, bounce=0.1, radius=0,x=0,flysound=2,hitsound=1,volume=40}
SpriteColection[#SpriteColection + 1] = {type="body",  subtype="rock", title="LargeRoundRock",image="large_round_rock.png",                width=64, height=64,density=1, friction=1, bounce=0.3, radius=30,x=0,flysound=2,hitsound=3,volume=40}
SpriteColection[#SpriteColection + 1] = {type="body",  subtype="rock", title="HugeRoundRock",image="huge_round_rock.png",                width=124, height=124,density=1, friction=1, bounce=0.3, radius=62,x=0,flysound=2,hitsound=3,volume=40}

-- large boxes
SpriteColection[#SpriteColection + 1] = {type="body",  subtype="box", title="LargeBox",image="large_boxes.png",                width=62, height=62,density=0.6, friction=1, bounce=0.1, radius=0,x=0,flysound=2,hitsound=1,volume=40}	--r=12


-- Bags
SpriteColection[#SpriteColection + 1] = {type="body",  subtype="bag", title="SmallBackpack",image="backpack_small.png",  
    apxprice=50,isLargeObject=true,
    description="Small backpack, may hold up to 5 items.",       
    shape = {   -8, 12  ,  -11, 8  ,  -11, -6  ,  -3, -10  ,  7, -4  ,  6, 11  },thumbnailYoffset=10,
    bagindex=2,bagcopacity=5,         width=24, height=24,density=0.3, friction=1, bounce=0.1, radius=0,x=0,flysound=2,hitsound=3,volume=40}	--r=12

    SpriteColection[#SpriteColection + 1] = {type="body",  subtype="bag", title="NormalBackpack",image="backpack_normal.png",      
    apxprice=120,isLargeObject=true,thumbnailYoffset=0,
    description="Backpack that may hold up to 10 items.", bagindex=3,
    advancedShape=  {{   9, -5  ,  9, 14  ,  2, 17  ,  -14, 11  ,  -14, -5  ,  -10, -13  ,  5, -13  },{   -14, 11  ,  2, 17  ,  -9, 17  }},
    bagcopacity=10,         width=30, height=34,density=0.3, friction=1, bounce=0.1, radius=0,x=0,flysound=2,hitsound=3,volume=40,
    icon_width=30,icon_height=36
    }	--r=12

SpriteColection[#SpriteColection + 1] = {type="body",  subtype="bag", title="ClosedBasket",image="basket_closed.png",
    apxprice=10,isLargeObject=true,
    description="The garbage bin may hold up to 20 items, but it slows you down a lot.",          
    shape = {   15, -14  ,  11, 16  ,  -10, 16  ,  -15, -14  },
    bagindex=4,bagcopacity=50,         width=32, height=34,density=0.3, friction=1, bounce=0.1, radius=0,x=0,flysound=2,hitsound=3,volume=40}	--r=12


-- Flag
SpriteColection[#SpriteColection + 1] = {type="body",  title="Flag",image="flagstick.png",  subtype="flag",  width=32, height=64,density=30, friction=10, bounce=0, rotation=0,radius=0,x=0,flysound=2,hitsound=3,volume=40}	--r=12


-- Shoes
SpriteColection[#SpriteColection + 1] = {type="body",  subtype="shoes", title="Shoes", 
    advancedShape={{   9, 4  ,  1, 8  ,  -11, 7  ,  -11, -1  ,  4, -2  ,  11, 0  },{   4, -2  ,  -11, -1  ,  3, -8  }},
    description="Shoes saves energy while walking.", image="shoes.png", shoesindex=2, 
    apxprice=110,isLargeObject=true,ShopYMargin=25,thumbnailYoffset=25,
    width=24, height=16,density=0.6, friction=10, bounce=0.1, rotation=0,radius=0,x=0,flysound=2,hitsound=3,volume=40,
    icon_width=50,icon_height=32
    }	--r=12

SpriteColection[#SpriteColection + 1] = {type="body",  subtype="shoes", title="Boots", 
    advancedShape={{   4, -9  ,  4, 8  ,  0, 10  ,  -11, 9  ,  -12, -9  },{   10, 8  ,  4, 8  ,  4, 1  ,  12, 4  }},
    apxprice=60,isLargeObject=true,thumbnailYoffset=15,
    description="Boots saves enargy while walking and you can walk on coals.", image="boots.png", shoesindex=3, width=24, height=20,density=0.6, friction=10, bounce=0.1, rotation=0,radius=0,x=0,flysound=2,hitsound=3,volume=40}	--r=12

SpriteColection[#SpriteColection + 1] = {type="body",  subtype="shoes", title="Trainers",
    description="Trainers saves energy while walking and you can run much faster.", 
    apxprice=170,isLargeObject=true,thumbnailYoffset=20,
    shape={   4, 7  ,  -9, 6  ,  -10, -2  ,  3, -8  ,  11, 1  },
    image="trainers.png", shoesindex=4, width=20, height=14,density=0.6, friction=10, bounce=0.1, rotation=0,radius=0,x=0,flysound=2,hitsound=3,volume=40}	--r=12

-- Balls
SpriteColection[#SpriteColection + 1] = {type="body",  title="Bascketball",description="Bascketball Ball", 
    apxprice=105,  subtype="ball",
    image="bascketball.png", attraction=10, width=30, height=30,density=0.5, friction=1, bounce=0.5, radius=15,x=0,flysound=2,hitsound=2,volume=50,
    icon_width=36,icon_height=36}	

SpriteColection[#SpriteColection + 1] = {type="body",  title="Football",description="Football Ball",
    apxprice=90,  subtype="ball",
    image="football.png", attraction=10, width=28, height=28,density=0.5, friction=1, bounce=0.5, radius=14,x=0,flysound=2,hitsound=2,volume=50,
    icon_width=34,icon_height=34}	

SpriteColection[#SpriteColection + 1] = {type="body",  title="TennisBall",description="Tennis Ball",image="tennisball.png", 
    apxprice=3,  subtype="ball",
    width=10, height=10,density=1.0, friction=1, bounce=0.5, radius=5,x=0,flysound=4,hitsound=1,volume=50,
    icon_width=22,icon_height=22
    }	

SpriteColection[#SpriteColection + 1] = {type="body",  title="Toyball",description="Toy Ball",image="toyball.png", 
    apxprice=15,  subtype="ball",
    energyvalue=10, width=32, height=32,density=0.5, friction=1, bounce=0.5, radius=16,x=0,flysound=2,hitsound=2,volume=40,
    icon_width=34,icon_height=34}		



-- Gems
SpriteColection[#SpriteColection + 1] = {type="body",  subtype="gems", title="Ruby",image="ruby.png",  
    shape = {   -15, -4  ,  -9, -10  ,  8, -10  ,  15, -4  ,  -1, 10  },
    description="Ruby. Apx. price: 2000 coins.",apxprice=2000,  width=32, height=20,density=2.4, friction=1, bounce=0.1, radius=0,x=0,flysound=2,hitsound=3,volume=40,
    icon_width=32,icon_height=22
}

SpriteColection[#SpriteColection + 1] = {type="body",  subtype="gems", title="Sapphire",image="sapphire.png",
    description="Sapphire. Apx. price: 1400 coins.",apxprice=1400,  
    shape = {   10, 5  ,  0, 11  ,  -13, 4  ,  -18, -4  ,  -10, -11  ,  10, -11  ,  18, -3  },
    width=36, height=22,density=2.4, friction=1, bounce=0.1, radius=0,x=0,flysound=2,hitsound=3,volume=40,
    icon_width=38,icon_height=22
    }

SpriteColection[#SpriteColection + 1] = {type="body",  subtype="gems", title="Emerald",image="emerald.png",
    description="Emerald. Apx. price: 1000 coins.",apxprice=1000,  
    shape = {   2, 8  ,  -2, 8  ,  -11, -2  ,  -5, -8  ,  5, -8  ,  11, -2  },
    width=22, height=16,density=2.4, friction=1, bounce=0.1, radius=0,x=0,flysound=2,hitsound=3,volume=40,
    icon_width=32,icon_height=22
    }

SpriteColection[#SpriteColection + 1] = {type="body",  subtype="gems", title="Topaz",image="topaz.png",
    description="Topaz. Apx. price: 500 coins.",apxprice=500,  
    shape = {   -15, -3  ,  -8, -11  ,  7, -11  ,  14, -3  ,  0, 10  },
    width=30, height=22,density=2.4, friction=1, bounce=0.1, radius=0,x=0,flysound=2,hitsound=3,volume=40,
    icon_width=32,icon_height=22
    }

--SpriteColection[#SpriteColection + 1] = {type="body",  subtype="gems", title="ColombianEmerald",image="colombian_emerald.png",description="Rare Colombian Emerald. Apx. price: 4000 coins.",apxprice=4000,  width=22, height=16,density=2.4, friction=1, bounce=0.1, radius=0,x=0,flysound=2,hitsound=3,volume=40}



		



end