class Rabbit extends CRZBloodLust;

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

DefaultProperties
{
	bScoreDeaths=false;
}
