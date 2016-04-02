class TeamCellDominationHud extends CRZTeamHudWrapper;

simulated function Timer()
{
	local UTPlayerReplicationInfo PawnOwnerPRI;

	Super.Timer();

	if ( Pawn(PlayerOwner.ViewTarget) == None ) return;

	PawnOwnerPRI = UTPlayerReplicationInfo(Pawn(PlayerOwner.ViewTarget).PlayerReplicationInfo);

	if (PawnOwnerPRI == None) return;

	if ( PawnOwnerPRI.bHasFlag )
	{
		PlayerOwner.ReceiveLocalizedMessage( class'CellDominationHUDMessage', 0 );
	}
	else if (
		TeamCellDomination(WorldInfo.Game).CellDominationCell != None &&
		TeamCellDomination(WorldInfo.Game).CellDominationCell.Holder != None
	)
	{
	    if (TeamCellDomination(WorldInfo.Game).CellDominationCell.IsHeldBySameTeam(PawnOwnerPRI.Team.TeamIndex))
		{
			PlayerOwner.ReceiveLocalizedMessage( class'CellDominationHUDMessage', 1 );
		}
		else
		{
			PlayerOwner.ReceiveLocalizedMessage( class'CellDominationHUDMessage', 2 );
		}
	}
	else
	{
		PlayerOwner.ReceiveLocalizedMessage( class'CellDominationHUDMessage', 3 );
	}
}

defaultproperties
{

}