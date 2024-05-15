import '../../residence/model/pagination_params.dart';
import '../model/cursor_pagination_model.dart';
import '../model/model_with_id.dart';

abstract class IBasePaginationRepository<T extends IModelWithId>{
  Future<CursorPagination<T>> paginate({
    PaginationParams? paginationParams = const PaginationParams(),
  });
}