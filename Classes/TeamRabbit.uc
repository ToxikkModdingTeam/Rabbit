class TeamRabbit extends CRZTeamGame config(TeamRabbit);

var NavigationHelper NavHelp;
var() RabbitCell RabbitCell;

function PostBeginPlay()
{
	local UDKGameObjective UDKGameObjective;
	super.PostBeginPlay();
	NavHelp =  Spawn(class'NavigationHelper');
	UDKGameObjective = NavHelp.GetCenterUDKGameObjective(0);
	`Log("Spawning at " @ UDKGameObjective.Location.X @ UDKGameObjective.Location.Y @ UDKGameObjective.Location.Z);
	RabbitCell = Spawn(class'RabbitCell',UDKGameObjective,,UDKGameObjective.Location);
	RabbitCell.HomeBase = UDKGameObjective;
}

function ScoreObjective(PlayerReplicationInfo Scorer, Int Score)
{
	Scorer.Team.Score += Score;
	Super.ScoreObjective(Scorer, Score);
}

DefaultProperties
{
	bScoreDeaths=false;
}
