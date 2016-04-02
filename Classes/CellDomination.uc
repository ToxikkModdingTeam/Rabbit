class CellDomination extends CRZBloodLust;

var NavigationHelper NavHelp;
var() CellDominationCell CellDominationCell;
var bool bHoldingIncrementsScore;
//var PlayerReplicationInfo HolderPRI;

function PostBeginPlay()
{
	local UDKGameObjective UDKGameObjective;
	super.PostBeginPlay();
	NavHelp = Spawn(class'NavigationHelper');
	UDKGameObjective = NavHelp.GetCenterUDKGameObjective(0);
	CellDominationCell = Spawn(class'CellDominationCell',UDKGameObjective,,UDKGameObjective.Location);
	CellDominationCell.HomeBase = UDKGameObjective;
	if (bHoldingIncrementsScore)
	{
		CellDominationCell.SetupAwardingTimer();
	}
}

function IncrementScore(PlayerReplicationInfo Scorer)
{
	Scorer.Score += 1;
	CheckScore(Scorer);
}

defaultproperties
{
	bScoreDeaths=false;
	bHoldingIncrementsScore=true;
	HUDType=class'CellDominationHud'
	GameReplicationInfoClass=class'CellDominationGameReplicationInfo'
}