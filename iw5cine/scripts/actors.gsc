/*
 *      IW5cine
 *      Actors functions
 */

#include scripts\precache;
#include scripts\utils;
#include scripts\misc;
#include maps\mp\_utility;
#include maps\mp\gametypes\_class;

add( args )
{
    base_body = defaultcase( isDefined( args[0] ), args[0], "defaultactor" );
    base_head = defaultcase( isDefined( args[1] ), args[1], "tag_origin" );
    base_anim = defaultcase( isDefined( args[2] ), args[2], "pb_stand_remotecontroller" );
    base_dead = defaultcase( isDefined( args[3] ), args[3], "pb_stand_death_chest_blowback" );

    newactor = [];

    newactor["body"] = spawn( "script_model", at_crosshair( self ) );
    newactor["body"].angles = self.angles + ( 0, 180, 0 );
    newactor["body"] EnableLinkTo();
    newactor["body"] setModel( base_body );
    newactor["body"] scriptModelPlayAnim( base_anim );

    newactor["savedo"] = newactor.origin;
    newactor["saveda"] = newactor.angles;

    newactor["head"] = spawn( "script_model", newactor["body"] GetTagOrigin("j_spine4") );
    newactor["head"] setModel( base_head );
    newactor["head"].angles = newactor["body"].angles + ( 270, 0, 270 );
    newactor["head"] linkTo( newactor["body"], "j_spine4") ;
    newactor["head"] scriptModelPlayAnim( base_anim );

    newactor["hitbox"] = spawn( "script_model", newactor["body"].origin + ( 0, 0, 40 ) );
    newactor["hitbox"] setModel( "com_plasticcase_enemy" );
    newactor["hitbox"] Solid();
    newactor["hitbox"].angles = (90, 0, 0);
    newactor["hitbox"] hide();
    newactor["hitbox"].name = level.ACTOR_NAME_PREFIX + (level.actors.size + 1);
    newactor["hitbox"] setCanDamage(1);
    newactor["hitbox"].health = 120;
    newactor["hitbox"].maxhealth = 120;
    newactor["hitbox"] linkTo( newactor["body"], "j_spine4") ;

    newactor["anim_death"] = base_dead;
    newactor["anim_base"] = base_anim;

    newactor["fx"]["hurt"]              = [];
    newactor["fx"]["hurt"].efx          = undefined;
    newactor["fx"]["hurt"].where        = undefined;
    newactor["fx"]["death"]             = [];
    newactor["fx"]["death"].efx         = "flesh_body";
    newactor["fx"]["death"].where       = "j_spine4";
    newactor["fx"]["actorback"]         = [];
    newactor["fx"]["actorback"].efx     = undefined;
    newactor["fx"]["actorback"].where   = undefined;

    newactor["name"] = level.ACTOR_NAME_PREFIX + ( level.actors.size + 1 );
    newactor["idx"] = level.actors.size;

    newactor thread track_damage();
    level.actors[level.actors.size] = newactor;

    pront( "[" + newactor["name"] + "] * " + level.COMMAND_COLOR + "Spawned");
}

copy( args )
{
    name = args[0];
    foreach( actor in level.actors )
    {
        if ( select_ents( actor, name, self ) ) {
            newactor = [];
            newactor.base_body = actor["body"].model;
            newactor.base_head = actor["head"].model;
            newactor.anim_base = actor["anim_base"];
            newactor.anim_death = actor["anim_death"];
            add( newactor );
        }
    }
}

prepare_gopro()
{
    level.gopro = spawn( "script_model", ( 9999, 9999, 9999 ) );
    level.gopro setModel( "tag_origin" );
    level.gopro.origin = self getOrigin();
    level.gopro.angles = self getPlayerAngles();
    level.gopro.linked = 0;
    level.gopro enableLinkTo();

    waitframe();
    level.gopro.object = spawn( "script_model", ( 9999, 9999, 9999 ) );
    level.gopro.object setModel( "projectile_rpg7" );
    level.gopro.object.origin = level.gopro.origin;
    level.gopro.object.angles = ( level.gopro.angles - ( 15, 0, 0 ) );

    waitframe();
    level.gopro.object linkTo( level.gopro, "tag_origin" );
}

