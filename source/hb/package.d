module hb;

/**
Imports common definitions from vibe.d and provides handy aliases
*/

public import vibe.http.server : HTTPServerRequest, HTTPServerResponse;
alias Req = HTTPServerRequest;
alias Res = HTTPServerResponse;

// TODO: use dlang-requests
public import vibe.http.client : requestHTTP;
alias request = requestHTTP;

public import vibe.http.common : HTTPMethod;
alias POST = HTTPMethod.POST;
alias GET = HTTPMethod.GET;
alias PUT = HTTPMethod.PUT;
alias DELETE = HTTPMethod.DELETE;

public import vibe.http.status : HTTPStatus;
alias ok = HTTPStatus.ok ; // 200
alias created = HTTPStatus.created; // 201
alias accepted = HTTPStatus.accepted; // 202
alias badRequest = HTTPStatus.badRequest; // 401
alias unauthorized = HTTPStatus.unauthorized; // 401
alias forbidden = HTTPStatus.forbidden; // 403
alias notFound = HTTPStatus.notFound; // 404

// shortcuts for throwing exceptions

//void forbidden(string name = "Not authorized to perform this action!")
//{
    //throw new HTTPStatusException(HTTPStatus.forbidden, "Not authorized to perform this action!");
//}

//void notfound(string name = "Not authorized to perform this action!")
//{
    //throw new HTTPStatusException(HTTPStatus.forbidden, "Not authorized to perform this action!");
//}



public import hb.web.web : before, noRoute, path, status;
public import hb.web.auth : anyAuth, auth, noAuth, requiresAuth, Role;


public import vibe.data.json : Json;
public import vibe.data.serialization : ignore, optional;
public import vibe.http.common : enforceHTTP, HTTPStatusException;
