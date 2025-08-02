function main() {
    
   AddCallback_OnPlayerKilled(onplayermurdered)
    AddDamageCallback("player", OnDamaged)
	//  AddCallback_OnClientConnected(onconnect)
	//  AddClientCommandCallback( "TitanEject", ejecting )
	Globalize(Lejecting)
	  AddCallback_OnPlayerRespawned(respawnfunc)

	::loadouts <- {}
   thread loadoutsaver()
//    local moverrrwr = CreateEntity( "script_mover" )
}

function respawnfunc(player){
    player.kv.gravity = 0.0
}


// function onconnect(player){
// 	print("HEREEE")
// 	loadouts[player.GetEntIndex()] <- {}
// 	loadouts[player.GetEntIndex()].lasthit <- 0
// 	PrintTable(loadouts)

// }
function Lejecting( player )
{
    // if ( !PlayerCanEject( player ) )
    //     return true

    // ejectPressCount = ejectPressCount.tointeger()

    // if ( ejectPressCount < 0 )
    //     return false

    // player.s.ejectPressTime = Time()
    // player.s.ejectPressCount = ejectPressCount.tointeger()

    // if ( player.s.ejectPressCount < 3 )
    //     return true

    // thread TitanEjectPlayer( player )
	// printt("TITAN EJECTING TITAN EJECTING TITAN EJECTING TITAN EJECTING")
	thread onplayermurdered(player,false,true)
    // return true
}
function OnDamaged(ent,damageInfo) {
	// print("HERE")

    local inflictor = damageInfo.GetInflictor()
    if(inflictor == null)
        return

    if(inflictor.IsPlayer() &&  ent.GetEntIndex() != inflictor.GetEntIndex()) {
		// print("PASSED HERE")
		 local pindex = ent.GetEntIndex()
		loadouts[pindex].lasthit <- Time()
		loadouts[pindex].lasthitby <- inflictor.GetEntIndex()
	
	}}
function loadoutsaver() {
   while (true){
      for ( local i = 0; i < GetPlayerArray().len() ; i++) {
         if (!IsAlive( GetPlayerArray()[i])) {
            continue
         }
         // SendChatMsg(true,0,Lprefix()+ GetPlayerArray()[i].GetPlayerName() +" Switched teams",false,false)
		 local pindex = GetPlayerArray()[i].GetEntIndex()
		 if (!ArrayContains(TableKeysToArray(loadouts),pindex)){
			loadouts[pindex] <- {}
		 }
          loadouts[pindex].weapons <- StoreWeapons(GetPlayerArray()[i])
          loadouts[pindex].pos <- GetPlayerArray()[i].GetOrigin()
          loadouts[pindex].angles <- GetPlayerArray()[i].GetAngles()
          loadouts[pindex].isatitan <- GetPlayerArray()[i].IsTitan()
 

      }
      wait 0.1
   }
   
}
function StoreWeapons( ent )
{
	local table = {}
	local weapons = ent.GetMainWeapons()
	StoreWeaponsToTable( table, weapons, "mainWeapons" )

	table.activeWeapon <- null
	local activeWeapon = ent.GetActiveWeapon()
	if ( activeWeapon )
	{
		local activeName = activeWeapon.GetClassname()
		if ( !Designator( activeName ) )
			table.activeWeapon = activeName
	}

	local weapons = ent.GetOffhandWeapons()
	StoreWeaponsToTable( table, weapons, "offhandWeapons" )

	return table
}
function Designator( name )
{
	switch ( name )
	{
		case "mp_weapon_target_designator":
		case "mp_titanweapon_target_designator":
			return true
	}

	return false
}
function onplayermurdered(player,damage = false, attacker = false){
//    printt("OWO I GOT HERE" + player.GetPlayerName())
//    PrintTable(loadouts)
   if (attacker == false &&  player.GetEntIndex() != damage.GetAttacker().GetEntIndex()){
   attacker = damage.GetAttacker()
   if ( !attacker.IsPlayer() && Time() - loadouts[player.GetEntIndex()].lasthit > 10)
		{return}
	else if ( !attacker.IsPlayer() && loadouts[player.GetEntIndex()].lasthitby != player.GetEntIndex() ){
		attacker =  GetEntByIndex(loadouts[player.GetEntIndex()].lasthitby)
	}
	else if ( !attacker.IsPlayer()){
		return
	}}
	else if (loadouts[player.GetEntIndex()].lasthitby != player.GetEntIndex() && Time() - loadouts[player.GetEntIndex()].lasthit < 10 ){
		// printt("HEREEE")
	attacker =  GetEntByIndex(loadouts[player.GetEntIndex()].lasthitby)	
	}
	else{
		local timeleft = (Time() - loadouts[player.GetEntIndex()].lasthit)
		// print("SOOOBBB" + timeleft)
		return
	}
	// printt("AND HEREEE")
//    local player.GetEntIndex() = 0
//    for ( local i = 0; i < GetPlayerArray().len() ; i++) {
//       if ( player.GetPlayerName() == GetPlayerArray()[i].GetPlayerName()){
//          player.GetEntIndex() = i
//          break
//       }
//    }
// printt("ATTACKER" + attacker.GetPlayerName())

   if (loadouts[player.GetEntIndex()].isatitan !=attacker.IsTitan()) {
		// print("YOU'RE NOT A REAL TITAN" + attacker.IsTitan() + loadouts[player.GetEntIndex()].isatitan)
      return
   }
 
//    printt("BOW WOW" + attacker.GetPlayerName())
   thread moveteleport(attacker,attacker.GetOrigin(),attacker.GetAngles(),loadouts[player.GetEntIndex()].pos,loadouts[player.GetEntIndex()].angles)
//    attacker.SetOrigin(loadouts[player.GetEntIndex()].pos)
//    attacker.SetAngles(loadouts[player.GetEntIndex()].angles)
   RetrievePilotWeapons(attacker,loadouts[player.GetEntIndex()].weapons)
   

   
   
}



