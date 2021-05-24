part of kingfisher;

enum ResponseType {
  // 20n Successful Response
  ok,
  created,

  // 30n Redirection Responses
  notModified,

  // 40n Client Error
  badRequest,
  forbidden,
  notFound,
  tooManyRequests,

  // 50n Server Error
  serverError,
}

Map<ResponseType, int> defaultResponseCodes = {
  ResponseType.ok: 200,
  ResponseType.created: 201,

  ResponseType.notModified: 304,

  ResponseType.badRequest: 400,
  ResponseType.forbidden: 403,
  ResponseType.notFound: 404,
  ResponseType.tooManyRequests: 429,

  ResponseType.serverError: 500,
};