gopro( args )
{
    action  = args[0];
    tag     = args[1];
    x       = args[2];
    y       = args[3];
    z       = args[4];
    roll    = args[5];
    pitch   = args[6];
    yaw     = args[7];

    if ( action == "delete" ) {
        level.gopro unlink();
        level.gopro.linked = 0;
        level.gopro MoveTo( ( 9999, 9999, 9999 ), .1 );
    }
    else if ( action == "on" ) {
        self CameraLinkTo( level.gopro, "tag_origin" );
        setDvar( "cg_drawGun", 0 );
        setDvar( "cg_draw2d", 0 );
        self allowSpectateTeam( "freelook", true );
        self.sessionstate = "spectator";
    }
    else if ( action == "off" ) {
        self CameraUnlink();
        setDvar( "cg_drawGun", 1 );
        setDvar( "cg_draw2d", 1 );
        self allowSpectateTeam( "freelook", false );
        self.sessionstate = "playing";
    }
    else
	{
		foreach( actor in level.actor )
		{
			if ( actor.name == args[0] )
			{
				if ( level.gopro.linked == 1 )
				{
					level.gopro unlink();
					level.gopro.linked = 0;
				}
				level.gopro.origin = actor GetTagOrigin( tag );
				level.gopro.angles = actor GetTagAngles( tag );
				wait 0.05;
				level.gopro linkTo( actor, tag, (int(x), int(y), int(z)), (int(roll), int(pitch), int(yaw)));
				level.gopro.linked = 1;
			}
		}
    }
}

track_damage()
{
    killer = undefined;
    while (self["hitbox"].health > 0)
    {
        self["hitbox"] waittill("damage", amount, attacker, dir, point, type);
        killer = attacker;
        killer thread maps\mp\gametypes\_damagefeedback::updateDamageFeedback("standard");

        if ( isDefined(killer) && isPlayer(killer) )
            self["hitbox"].health -= amount;

        if(self["hitbox"].health > 0) self play_efx( "hurt" );
    }

    self["body"] scriptModelPlayAnim( self["anim_death"] );
    self["head"] scriptModelPlayAnim( self["anim_death"] );

    self["body"] playSound( "generic_death_american_" + randomIntRange( 1, 8 ) );
    self["body"] play_efx( "death" );

    // obituary requires an actual (test)client so emojis it is lmao
    if( level.ACTOR_SHOW_KILLFEED )
        pront( "^8" + killer.name + " [killed] ^9" + self["name"] );

    killer maps\mp\gametypes\_rank::xpPointsPopup( ( level.scoreInfo["kill"]["value"] ) , 0 );
}

back()
{
    foreach( actor in level.actors )
    {
        actor["body"] MoveTo( actor["savedo"], 0 );
        actor["body"] RotateTo( actor["saveda"], 0 );
        actor["body"] scriptModelPlayAnim( actor["anim_base"] );
        actor["head"] scriptModelPlayAnim( actor["anim_base"] );

        if ( actor["hitbox"].health <= 0 ) {
            actor["hitbox"].health = actor["hitbox"].maxhealth;
            actor thread track_damage();
        }     

        actor["body"] play_efx( "actorback" );
        pront( "[" + actor["name"] + "] * " + level.COMMAND_COLOR + "Reset" );
    }
}

move( args )
{
    name = args[0];
    foreach( actor in level.actors )
    {
        if ( select_ents( actor, name, self ) ) {
            actor["body"] MoveTo( self.origin, 0.4, 0.2, 0.2 );
            actor["body"] RotateTo( self.angles, 0.4, 0.2, 0.2 );
        }
    }
}

playanim( args )
{
    
    name = args[0];
    anima = args[1];
    foreach( actor in level.actors )
    {
        if ( select_ents( actor, name, self ) ) {
            actor["body"] scriptModelPlayAnim( anima );
            actor["head"] scriptModelPlayAnim( anima );
        }
    }
}

deathanim( args )
{
    name = args[0];
    anima = args[1];
    foreach( actor in level.actors )
    {
        if ( select_ents( actor, name, self ) ) 
            actor["anim_death"] = anima;
    }
}

model( args )
{
    name = args[0];
    body = args[1];
    head = args[2];
    foreach( actor in level.actors )
    {
        if ( select_ents( actor, name, self ) ) 
        {
            if ( body == "head" )
                actor["head"] setModel( head );

            else if ( body == "body" )
                actor setModel( head );

            else {
                actor setModel( body );
                actor["head"] setModel( head );
            }
            pront( "[" + actor["name"] + "] * Model swapped -> " + level.COMMAND_COLOR + body + " " + head );
        }
    }
}

