import '../apiSources/sources.dart';

/// source : {"id":null,"name":"Gizmodo.com"}
/// author : "Kyle Torpey"
/// title : "Why Bitcoin’s Price Is Spiking This Week"
/// description : "Bitcoin’s latest rally comes as Treasury debt buybacks and expanding U.S. sanctions highlight the risks of a dollar-dominated financial system."
/// url : "https://gizmodo.com/why-bitcoins-price-is-spiking-this-week-2000803801"
/// urlToImage : "https://gizmodo.com/app/uploads/2026/08/why-bitcoin-price-is-spiking-1200x675.jpg"
/// publishedAt : "2026-08-27T17:50:23Z"
/// content : "Bitcoin is experiencing an epic rebound. After falling to a low of about $62,650 on Aug. 16, the cryptocurrency climbed to roughly $80,000 this week, putting the rally from that recent bottom at abou… [+5974 chars]"

class Articles {
  Articles({
    this.source,
    this.author,
    this.title,
    this.description,
    this.url,
    this.urlToImage,
    this.publishedAt,
    this.content,
  });

  Articles.fromJson(dynamic json) {
    source = json['source'] != null ? Source.fromJson(json['source']) : null;
    author = json['author'];
    title = json['title'];
    description = json['description'];
    url = json['url'];
    urlToImage = json['urlToImage'];
    publishedAt = json['publishedAt'];
    content = json['content'];
  }

  Source? source;
  String? author;
  String? title;
  String? description;
  String? url;
  String? urlToImage;
  String? publishedAt;
  String? content;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (source != null) {
      map['source'] = source?.toJson();
    }
    map['author'] = author;
    map['title'] = title;
    map['description'] = description;
    map['url'] = url;
    map['urlToImage'] = urlToImage;
    map['publishedAt'] = publishedAt;
    map['content'] = content;
    return map;
  }
}
