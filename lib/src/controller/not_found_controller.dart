part of kingfisher;

class _NotFoundController<T> extends RouteController<T> {
  @override
  FutureOr<NotFoundResponse<T>> handle(RouteRequest<T> request) {
    return NotFoundResponse("No case implemented to handle an un found endpoint");
  }
}
