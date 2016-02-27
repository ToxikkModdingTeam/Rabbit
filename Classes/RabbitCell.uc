class RabbitCell extends CRZCell;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	`Log("Starting Timer");
	SetTimer(1.0, true, 'AwardHolder');
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

	if(UTP != none )//Deaktivate stealth if the player is getting the Cell
	{
		UTP.EnableStealth(false,true);

		UTP.bAlwaysRelevant = true;//force the flagcarrier to be allways relevant to track him even if he is hidden
	}

	if (TeamRabbit(WorldInfo.Game) != None)
	{
		// AI Related
		B = UTBot(C);
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
	}

	Super(UTCarriedObject).SetHolder(C);
	if ( B != None )
	{
		B.SetMaxDesiredSpeed();
	}
}

function AwardHolder()
{
	`Log("Checking");
	if (WorldInfo.Game.IsInState('MatchOver'))
	{
		ClearTimer('AwardHolder');
	}
	else if (HolderPRI != None) 
	{
		`Log("Awarding" @ HolderPRI.PlayerName);
		WorldInfo.Game.ScoreObjective(HolderPRI, 1);
	}
}

DefaultProperties
{
	MessageClass=class'RabbitMessage'
}
