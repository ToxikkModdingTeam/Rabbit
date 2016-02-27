/**
 * @author Thorsten 'stepo' Hallwas
 */
class NavigationHelper extends Actor;

var array<UDKGameObjective> UDKGameObjectives;
var Vector Center;

/**
 * Collects all available NavigationPoint on the map.
 * @return array<UDKGameObjective>
 */
function array<UDKGameObjective> GetAvailableUDKGameObjectives()
{
	local UDKGameObjective GO;
	local float Y,Z,X;
	local int amount;

	if (UDKGameObjectives.Length == 0)
	{
		foreach WorldInfo.AllNavigationPoints(class'UDKGameObjective', GO)
		{
			UDKGameObjectives.AddItem(GO);
			X = X + GO.Location.X;
			Y = Y + GO.Location.Y;
			Z = Z + GO.Location.Z;
			amount++;
		}

		Center.X = X / amount;
		Center.Y = Y / amount;
		Center.Z = Z / amount;
		UDKGameObjectives.Sort(CompareNavigationPointDistance);
	}

	return UDKGameObjectives;
}

/**
 * Returns a navigationpoint that is close to the center. The bigger the index the further away it is from it.
 * @return UDKGameObjective 
 */
function UDKGameObjective GetCenterUDKGameObjective(int index)
{
	GetAvailableUDKGameObjectives();

	return UDKGameObjectives[index];
}

/**
 * Compares the Distance of two UDKGameObjectives.
 * @return int
 */
delegate int CompareNavigationPointDistance(UDKGameObjective NavigationPointA, UDKGameObjective NavigationPointB)
{
	local float SizeA, SizeB;
	SizeA = VSize(NavigationPointA.Location - Center);
	SizeB = VSize(NavigationPointB.Location - Center);
	if (SizeA > SizeB)
	{
		return -1;
	}
	else if (SizeA == SizeB)
	{
		return 0;
	}
	else
	{
	    return 1;
	}
}

DefaultProperties
{
}
