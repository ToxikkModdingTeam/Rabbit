class CellDominationLogMessage extends CRZGameLogMessage;

var(Message) localized string DroppedCell;
var(Message) localized string GrabbedCell;
var(Message) localized string KilledCellHolder;

var SoundNodeWave CellSounds[6];


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
		// grabbed the cell.
		case 1:
			if (RelatedPRI_1 == None)
			{
				return "";
			}
			return class'CRZHudWrapper'.static.GetHTMLPlayerNameFromPRI(RelatedPRI_1,true)@Default.GrabbedCell;

		// Dropped the cell.
		case 2:
			if (RelatedPRI_1 == None)
			{
				return "";
			}
			return class'CRZHudWrapper'.static.GetHTMLPlayerNameFromPRI(RelatedPRI_1,true)@Default.DroppedCell;

		// Killed the cellcarrier.
		case 3:
			if (RelatedPRI_1 == None)
			{
				return "";
			}
			if ( (RelatedPRI_2 != None) && (RelatedPRI_2 != RelatedPRI_1) )
			{
				return class'CRZHudWrapper'.static.GetHTMLPlayerNameFromPRI(RelatedPRI_2,true)@Default.KilledCellHolder;
			}
	}
	return "";
}

static function byte AnnouncementLevel(byte MessageIndex)
{
	return 2;
}

static function SoundNodeWave AnnouncementSound(int MessageIndex, Object OptionalObject, PlayerController PC)
{
	return Default.CellSounds[MessageIndex];
}

static function bool ShouldRemoveFlagAnnouncement(int MyMessageIndex, class<UTLocalMessage> NewAnnouncementClass, int NewMessageIndex)
{
	// check if message is not a flag status announcement
	if (default.Class != NewAnnouncementClass)
	{
		return false;
	}

	// check if messages are for same flag
	if ( ((MyMessageIndex < 7) != (NewMessageIndex < 7)) || (MyMessageIndex == 0) )
	{
		return false;
	}

	if ( MyMessageIndex > 6 )
		MyMessageIndex -= 7;
	if ( NewMessageIndex > 6 )
		NewMessageIndex -= 7;

	if ( MyMessageIndex == 6 )
		return false;
	if ( (NewMessageIndex == 1) || (NewMessageIndex == 3) || (NewMessageIndex == 5) || (NewMessageIndex == 12) || (NewMessageIndex == 0) )
		return true;

	return ( (MyMessageIndex == 2) || (MyMessageIndex == 4) );
}

static function bool AddAnnouncement(UTAnnouncer Announcer, int MessageIndex, optional PlayerReplicationInfo PRI, optional Object OptionalObject)
{
	super.AddAnnouncement(Announcer, MessageIndex, PRI, OptionalObject);

	return (Announcer.PlayingAnnouncementClass == None)
		|| (Announcer.PlayingAnnouncementClass == default.Class) && ShouldRemoveFlagAnnouncement(Announcer.PlayingAnnouncementIndex, default.Class, MessageIndex);
}

static function bool PartiallyDuplicates(INT Switch1, INT Switch2, object OptionalObject1, object OptionalObject2)
{
	return ShouldRemoveFlagAnnouncement(Switch1, default.Class, Switch2);
}

defaultproperties
{
	CellSounds(0)=SoundNodeWave'Snd_Announcer_Status.Wave.VOC_RedCellTaken'
	CellSounds(1)=SoundNodeWave'Snd_Announcer_Status.Wave.VOC_BlueCellTaken'
	CellSounds(2)=SoundNodeWave'Snd_Announcer_Status.Wave.VOC_RedCellDropped'
	CellSounds(3)=SoundNodeWave'Snd_Announcer_Status.Wave.VOC_BlueCellDropped'
	CellSounds(4)=SoundNodeWave'Snd_Announcer_Status.Wave.VOC_YouHaveGotTheCell'
	CellSounds(5)=SoundNodeWave'Snd_Announcer_Status.Wave.VOC_YouHaveLostTheCell'
}

