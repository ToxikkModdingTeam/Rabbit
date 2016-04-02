class CellDominationCell extends CRZCell;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	if (Team != None)
		Team.TeamIndex = 0;
}

function SetupAwardingTimer()
{
	SetTimer(1.0, true, 'AwardHolder');
}

/**
 * We check if someone already has a flag.
 */
function bool ValidHolder(Actor other)
{
	local Pawn P;

	P = Pawn(other);
	if (P != None && CRZPlayerReplicationInfo(P.PlayerReplicationInfo) != None && CRZPlayerReplicationInfo(P.PlayerReplicationInfo).bHasFlag )
	{
		return false;
	}

	return super.ValidHolder(other);
}

function SetHolder(Controller C)
{
	local CRZCCSquadAI S;
	local CRZPawn UTP;
	local UTBot B;

	UTP = CRZPawn(C.Pawn);
	LightEnvironment.bDynamic = TRUE;
	SkelMesh.SetShadowParent( UTP.Mesh );
	ClearTimer( 'SetFlagDynamicLightToNotBeDynamic' );

	if(UTP != none )
	{
		UTP.EnableStealth(false,true);
		UTP.bAlwaysRelevant = true;
	}

	B = UTBot(C);
	if (TeamCellDomination(WorldInfo.Game) != None)
	{
		if ( B != None )
		{
			S = CRZCCSquadAI(B.Squad);
		}
		else if ( PlayerController(C) != None )
		{
			S = CRZCCSquadAI(UTTeamInfo(C.PlayerReplicationInfo.Team).AI.FindHumanSquad());
		}

		if ( S != None )
		{
			S.EnemyFlagTakenBy(C);
		}
		//TeamCellDomination(WorldInfo.Game).HolderPRI = HolderPRI;
	}
	else if (CellDomination(WorldInfo.Game) != None)
	{
		//CellDomination(WorldInfo.Game).HolderPRI = HolderPRI;
	}

	Super(UTCarriedObject).SetHolder(C);
	if ( B != None )
	{
		B.SetMaxDesiredSpeed();
	}
}

/**
 * todo extract to gametype
 */
function AwardHolder()
{
	if (WorldInfo.Game.IsInState('MatchOver'))
	{
		ClearTimer('AwardHolder');
	}
	else if (HolderPRI != None)
	{
		if (CellDomination(WorldInfo.Game) != None)
		{
			CellDomination(WorldInfo.Game).IncrementScore(HolderPRI);
		} else if (TeamCellDomination(WorldInfo.Game) != None)
		{
			TeamCellDomination(WorldInfo.Game).IncrementScore(HolderPRI);
		}
	}
}

function bool IsHeldBySameTeam(int TeamIndex)
{
	if ( Holder != None
		&& Holder.PlayerReplicationInfo != None
		&& Holder.PlayerReplicationInfo.Team != None
		&& Holder.PlayerReplicationInfo.Team.TeamIndex == TeamIndex
	)
	{
		return true;
	}
	return false;
}


DefaultProperties
{
	MessageClass=class'CellDominationLogMessage'
}