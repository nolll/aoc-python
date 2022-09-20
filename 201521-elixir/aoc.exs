defmodule RpgCharacter do
    defstruct name: "", points: 0, damage: 0, armor: 0
end

defmodule RpgProperty do
    defstruct name: "", cost: 0, damage: 0, armor: 0
end

defmodule Aoc do
    def run() do
        boss = createBoss()
        player = createPlayer()
        winner = runGame(player, boss)
        IO.puts(winner.name)
        IO.puts(winner.points)
    end

    def runGame(player, boss), do: attack(player, boss)

    def attack(attacker, defender) do
        if(isAlive(defender)) do
            attack(hurt(defender, attacker.damage), attacker)
        else
            attacker
        end
    end

    def createPlayer(), do: createRpgCharacter("Player", 10)

    def createBoss(), do: createRpgCharacter("Boss", 5)

    def createRpgCharacter(name, points) do
        %RpgCharacter{name: name, points: points}
    end

    def createWeapons() do
        [
            createRpgProperty("Dagger", 8, 4, 0),
            createRpgProperty("Shortsword", 10, 5, 0),
            createRpgProperty("Warhammer", 25, 6, 0),
            createRpgProperty("Longsword", 40, 7, 0),
            createRpgProperty("Greataxe", 74, 8, 0)
        ]
    end

    def createArmor() do
        [
            createRpgProperty("Leather", 13, 0, 1),
            createRpgProperty("Chainmail", 31, 0, 2),
            createRpgProperty("Splintmail", 53, 0, 3),
            createRpgProperty("Bandedmail", 75, 0, 4),
            createRpgProperty("Platemail", 102, 0, 5)
        ]
    end

    def createRings() do
        [
            createRpgProperty("Damage +1", 25, 1, 0),
            createRpgProperty("Damage +2", 50, 2, 0),
            createRpgProperty("Damage +3", 100, 3, 0),
            createRpgProperty("Defense +1", 20, 0, 1),
            createRpgProperty("Defense +2", 40, 0, 2),
            createRpgProperty("Defense +3", 80, 0, 3)
        ]    
    end

    def createRpgProperty(name, cost, damage, armor) do
        %RpgProperty{name: name, cost: cost, damage: damage, armor: armor}
    end

    def isAlive(character), do: character.points > 0

    def hurt(character, attack) do
        damage = getDamage(attack, character.armor)
        points = character.points - damage;
        %{character | :points => points}
    end

    def getDamage(attack, armor) do
        damage = attack - armor
        if(damage > 0) do
            damage
        else
            1
        end
    end

    def permutations([]), do: [[]]
    def permutations(list), do: for elem <- list, rest <- permutations(list--[elem]), do: [elem|rest]

    # private IList<IList<RpgProperty>> GetPropertyCombinations()
    # {
    #     var weaponCombinations = GetWeaponCombinations();
    #     var armorCombinations = GetArmorCombinations();
    #     var ringCombinations = GetRingCombinations();

    #     var combinations = new List<IList<RpgProperty>>();
    #     foreach (var weaponCombination in weaponCombinations)
    #     {
    #         foreach (var armorCombination in armorCombinations)
    #         {
    #             foreach (var ringCombination in ringCombinations)
    #             {
    #                 var combination = new List<RpgProperty>();
    #                 combination.AddRange(weaponCombination);
    #                 combination.AddRange(armorCombination);
    #                 combination.AddRange(ringCombination);
    #                 combinations.Add(combination);
    #             }
    #         }
    #     }

    #     return combinations;
    # }

    def getWeaponCombinations() do
        weapons = createWeapons()
        weapons.map(fn {weapon} -> {[weapon]} end)
    end

    def getArmorCombinations() do
        armors = createArmor();
        combinations = armors.map(fn {armor} -> {[armor]} end)
        [[]] ++ combinations
    end
    
    # private IList<List<RpgProperty>> GetRingCombinations()
    # {
    #     var combinations = new List<List<RpgProperty>> { new List<RpgProperty>() };
    #     combinations.AddRange(_rings.Select(ring => new List<RpgProperty> { ring }));
    #     combinations.AddRange(PermutationGenerator.GetPermutations(_rings, 2).Select(o => o.ToList()).ToList());
    #     return combinations;
    # }
end

Aoc.run()
