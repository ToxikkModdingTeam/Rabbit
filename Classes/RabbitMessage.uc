class RabbitMessage extends CRZCCMessage;

static function string GetCRZString(
	optional int Switch,
	optional PlayerController P,
	optional PlayerReplicationInfo RelatedPRI_1,
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject
	)
{
	switch (Switch)
	{
		// Captured the flag.
	case 0:
		if (RelatedPRI_1 == None)
			return "";
		return class'CRZHud'.static.GetHTMLPlayerNameFromPRI(RelatedPRI_1,true)@Default.HasRed;
		break;
		// grab the flag.
	case 1:
		if (RelatedPRI_1 == None)
			return "";
		return class'CRZHud'.static.GetHTMLPlayerNameFromPRI(RelatedPRI_1,true)@Default.GrabRed;
		break;

		// Dropped the flag.
	case 2:
		if (RelatedPRI_1 == None)
			return "";
		return class'CRZHud'.static.GetHTMLPlayerNameFromPRI(RelatedPRI_1,true)@Default.DroppedRed;
		break;

		// Killed the flagcarrier.
	case 3:
		if (RelatedPRI_1 == None)
			return "";
		if ( (RelatedPRI_2 != None) && (RelatedPRI_2 != RelatedPRI_1) )
			return class'CRZHud'.static.GetHTMLPlayerNameFromPRI(RelatedPRI_2,true)@Default.KilledRed;
		break;
			
		//Last second Killed the flagcarrier.
	case 4:
		if (RelatedPRI_1 == None)
			return "";
		if ( (RelatedPRI_2 != None) && (RelatedPRI_2 != RelatedPRI_1) )
			return Default.KilledRedLastSecond@class'CRZHud'.static.GetHTMLPlayerNameFromPRI(RelatedPRI_2,true);
		break;
	}
	return "";
}