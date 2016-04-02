class CellDominationGameReplicationInfo extends CRZGameReplicationInfo;

var EFlagState CellState[256];

replication
{
	if (bNetDirty)
		CellState;
}

function SetFlagHome(int TeamIndex)
{
	CellState[TeamIndex] = FLAG_Home;
	bForceNetUpdate = TRUE;
}

simulated function bool FlagIsHome(int TeamIndex)
{
	return ( CellState[TeamIndex] == FLAG_Home );
}

simulated function bool FlagsAreHome()
{
	return ( CellState[0] == FLAG_Home && CellState[1] == FLAG_Home );
}

function SetFlagHeldFriendly(int TeamIndex)
{
	CellState[TeamIndex] = FLAG_HeldFriendly;
}

simulated function bool FlagIsHeldFriendly(int TeamIndex)
{
	return ( CellState[TeamIndex] == FLAG_HeldFriendly );
}

function SetFlagHeldEnemy(int TeamIndex)
{
	CellState[TeamIndex] = FLAG_HeldEnemy;
}

simulated function bool FlagIsHeldEnemy(int TeamIndex)
{
	return ( CellState[TeamIndex] == FLAG_HeldEnemy );
}

function SetFlagDown(int TeamIndex)
{
	CellState[TeamIndex] = FLAG_Down;
}

simulated function bool FlagIsDown(int TeamIndex)
{
	return ( CellState[TeamIndex] == FLAG_Down );
}


DefaultProperties
{

}
