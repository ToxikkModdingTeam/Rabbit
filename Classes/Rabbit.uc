class Rabbit extends CellDomination config(Rabbit);

var config bool bKillingHolderGivesScore;
var config bool bConfigInitialized;

function PostBeginPlay()
{
	Super.PostBeginPlay();

	if ( !bConfigInitialized )
		InitConfig();
}

function InitConfig(optional bool bSave=true)
{
	bKillingHolderGivesScore=true;
	SaveConfig();
}

function ScoreKill(Controller Killer, Controller Other)
{
	local PlayerReplicationInfo OtherPRI;
	local UTPawn KillerPawn;
	local UTGameReplicationInfo GRI;

	OtherPRI = Other.PlayerReplicationInfo;
	if ( OtherPRI != None )
	{
		OtherPRI.NumLives++;
		if ( (MaxLives > 0) && (OtherPRI.NumLives >=MaxLives) )
			OtherPRI.bOutOfLives = true;
	}
	if ( Killer.PlayerReplicationInfo != None
		&& Other.PlayerReplicationInfo != None
		&& CRZPlayerReplicationInfo(Killer.PlayerReplicationInfo) != None
		&& CRZPlayerReplicationInfo(Other.PlayerReplicationInfo) != None
		// We only score with the flag in our hands or we killed the holder
		&& (CRZPlayerReplicationInfo(Killer.PlayerReplicationInfo).bHasFlag)
			|| (CRZPlayerReplicationInfo(Other.PlayerReplicationInfo).bHasFlag && bKillingHolderGivesScore)
		)
	{
		Killer.PlayerReplicationInfo.Score += 1;
		Killer.PlayerReplicationInfo.bForceNetUpdate = TRUE;
		Killer.PlayerReplicationInfo.Kills++;
		if(IsNotSkillClassLocked())
			CRZPlayerReplicationInfo(Killer.PlayerReplicationInfo).IncrementHighClassKills(CRZPlayerReplicationInfo(OtherPRI));
	}

	ModifyScoreKill(Killer, Other);

	if (Killer != None || MaxLives > 0)
	{
		CheckScore(Killer.PlayerReplicationInfo);
	}
	if ( (killer == None) || (Other == None) )
		return;

	GRI = UTGameReplicationInfo(GameReplicationInfo);
	if ( GRI.bStoryMode && !bTeamGame && (killer.IsA('PlayerController') || Other.IsA('PlayerController')) )
	{
		if ( killer.IsA('AIController') )
			AdjustSkill(AIController(killer), PlayerController(Other), false);
		if ( Other.IsA('AIController') )
			AdjustSkill(AIController(Other), PlayerController(Killer), true);
	}

	KillerPawn = UTPawn(Killer.Pawn);
	if ( (KillerPawn != None) && KillerPawn.bKillsAffectHead )
	{
		KillerPawn.SetBigHead();
	}

	AnnounceKillScore(Killer.PlayerReplicationInfo);
}

defaultproperties
{
	bHoldingIncrementsScore=false;
}
