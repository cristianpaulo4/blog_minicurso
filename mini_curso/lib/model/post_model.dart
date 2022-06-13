class PostModel {
  Data? data;

  PostModel({this.data});

  PostModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  List<Post>? post;

  Data({this.post});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['post'] != null) {
      post = <Post>[];
      json['post'].forEach((v) {
        post!.add(new Post.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.post != null) {
      data['post'] = this.post!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Post {
  int? id;
  String? texto;

  Post({this.id, this.texto});

  Post.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    texto = json['texto'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['texto'] = this.texto;
    return data;
  }
}