// pagination 구현을 위한 id가 필수적이게끔 OOP
abstract class IModelWithId {
  final int id;

  IModelWithId({
    required this.id,
  });
}