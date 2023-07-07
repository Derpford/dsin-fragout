class SinGLauncher : SinWeapon {
    // Fires modified FRG-4 grenades.
    // The grenades have to be cut down to fit into the launcher, and their explosive material is repacked into a pipe-bomb-like configuration.

    default {
        Inventory.Amount 0;
        Inventory.MaxAmount 1;
        SinWeapon.FireType FIRE_MANUAL;
        SinWeapon.ReloadType RELOAD_TOP;
        SinWeapon.AttackType ATTACK_PROJECTILE;
        SinWeapon.Noise 256; // The RL is apparently really fucking quiet, so the bloopy tube is too
        SinWeapon.Projectile "Primed40mm";
        SinWeapon.CanChamber true;
        SinWeapon.Chambered true;
        SinWeapon.Recoil 6;
        SinWeapon.Climb 0.5,0.5;
        SinWeapon.AmmoType "Sin40MM";
        SinItem.BigItem true;
        AttackSound "weapons/rocklf";
        Inventory.PickupMessage "$SINWEAP_GLPKUP";
        Tag "$SINWEAP_GL";
        SinItem.Description "$SINWEAP_GLDESC";
        Inventory.Icon "GLNCA0";
    }

    States {
        Spawn:
            GLNC A -1; Stop;
            GLNM A -1;
    }

    override void HandleSprite (bool boltback) {
        string ico = "GLN";
        if (attachments.Find("SinGLDrum") != attachments.Size()) {
            ico = ico .. "M";
        } else {
            ico = ico .. "C";
        }
        cursprite = GetSpriteIndex(ico);

        if (!boltback) {
            curframe = 0;
            ico = ico .. "A0";
        } else {
            curframe = 1;
            ico = ico .. "B0";
        }
        icon = TexMan.CheckForTexture(ico,TexMan.Type_Any);

        sprite = cursprite;
        frame = curframe;
    }
}

class Primed40mm : Actor {
    int fuse;
    Default {
        Radius 2; Height 4;
        Speed 50;
        DamageFunction (1);
        Projectile;
        -NOGRAVITY;
        +FORCERADIUSDMG;
        +ROLLSPRITE; +ROLLCENTER;
        +FORCEXYBILLBOARD;
        BounceType "Doom";
        DeathSound "weapons/grenhit";
        BounceSound "weapons/grenhit";
        Obituary "%k gave %o a 40 of high explosive.";
    }

    action state FuseBurn(bool spin = false) {
        if (spin) {
            roll -= 5;
        } 
        
        if (invoker.fuse >= 140) {
            return ResolveState("Explode");
        } else {
            invoker.fuse++;
        }
        return ResolveState(null);
    }

    action void Detonate() {
        invoker.bNOGRAVITY = true;
        invoker.bFORCEXYBILLBOARD = false;
        roll = 0;
        A_Stop();
        A_Explode(400,256,fulldamagedistance:128); // Removed fragmentation material makes it do less damage, but not enough to notice against most targets.
        A_AlertMonsters(); // Technically, A_Explode already does this.
        A_StartSound("weapons/grenboom",CHAN_BODY);
    }

    States {
        Spawn:
            40MM B 1 FuseBurn(true);
            Loop;
        Death:
            40MM B 1 FuseBurn();
            Loop;
        
        Explode:
            40MM B 0 Detonate();
            MISL B 8 Bright;
            MISL C 6 Bright;
            MISL D 4 Bright;
            Stop;
    }
}

class SinGLDrum : SinAttachment {
    default {
        SinAttachment.MaxAmount 3;
        SinAttachment.AttachTo "SinGLauncher";
        Inventory.PickupMessage "$SINMOD_GLDRUMPKUP";
        Tag "$SINMOD_GLDRUM";
        SinItem.Description "$SINMOD_GLDRUMDESC";
        Inventory.Icon "ATDMA0";
    }

    states {
        Spawn:
            ATDM A -1; Stop;
    }
}