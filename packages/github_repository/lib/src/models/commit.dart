import 'package:equatable/equatable.dart';

class Commit extends Equatable {
  const Commit({
    this.htmlUrl,
    this.sha,
    this.nodeId,
    this.committer,
  });

  final String? htmlUrl;
  final String? sha;
  final String? nodeId;
  final Committer? committer;

  factory Commit.fromJson(Map<String, dynamic> json) => Commit(
        htmlUrl: json["html_url"] as String,
        sha: json["sha"] as String,
        nodeId: json["node_id"] as String,
        committer: Committer.fromJson(json["committer"]),
      );

  Map<String, dynamic> toJson() => {
        "html_url": htmlUrl,
        "sha": sha,
        "node_id": nodeId,
        "committer": committer!.toJson(),
      };

  Commit copyWith({
    String? htmlUrl,
    String? sha,
    String? nodeId,
    Committer? committer,
  }) {
    return Commit(
      htmlUrl: htmlUrl ?? this.htmlUrl,
      sha: sha ?? this.sha,
      nodeId: nodeId ?? this.nodeId,
      committer: committer ?? this.committer,
    );
  }

  @override
  List<Object?> get props => [
        htmlUrl,
        sha,
        nodeId,
        committer,
      ];
}

class Committer extends Equatable {
  const Committer({
    this.id,
    this.login,
    this.avatarUrl,
    this.profileUrl,
  });

  final int? id;
  final String? login;
  final String? avatarUrl;
  final String? profileUrl; // html_url

  factory Committer.fromJson(Map<String, dynamic> json) => Committer(
        id: json["id"] as int,
        login: json["login"] as String,
        avatarUrl: json["avatar_url"] as String,
        profileUrl: json["html_url"] as String,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "login": login,
        "avatar_url": avatarUrl,
        "html_url": profileUrl,
      };

  Committer copyWith({
    int? id,
    String? login,
    String? avatarUrl,
    String? profileUrl,
  }) {
    return Committer(
      id: id ?? this.id,
      login: login ?? this.login,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      profileUrl: profileUrl ?? this.profileUrl,
    );
  }

  @override
  List<Object?> get props => [
        id,
        login,
        avatarUrl,
        profileUrl,
      ];
}

class CommitDetails extends Equatable {
  const CommitDetails({
    this.author,
    this.committer,
    this.message,
    this.commentCount,
  });

  final Map<String, dynamic>? author;
  final Map<String, dynamic>? committer;
  final String? message;
  final int? commentCount;

  factory CommitDetails.fromJson(Map<String, dynamic> json) => CommitDetails(
        author: json["author"] as Map<String, dynamic>,
        committer: json["committer"] as Map<String, dynamic>,
        message: json["message"] as String,
        commentCount: json["comment_count"] as int,
      );

  Map<String, dynamic> toJson() => {
        "author": author,
        "committer": committer,
        "message": message,
        "comment_count": commentCount,
      };

  CommitDetails copyWith({
    Map<String, dynamic>? author,
    Map<String, dynamic>? committer,
    String? message,
    int? commentCount,
  }) {
    return CommitDetails(
      author: author ?? this.author,
      committer: committer ?? this.committer,
      message: message ?? this.message,
      commentCount: commentCount ?? this.commentCount,
    );
  }

  @override
  List<Object?> get props => [
        author,
        committer,
        message,
        commentCount,
      ];
}