function moveteleport(attacker,frompos,fromang,topos,toang){
//    local moverrrr = CreateScriptMover( null, frompos,fromang)
	local mover = CreateScriptMover( attacker )
	local tptime = 0.65
	mover.EndSignal( "OnDestroy" )
	attacker.SetParent( mover, "", false, 0 )
   mover.SetOrigin( frompos )
   mover.SetAngles( fromang )
   mover.RotateTo( toang,0.4)
   	mover.MoveTo( topos, tptime)
	
	wait tptime+0.3
	
	attacker.ClearParent()

	attacker.SetOrigin(topos)
   // DispatchSpawn( moverrrr, true )
	// moverrrr.Hide()
// 	moverrrr.NotSolid()
// 	moverrrr.SetMaxSpeed( 300 )
//    moverrrr.SetYawRate( 300 )
//    attacker.SetParent( moverrrr, "", true, 0 )
//    attacker.SetHealth( 100000 )
//    attacker.NotSolid()
//    moverrrr.SetDesiredYaw( toang )
//    moverrrr.SetMoveToPosition(topos )
}
// function CreateTeleportFX( player )
// {
// 	local info_particle_system = CreateEntity( "info_particle_system" )
// 	info_particle_system.kv.effect_name = TELEPORTGRENADE_TELEPORT_FX
// 	info_particle_system.kv.start_active = 1

// 	// put it a little in front of the player
// 	local basepos = player.GetOrigin() + Vector( 0, 0, 30 )
// 	local forward = player.GetAngles().AnglesToForward()
// 	local newpos = basepos + ( forward * 32 )
// 	info_particle_system.SetOrigin( newpos )

// 	info_particle_system.SetAngles( player.GetAngles() + Vector( 90, 90, 0 ) )
// 	DispatchSpawn( info_particle_system, false )

// 	info_particle_system.SetParent( player )

// 	return info_particle_system
// }

function RetrievePilotWeapons( pilot, pewpews )

