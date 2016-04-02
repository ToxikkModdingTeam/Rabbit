class CellDominationHud extends CRZHudWrapper;

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
		CellDomination(WorldInfo.Game).CellDominationCell != None &&
		CellDomination(WorldInfo.Game).CellDominationCell.Holder != None
	)
	{
		PlayerOwner.ReceiveLocalizedMessage( class'CellDominationHUDMessage', 2 );
	}
	else
	{
		PlayerOwner.ReceiveLocalizedMessage( class'CellDominationHUDMessage', 3 );
	}

}

defaultproperties
{

}