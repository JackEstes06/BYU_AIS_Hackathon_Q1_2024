// EventDescription class database model
class EventDescription {
  int eventDescriptionID;
  String eventTitle;
  DateTime eventDateTime;
  String eventLocation;
  String eventInfo;

  EventDescription({
    required this.eventDescriptionID,
    required this.eventTitle,
    required this.eventDateTime,
    required this.eventLocation,
    required this.eventInfo,
  });
}