{
   printt("HEREHREHIRQNDFQ")

		if ( pilot.IsPlayer() )
	{
		pilot.RemoveAllItems()
		local weapons = pilot.GetMainWeapons()
		foreach ( weapon in weapons )
		{
			Assert( 0, pilot + " still has weapon " + weapon.GetClassname() + " after doing takeallweapons" )
		}
	}
	else
	{
		local weapons = pilot.GetMainWeapons()
		TakeAllWeaponsForArray( pilot, weapons )

		local weapons = pilot.GetOffhandWeapons()
		foreach ( index, weapon in clone weapons )
		{
			pilot.TakeOffhandWeapon( index )
		}
		TakeAllWeaponsForArray( pilot, weapons )
	}
	GiveWeaponsFromStoredTable( pilot, pewpews )
	// delete pilot.s.storedPilotLoadout
}

function GiveWeaponsFromStoredTable( ent, table )
{
	GiveWeaponsFromStoredArray( table[ "mainWeapons" ], 	ent,	"GiveWeapon" )
	GiveWeaponsFromStoredArray( table[ "offhandWeapons" ], ent,	"GiveOffhandWeapon" )

	if ( table[ "mainWeapons" ].len() )
		ent.SetActiveWeapon( table[ "mainWeapons" ][0].name )

	if ( table.activeWeapon )
	{
		ent.SetActiveWeapon( table.activeWeapon )
	}
}

function GiveWeaponsFromStoredArray( array, ent, GiveFuncName )
{
	// array backwards so we end up with the correct weapon in hand
	// it might not actually work like this though.
//	for ( local i = array.len() - 1; i >= 0; i-- )
	for ( local i = 0; i < array.len(); i++ )
	{
		local weaponTable = array[i]

		switch ( GiveFuncName )
		{
			case "GiveWeapon":
				ent.GiveWeapon( weaponTable.name, weaponTable.mods )
				break

			case "GiveOffhandWeapon":
				ent.GiveOffhandWeapon( weaponTable.name, i, weaponTable.mods )
				local weapon = ent.GetOffhandWeapon( i )
				weapon.SetNextAttackAllowedTime( weaponTable.nextAttackTime )
				break

			default:
				Assert( 0, "Unhandled givefuncname " + GiveFuncName )
		}
	}

	local weapons

	switch ( GiveFuncName )
	{
		case "GiveWeapon":
			weapons = ent.GetMainWeapons()
			break

		case "GiveOffhandWeapon":
			weapons = ent.GetOffhandWeapons()
			break
	}

	foreach ( weapon in weapons )
	{
		for ( local i = 0; i < array.len(); i++ )
		{
			local weaponTable = array[i]

			if ( weaponTable.name != weapon.GetClassname() )
				continue

			weapon.SetWeaponPrimaryAmmoCount( weaponTable.ammoCount )
			if ( GiveFuncName == "GiveWeapon" )
			{
				printt( "[Weapon name]", weaponTable.name )
				// weapon.SetWeaponPrimaryClipCount( weaponTable.clipCount )
			}
			break
		}
	}
}

// function CreateScriptMover( owner = null, origin = null, angles = null )
// {
// 	if ( owner == null)
// 	{
// 		local script_mover = CreateEntity( "script_mover" )
//       script_mover.kv.SpawnAsPhysicsMover = 1
// 		script_mover.kv.solid = 0
// 		script_mover.kv.model = "models/dev/empty_model.mdl"
		
// 		if ( origin )
// 			script_mover.SetOrigin( origin)
// 		if ( angles )
// 			script_mover.SetAngles( angles )

// 		DispatchSpawn( script_mover, true )
// 		return script_mover
// 	}

// 	// Used by function CBaseEntity::ParentToMover()
// 	local script_mover = CreateEntity( "script_mover" )
// 	script_mover.kv.solid = 0
// 	script_mover.kv.model = "models/dev/empty_model.mdl"
// 	script_mover.kv.SpawnAsPhysicsMover = 1
// 	script_mover.SetOrigin( owner.GetOrigin() )
// 	script_mover.SetAngles( owner.GetAngles() )
// 	DispatchSpawn( script_mover )
// 	script_mover.Hide()

// 	script_mover.SetOwner( owner )
// 	return script_mover
// }

main()