part of kingfisher;

enum ResponseType {
  // 10n Informational
  continue_,

  // 20n Successful Response
  ok,
  created,

  // 30n Redirection Responses
  notModified,
  seeOther,

  // 40n Client Error
  unauthorized,
  badRequest,
  forbidden,
  notFound,
  tooManyRequests,

  // 50n Server Error
  serverError,
}

const Map<ResponseType, int> defaultResponseCodes = {
  ResponseType.continue_: 100,
  ResponseType.ok: 200,
  ResponseType.created: 201,
  ResponseType.seeOther: 303,
  ResponseType.notModified: 304,
  ResponseType.badRequest: 400,
  ResponseType.unauthorized: 401,
  ResponseType.forbidden: 403,
  ResponseType.notFound: 404,
  ResponseType.tooManyRequests: 429,
  ResponseType.serverError: 500,
};
