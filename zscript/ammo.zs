class Sin40MM : SinAmmo {
    // A single 40mm grenade. Bulky as hell. 
    Default {
        SinAmmo.AmmoType "Sin40MM";
        Inventory.Icon "40MMA0";
        SinItem.Stackable true;
        Inventory.Amount 1;
        SinItem.RemoveWhenEmpty true;
        Inventory.PickupMessage "$SINITEM_40MMPKUP";
        Tag "$SINITEM_40MM";
        SinItem.Description "$SINITEM_40MMDESC";
    }

    States {
        Spawn:
            40MM A -1;
            Stop;
    }
}

Class SinRecipe40MM : SinRecipe {
    Default {
        SinRecipe.Ingredients "SinReloadingKit", "SinGrenade";
        SinRecipe.Result "Sin40MM", 1;
    }
}

class Sin40Box : SinAmmo {
    Default {
        SinAmmo.AmmoType "Sin40MM";
        Inventory.Icon "40BXA0";
        Inventory.Amount 5;
        Inventory.MaxAmount 5;
        Inventory.PickupMessage "$SINAMMO_40MMBOXPKUP";
        Tag "$SINAMMO_40MMBOX";
        SinItem.Description "$SINAMMO_40MMBOXDESC";
    }

    states {
        Spawn:
            40BX A -1; Stop;
    }
}