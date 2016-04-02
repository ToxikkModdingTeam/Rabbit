class TeamRabbit extends TeamCellDomination config(TeamRabbit);

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

/**
 * Make sure the flag holder can score.
 */
function ScoreKill(Controller Killer, Controller Other)
{
	local Pawn Target;
	local UTPlayerReplicationInfo KillerPRI, OtherPRI, TargetPRI;
	local UTBot B;

	if ( !Other.bIsPlayer || ((Killer != None) && (!Killer.bIsPlayer || (Killer.PlayerReplicationInfo == None))) )
	{
		Super(CRZGame).ScoreKill(Killer, Other);
		if ( !bScoreTeamKills && (Killer != None) && Killer.bIsPlayer && (MaxLives > 0) )
			CheckScore(Killer.PlayerReplicationInfo);
		return;
	}

	if ( (Killer == None) || (Killer == Other)
		|| (Killer.PlayerReplicationInfo.Team != Other.PlayerReplicationInfo.Team) )
	{
		if ( Killer != None )
		{
			KillerPRI = UTPlayerReplicationInfo(Killer.PlayerReplicationInfo);
			OtherPRI = UTPlayerReplicationInfo(Other.PlayerReplicationInfo);
			if ( KillerPRI.Team != OtherPRI.Team )
			{
				if ( OtherPRI.bHasFlag )
				{
					OtherPRI.GetFlag().bLastSecondSave = NearGoal(Other);
				}

				if ( OtherPRI.bHasFlag )
				{
					if ( NearGoal(Other) )
					{
						OtherPRI.GetFlag().bLastSecondSave = true;
					}

					//OLD UT
					// Kill Bonuses work as follows (in additional to the default 1 point
					//	+1 Point for killing an enemy targetting an important player on your team
					//	+2 Points for killing an enemy important player

					//NOW we are not giving extra scores because thats are our kills. we are giving XP instead

					if ( (OtherPRI != None) )
				{
					//KillerPRI.Score+= 2;//for killing flagcarrier
					KillerPRI.bForceNetUpdate = TRUE;
					KillerPRI.IncrementEventStat('EVENT_KILLEDFLAGCARRIER');
					if ( UTPlayerController(Killer) != None )
					{
						UTPlayerController(Killer).ClientMusicEvent(6);
						if ( (WorldInfo.TimeSeconds - LastEncouragementTime > 10) )
						{
							// maybe get encouragement from teammate
							ForEach WorldInfo.AllControllers(class'UTBot', B)
							{
								if ( (B.PlayerReplicationInfo != None) && (B.PlayerReplicationInfo.Team == Killer.PlayerReplicationInfo.Team) && (FRand() < 0.4) )
								{
									B.SendMessage(Killer.PlayerReplicationInfo, 'ENCOURAGEMENT', 0, None);
									break;
								}
							}
						}
					}
					SendFlagKillMessage(Killer, KillerPRI);
				}
				}

				if ( bScoreVictimsTarget )//disabled
				{
					Target = FindVictimsTarget(Other);
					TargetPRI = (Target != None) ? UTPlayerReplicationInfo(Target.PlayerReplicationInfo) : None;
					if ( (TargetPRI!=None) && TargetPRI.bHasFlag &&
						(TargetPRI.Team == Killer.PlayerReplicationInfo.Team) )
					{
						Killer.PlayerReplicationInfo.Score+=1;//for killing guy attacking flagcarrier
						Killer.PlayerReplicationInfo.bForceNetUpdate = TRUE;
					}
				}
			}
		}
		Super(CRZGame).ScoreKill(Killer, Other);
	}
	else
	{
		ModifyScoreKill(Killer, Other);
	}

	if ( !bScoreTeamKills)       // TODO: Add Killer Team
	{
		//if ( Other.bIsPlayer && (Killer != None) && Killer.bIsPlayer && (Killer != Other) && (Killer.PlayerReplicationInfo != None)
		//	&& (Killer.PlayerReplicationInfo.Team == Other.PlayerReplicationInfo.Team) )//reduce the score of one guy if he teamkills, but we dont want this anyway
		//{
		//	Killer.PlayerReplicationInfo.Score -= 1;
		//	Killer.PlayerReplicationInfo.bForceNetUpdate = TRUE;
		//}
		//if ( (MaxLives > 0) && (Killer != None) )
		//	CheckScore(Killer.PlayerReplicationInfo);
		return;
	}
	// we only score when our team is holding the flag or we kill the flag holder
	if ( !KillerPRI.bHasFlag
		&& !TeamCellDomination(WorldInfo.Game).CellDominationCell.IsHeldBySameTeam(KillerPRI.Team.TeamIndex)
		&& (!OtherPRI.bHasFlag || (OtherPRI.bHasFlag && !bKillingHolderGivesScore))
	)
	{
		return;
	}
	if ( Other.bIsPlayer ) //if general kills can influence the teamscore AND we are the player/playerbot...fuck variable...means no spectator I think
	{
		if ( (Killer == None) || (Killer == Other) )
		{
			Other.PlayerReplicationInfo.Team.Score -= 1;//suicide reduces teamscore
			Other.PlayerReplicationInfo.Team.bForceNetUpdate = TRUE;
		}
		else if ( Killer.PlayerReplicationInfo.Team != Other.PlayerReplicationInfo.Team )
		{
			Killer.PlayerReplicationInfo.Team.Score += 1; //enemy team kills increasing the score
			Killer.PlayerReplicationInfo.Team.bForceNetUpdate = TRUE;
		}
		else if ( FriendlyFireScale > 0 )
		{
			Killer.PlayerReplicationInfo.bForceNetUpdate = TRUE;
			//Killer.PlayerReplicationInfo.Score -= 1; //FIX: not reduce score since these are our kills
			Killer.PlayerReplicationInfo.Team.Score -= 1;//friendly fire allowed, reduces teamscore
			Killer.PlayerReplicationInfo.Team.bForceNetUpdate = TRUE;
		}
		if ( UTGameReplicationInfo(GameReplicationInfo).bStoryMode && ((PlayerController(Killer) != None) || (PlayerController(Other) != None)) )
		{
			if ( AIController(Killer) != None )
				AdjustSkill(AIController(killer), PlayerController(Other), false);
			if ( AIController(Other) != None )
				AdjustSkill(AIController(Other), PlayerController(Killer), true);
		}
	}

	// check score again to see if team won
	if ( (Killer != None) && Killer.PlayerReplicationInfo!=none  )
	{
		if(bScoreTeamKills)
			CheckScore(Killer.PlayerReplicationInfo);

		AnnounceKillTeamScore(Killer.PlayerReplicationInfo);
	}
}

defaultproperties
{
	bHoldingIncrementsScore=false;
}
