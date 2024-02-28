// Event class database model
class Event {
  int eventID;
  int eventDescriptionID;
  int eventTypeID;

  Event({
    required this.eventID,
    required this.eventDescriptionID,
    required this.eventTypeID,
  });
}