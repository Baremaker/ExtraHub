/// Caminhos do Firestore como funções tipadas.
///
/// Sempre que precisar de uma referência a um documento ou coleção, use
/// estas funções em vez de strings literais. Isso elimina typos e
/// centraliza a estrutura de dados em um lugar.
///
/// Exemplo:
/// ```dart
/// FirebaseFirestore.instance.doc(FirestorePaths.user(uid));
/// ```
class FirestorePaths {
  FirestorePaths._();

  // ─── COLEÇÕES TOP-LEVEL ──────────────────────────────────────────────────
  static const String users   = 'users';
  static const String extras  = 'extras';
  static const String invites = 'invites';

  // ─── DOCUMENTOS TOP-LEVEL ────────────────────────────────────────────────
  static String user(String uid)    => '$users/$uid';
  static String extra(String id)    => '$extras/$id';
  static String invite(String id)   => '$invites/$id';

  // ─── SUBCOLEÇÕES DE EXTRA ────────────────────────────────────────────────
  static String members(String extraId)        => '${extra(extraId)}/members';
  static String projects(String extraId)       => '${extra(extraId)}/projects';
  static String announcements(String extraId)  => '${extra(extraId)}/announcements';
  static String events(String extraId)         => '${extra(extraId)}/events';

  // ─── DOCUMENTOS DE SUBCOLEÇÕES ───────────────────────────────────────────
  static String member(String extraId, String uid)              => '${members(extraId)}/$uid';
  static String project(String extraId, String projectId)       => '${projects(extraId)}/$projectId';
  static String announcement(String extraId, String aid)        => '${announcements(extraId)}/$aid';
  static String event(String extraId, String eid)               => '${events(extraId)}/$eid';
}
