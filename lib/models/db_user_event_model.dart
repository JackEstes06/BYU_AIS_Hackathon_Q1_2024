// UserEvent class database model
class UserEvent {
  int userEventID;
  int userID;
  int eventID;
  bool isAttended;

  UserEvent({
    required this.userEventID,
    required this.userID,
    required this.eventID,
    required this.isAttended,
  });
}