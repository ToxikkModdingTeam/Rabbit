class CellDominationHUDMessage extends CRZGameStateMessage;

var(Message) localized string YouHaveCellString;
var(Message) localized string YourTeamHasCellString;
var(Message) localized string EnemyHasCellString;
var(Message) localized string NooneHasCellString;

static function string GetCRZString(
	optional int Switch,
	optional PlayerController P,
	optional PlayerReplicationInfo RelatedPRI_1,
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject
	)
{
	if ( Switch == 0 )
	    return Default.YouHaveCellString;
	else if ( Switch == 1 )
	    return Default.YourTeamHasCellString;
	else if ( Switch == 2 )
		return Default.EnemyHasCellString;
	else
		return Default.NooneHasCellString;
}

static function bool AddAnnouncement(UTAnnouncer Announcer, int MessageIndex, optional PlayerReplicationInfo PRI, optional Object OptionalObject) {}