hp( args )
{
    name = args[0];
    hp =   args[1];
    foreach( actor in level.actors )
    {
        if ( select_ents( actor, name, self ) ) {
            actor["hitbox"].maxhealth = int( hp );
            actor["hitbox"].health = actor["hitbox"].maxhealth;
            pront( "[" + actor["name"] + "] * Health -> " + level.COMMAND_COLOR + actor["hitbox"].maxhealth );
        }
    }
}

// I'm losing my mind; that new "tag" field doesn't want to stick, which means it doesn't --
// -- delete the previous object. I have to do it by using their index, directly in level.actors
// I'm probably having a brain fart tbh
equip( args )
{
    name =  args[0];
    tag =   args[1];
    model = args[2];
    camo =  args[3];

    if ( !isdefined( camo ) || !isValidCamo( camo ) ) 
        camo = 0;

    foreach( actor in level.actors )
    {
        if ( select_ents( actor, name, self ) ) 
        {
            if ( !isDefined( level.actors[actor["idx"]][tag] ) )
            {
                level.actors[actor["idx"]][tag] = spawn( "script_model", actor["body"] GetTagOrigin( tag ) );
                level.actors[actor["idx"]][tag] linkTo( actor["body"], tag, (0, 0, 0), (0, 0, 0) );
            }
            else level.actors[actor["idx"]][tag] setModel( "tag_origin" );

            if ( isSubStr( model, "_mp" ) && model != "delete" )
            {
                if ( !isValidPrimary( getBaseWeaponName( model ) ) && !isValidSecondary( getBaseWeaponName( model ) )  )
                    model = "ak47_mp";

                hidetags = GetWeaponHideTags( model );
                replica = getWeaponModel( model, camo_int( camo ) );

                level.actors[actor["idx"]][tag] setModel( replica );
                for (i = 0; i < hidetags.size; i++) 
                    level.actors[actor["idx"]][tag] HidePart( hidetags[i],  replica );

                pront( "[" + actor["name"] + "] * Attached -> " + level.COMMAND_COLOR + replica + " to " + tag );
            }
            else if ( model != "delete" ) {
                level.actors[actor["idx"]][tag] setModel( model );
                pront( "[" + actor["name"] + "] * Attached -> " + level.COMMAND_COLOR + model + " to " + tag );
            }
            pront( level.actors[actor["idx"]][tag].model );
        }
    }
}

efx( args )
{
    name = args[0];
    fx =   args[1];
    tag =  args[2];
    when = args[3];
    foreach( actor in level.actors )
    {
        if ( select_ents( actor, name, self ) ) {

            if ( true_or_undef( when ) || when == "now" ) {
                playFx( level._effect[fx], actor["body"] GetTagOrigin(tag) );
                playFx( level._effect[fx], actor["head"] GetTagOrigin(tag) );
            }
            else 
            {
                actor["fx"][when].efx = level._effect[fx];
                actor["fx"][when].where = tag;
                pront( "[" + actor["name"] + "] * FX -> " + level.COMMAND_COLOR + fx + " to " + tag);
            }
        }
    }
}

play_efx( when )
{
    if( isdefined( self["fx"][when].efx ) )
        playFx( level._effect[self["fx"][when].efx], self["body"] GetTagOrigin( self["fx"][when].where ) );
}

getActor( args )
{
	if ( args == "all")
	{
		return level.actor;
	}
	foreach(actor in level.actor)
	{
		if( args == "look")
		{
			vec = anglestoforward(self getPlayerAngles());
			entity = BulletTrace( self getTagOrigin("tag_eye"), self getTagOrigin("tag_eye") + (vec[0] * 500, vec[1] * 500, vec[2] * 500), 0, self )[ "entity" ];
			if(isDefined(entity.model) && entity.name == actor.name)
			{
				ret = [];
				ret[0] = actor;
				return ret;
			}
		}
		else if ( args == actor.name)
		{
			ret = [];
			ret[0] = actor;
			return ret;
		}
	}
	return undefined;
}

// Plan for this is to make a .menu file to display the actor's name, and probably other stuff
// Finish later
names()
{
    /*
    if( !level.ACTOR_SHOW_NAMES ) return;
    setDvarIfUninitialized( "temp_uiname", "" );

	for(;;)
	{
		actors = GetActor("look");
		if( isDefined(actors) && getDvar("ui_showActorNames") == "1")
		{
			foreach (actor in actors)
			{
				level.actorNameDisplay setText(actor.name);
			}
		}
		else level.actorNameDisplay setText(" ");
		wait .1;
	}*/
}