# hb-web

Fork of vibe.d's web interface for increased convenience.


Auto injection
---------------

- `HTTPServer{Request, Response}` (and `HTTP{Request, Response}`)
- `Json payload`
- `string _param` -> `/:param/` (if not annotated with UDAs, in order)
- `string _error` (if processed with `errorDisplay`)

If `POST` or `PUT` the first object will be automatically serialized from `req.json`

```d
auto post(Offer offer) {  ... }
```

Common aliases
--------------

```d
redirect(string url)
header(string key, string val)
status(int statusCode)
```

`@before` / `@after`
--------------------

```d
struct AuthInfo {}
private enum auth = before!checkAuth("_auth");

private AuthInfo checkAuth(HTTPServerRequest req, HTTPServerResponse res)
{
    if (!cond) throw new HTTPStatusException(HTTPStatus.forbidden, "Not authorized to perform this action!");
    return AuthInfo();
}

class UserService {
    void getFoo(AuthInfo _auth) {
        ...
    }
}
```

@path
-----

```d
@path("/users")
class UserService {
    @path("/foo/:bar")
    void getFoo(string _bar) {
        ...
    }
}
```

- For `hb.web` `@path` is automatically generated for non-attributed _underscored variables (TODO: is this convention worth it?)
- The default is `@rootPathFromName`
- `MethodStyle`: method name -> URL path.

SessionVar
----------

Convenient on-demand access to session variables.

```d
class UserService {
    private {
        SessionVar!(string, "login_user") m_loginUser;
    }

}
```

@method
-------

```d
import vibe.http.common : HTTPMethod;
class UserService {
    @method!(HTTPMethod.POST)
    void getFoo(string _bar) {
        ...
    }

    // alias.d shorthand
    @method!POST
    void getBar(string _bar) {
        ...
    }
}
```


@contentType
------------

```d
class UserService {
    @contentType("image/svg+xml")
    void getFoo(HTTPResponse res) {
        res.writeBody("<svg><circle fill="red" /></svg> ");
    }
}
```

Exceptions
----------

- `enforceHTTP(username > 0, HTTPStatus.forbidden);`
- `enforceBadRequest(length > 0)`

```
throw new HTTPStatusException(HTTPStatus.forbidden, "Not authorized to perform this action!")
```

```
@errorDisplay
```

`@requiresAuth` and @auth
-------------------------

```d
@requiresAuth
class Offers
{
    struct AuthInfo {
        bool premium;
        bool admin;
        string userId;
        bool isAdmin() { return this.admin; }
        bool isPremiumUser() { return this.premium; }
    }

    @noRoute
    AuthInfo authenticate(HTTPServerRequest req, HTTPServerResponse res)
    {
        if (!isLoggedIn(req)) throw new HTTPStatusException(HTTPStatus.forbidden, "Not authorized to perform this action!");
        auto user = req.session.get!User["user"];
        return AuthInfo();
    }

    @anyAuth
    Offer getA(string offerId)
    {
        ...
    }

    @noAuth
    auto getB(string _offerId)
    {
        ...
    }

    @auth(Role.admin | Role.premiumUser)
    auto post(Offer offer)
    {
        return offer;
    }
} 
```

- every public method needs to be annotated with `@noAuth`, `@anyAuth` or `@auth`  

Middlewares
-----------

```d
// setup all routes
auto router = new URLRouter;
router.get("/", ...);

// start with the router request handler
HTTPServerRequestHandler handler = &router.handleRequest;

// successively add middleware
handler = addLogger(handler);
handler = addBasicAuth(handler);

// start the HTTP server
listenHTTP(settings, handler);

HTTPServerRequestHandler addLogger(HTTPServerRequestHander handler)
{
    return (req, res) {
        logInfo("Start handling request %s", req.requestURL);
        handler(req, res);
        logInfo("Finished handling request.");
    }
}
```
