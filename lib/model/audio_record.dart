class AudioRecords{
  List<AudioRecord>? recordsList;

  AudioRecords({this.recordsList});

  AudioRecords.fromJson(Map<String, dynamic> json) {
    if (json['recordsList'] != null) {
      recordsList = new List<AudioRecord>.empty(growable: true);
      json['recordsList'].forEach((v) {
        recordsList!.add(new AudioRecord.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.recordsList != null) {
      data['recordsList'] =
          this.recordsList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AudioRecord{
  String? id;
  String? filePath;
  String? title;
  String? date;
  String? length;

  AudioRecord({
    this.id,
    this.filePath,
    this.title,
    this.date,
    this.length
  });

  AudioRecord.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    filePath = json['filePath'];
    title = json['title'];
    date = json['date'];
    length = json['length'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['filePath'] = this.filePath;
    data['title'] = this.title;
    data['date'] = this.date;
    data['length'] = this.length;

    return data;
  }
}