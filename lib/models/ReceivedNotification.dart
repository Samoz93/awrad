import 'dart:convert';

class ReceivedNotification {
  int id;
  String title;
  String body;
  String payload;
  ReceivedNotification({
    this.id,
    this.title,
    this.body,
    this.payload,
  });

  ReceivedNotification copyWith({
    int id,
    String title,
    String body,
    String payload,
  }) {
    return ReceivedNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      payload: payload ?? this.payload,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'payload': payload,
    };
  }

  static ReceivedNotification fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return ReceivedNotification(
      id: map['id'],
      title: map['title'],
      body: map['body'],
      payload: map['payload'],
    );
  }

  String toJson() => json.encode(toMap());

  static ReceivedNotification fromJson(String source) =>
      fromMap(json.decode(source));

  @override
  String toString() {
    return 'IosNotificationData(id: $id, title: $title, body: $body, payload: $payload)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is ReceivedNotification &&
        o.id == id &&
        o.title == title &&
        o.body == body &&
        o.payload == payload;
  }

  @override
  int get hashCode {
    return id.hashCode ^ title.hashCode ^ body.hashCode ^ payload.hashCode;
  }
}
